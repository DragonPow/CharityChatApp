import 'package:chat_app/configs/colorconfig.dart';
import 'package:chat_app/configs/fontconfig.dart';
import 'package:chat_app/helper/helper.dart';
import 'package:chat_app/presentation/bloc/message_setting/message_setting_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class FileAndImage extends StatefulWidget {
  const FileAndImage({Key? key}) : super(key: key);

  @override
  State<FileAndImage> createState() => _FileAndImageState();
}

class _FileAndImageState extends State<FileAndImage>
    with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
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
    return Column(
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
    );
  }

  GridView getImageGrid(List imagesUri) {
    return GridView.builder(
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
                    image: NetworkImage(parseToServerUri(imagesUri[index]['content'])), fit: BoxFit.cover)),
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
