import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:isolate';
import 'dart:ui';

import 'package:chat_app/configs/colorconfig.dart';
import 'package:chat_app/configs/fontconfig.dart';
import 'package:chat_app/helper/helper.dart';
import 'package:chat_app/presentation/bloc/message_setting/message_setting_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
 
import 'package:path_provider/path_provider.dart';

class FileAndImage extends StatefulWidget {
  final String roomId;
  const FileAndImage({Key? key, required this.roomId}) : super(key: key);

  @override
  State<FileAndImage> createState() => _FileAndImageState();
}

class _FileAndImageState extends State<FileAndImage>
    with TickerProviderStateMixin {
  late TabController _tabController;
  late ScrollController _scrollImage;
  late ScrollController _scrollFile;
  ReceivePort _port = ReceivePort();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _scrollImage = ScrollController();
    _scrollFile = ScrollController();

    _fetchMoreImages();
    _downloadListener();
  }
  // static void downloadCallback(
  //     String id, DownloadTaskStatus status, int progress) {
  //   final SendPort? send =
  //       IsolateNameServer.lookupPortByName('downloader_send_port');
  //   send!.send([id, status, progress]);
  // }
  @pragma('vm:entry-point')
  static void downloadCallback(String id, DownloadTaskStatus status, int progress) {
  final SendPort? send = IsolateNameServer.lookupPortByName('downloader_send_port');
  send!.send([id, status, progress]);
}

  _downloadListener() {
      IsolateNameServer.registerPortWithName(_port.sendPort, 'downloader_send_port');
  _port.listen((dynamic data) {
    String id = data[0];
    DownloadTaskStatus status = data[1];
    int progress = data[2];
     if (status.toString() == "DownloadTaskStatus(3)" && progress == 100 && id != null) {
        FlutterDownloader.open(taskId: id);
      }
    setState((){ });
  });

  FlutterDownloader.registerCallback(downloadCallback);
  }

  void _fetchMoreImages() {
    final _bloc = BlocProvider.of<MessageSettingBloc>(context);
    if (_bloc.state is! MessageSettingImageFileState ||
        !_scrollImage.hasClients) {
      return;
    }
    final state = _bloc.state as MessageSettingImageFileState;
    if (_scrollImage.offset >= _scrollImage.position.maxScrollExtent &&
        !_scrollImage.position.outOfRange) {
      log("reach the bottom");

      if (!state.isLoading && !state.isImageFull) {
        _bloc.add(MessageSettingLoadImageFile(
          roomId: widget.roomId,
          number: 10,
          startIndex: state.imagesUri.length,
          typeLoad: 'image',
        ));
      }
    }
  }

  void _fetchMoreFiels() {
    final _bloc = BlocProvider.of<MessageSettingBloc>(context);
    if (_bloc.state is! MessageSettingImageFileState ||
        !_scrollFile.hasClients) {
      return;
    }
    final state = _bloc.state as MessageSettingImageFileState;
    if (_scrollFile.offset >= _scrollFile.position.maxScrollExtent &&
        !_scrollFile.position.outOfRange) {
      log("reach the bottom");

      if (!state.isLoading && !state.isFileFull) {
        _bloc.add(MessageSettingLoadImageFile(
          roomId: widget.roomId,
          number: 10,
          startIndex: state.files.length,
          typeLoad: 'file',
        ));
      }
    }
  }

  @override
  void dispose() {
    _scrollImage.dispose();
    _scrollFile.dispose();
    _tabController.dispose();
     IsolateNameServer.removePortNameMapping('downloader_send_port');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MessageSettingBloc, MessageSettingState>(
      builder: (context, state) {
        if (state is! MessageSettingImageFileState) {
          return const Text('fail');
        }
        return Scaffold(
          backgroundColor: cwColorWhite,
          appBar: getAppBar(),
          body: NestedScrollView(
            floatHeaderSlivers: true,
            headerSliverBuilder: (context, value) {
              return [
                SliverAppBar(
                  pinned: true,
                  stretch: true,
                  floating: true,
                  automaticallyImplyLeading: false,
                  backgroundColor: Colors.white,
                  title: TabBar(
                    indicator: const UnderlineTabIndicator(
                        borderSide: BorderSide(
                          width: 2,
                          color: cwColorMain,
                        ),
                        insets: EdgeInsets.only(left: 0, right: 8, bottom: 4)),
                    unselectedLabelColor: cwColorGreyNoteText,
                    controller: _tabController,
                    labelColor: cwColorMain,
                    labelStyle: kText15BoldMain,
                    isScrollable: true,
                    tabs: const [
                      Tab(text: "Hình ảnh "),
                      Tab(text: "File"),
                    ],
                    onTap: (index) {
                      setState(() {});
                    },
                  ),
                ),
              ];
            },
            body: _tabController.index == 0
                ? getImageGrid(state.imagesUri)
                : getFiles(state.files),
          ),
        );
      },
    );
  }

  Widget getFiles(List files) {
    return files.isEmpty
        ? Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Icon(
                FontAwesomeIcons.folderOpen,
                color: cwColorGreyNoteText,
                size: 160,
              ),
              const SizedBox(
                height: 20,
              ),
              Text(
                "File trống!",
                style: kText15RegularGreyNotetext,
              )
            ],
          )
        : ListView.builder(
            controller: _scrollFile,
            itemCount: files.length,
            itemBuilder: (context, index) {
              final args = jsonDecode(files[index]["args"] as String)
                  as Map<String, dynamic>;
              return FileItem(
                name: args['nameFile'],
                size: args['size'].toString(),
                path: files[index]["content"] as String,
              );
            });
  }

  Widget getImageGrid(List imagesUri) {
    return imagesUri.isEmpty
        ? Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Icon(
                FontAwesomeIcons.image,
                color: cwColorGreyNoteText,
                size: 160,
              ),
              const SizedBox(
                height: 20,
              ),
              Text(
                "Chưa có ảnh!",
                style: kText15RegularGreyNotetext,
              )
            ],
          )
        : GridView.builder(
            controller: _scrollImage,
            primary: false,
            padding: const EdgeInsets.all(20),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),
            itemCount: imagesUri.length,
            itemBuilder: (BuildContext context, int index) {
              return InkWell(
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      image: DecorationImage(
                          image: NetworkImage(
                              parseToServerUri(imagesUri[index]['content'])),
                          fit: BoxFit.cover)),
                ),
                onTap: () => {},
              );
            },
          );
  }

  AppBar getAppBar() {
    return AppBar(
      iconTheme: const IconThemeData(color: cwColorBlackIcon),
      backgroundColor: cwColorBackground,
      centerTitle: true,
      elevation: 0,
      toolbarHeight: 70.h,
      title: Text("File và hình ảnh ", style: kText20MediumBlack),
    );
  }
}

class FileItem extends StatelessWidget {
  final String name;
  final String size;
  final String path;
  const FileItem(
      {Key? key, required this.name, required this.size, required this.path})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Container(
        decoration: BoxDecoration(
            color: cwColorBackground, borderRadius: BorderRadius.circular(10)),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 15.h, horizontal: 10.w),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.summarize,
                color: cwColorBlack,
              ),
              SizedBox(
                width: 10.w,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: kText15BoldBlack,
                      overflow: TextOverflow.clip,
                    ),
                    SizedBox(
                      height: 5.h,
                    ),
                    Text(
                      size + "b",
                      style: kText10RegularBlack,
                    )
                  ],
                ),
              ),
              IconButton(
                  onPressed: () => {_download(path)},
                  icon: const Icon(
                    Icons.file_download,
                    color: cwColorBlack,
                  ))
            ],
          ),
        ),
      ),
    );
  }
}

void _download(String url) async {
  String _localPath =
      (await findLocalPath()) + Platform.pathSeparator + 'Example_Downloads';

  final savedDir = Directory(_localPath);
  bool hasExisted = await savedDir.exists();
  if (!hasExisted) {
    savedDir.create();
  }
  final download = await FlutterDownloader.enqueue(
    url: parseToServerUri(url),
    savedDir: _localPath,
    showNotification: true,
    openFileFromNotification: true,
  );
}

Future<String> findLocalPath() async {
  final directory =
      // (MyGlobals.platform == "android")
      // ?
      await getExternalStorageDirectory();
  // : await getApplicationDocumentsDirectory();
  return directory!.path;
}
