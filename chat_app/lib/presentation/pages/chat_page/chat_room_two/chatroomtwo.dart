import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:chat_app/domain/entities/user_active_entity.dart';
import 'package:chat_app/presentation/bloc/message_setting/message_setting_bloc.dart';
import 'package:chat_app/presentation/pages/chat_page/chat_room_two/custom_chatroom_theme.dart';
import 'package:chat_app/presentation/pages/chat_page/chat_room_two/option.dart';
import 'package:chat_app/utils/account.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mime/mime.dart';
import 'package:open_file/open_file.dart';
import 'package:skeleton_loader/skeleton_loader.dart';
import 'package:uuid/uuid.dart';

import '../../../../configs/colorconfig.dart';
import '../../../../configs/fontconfig.dart';
import '../../../../dependencies_injection.dart';
import '../../../../domain/entities/room_overview_entity.dart';
import '../../../../helper/helper.dart';
import '../../../bloc/chat_detail/chat_detail_bloc.dart';
import '../../calling_page/call_sample.dart';

class ChatRoom extends StatefulWidget {
  final RoomOverviewEntity roomOverview;
  const ChatRoom({Key? key, required this.roomOverview}) : super(key: key);

  @override
  _ChatRoomState createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> {
  final _user =  types.User(id: Account.instance!.id); // id of current user
  late final ChatDetailBloc _chatDetailBloc;
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    log('init state chat room two view');
    _scrollController = ScrollController();
    _chatDetailBloc = BlocProvider.of<ChatDetailBloc>(context);
    // _chatDetailBloc.add(ChatDetailLoadInit(roomId: widget.roomOverview.id));

    _scrollController.addListener(_fetchWhenScroll);
  }

  @override
  void dispose() {
    // _scrollController.dispose();
    // _chatDetailBloc.dispose();
    super.dispose();
  }

  void _fetchWhenScroll() {
    if (_scrollController.offset >=
            _scrollController.position.maxScrollExtent &&
        !_scrollController.position.outOfRange) {
      log("reach the bottom");

      if (!_chatDetailBloc.state.isLoading &&
          !_chatDetailBloc.state.isLoadFull) {
        _chatDetailBloc.add(ChatDetailLoad(
          number: 10,
          roomId: widget.roomOverview.id,
          startIndex: _chatDetailBloc.state.listSortedMessage.length,
        ));
      }
    }
    if (_scrollController.offset <=
            _scrollController.position.minScrollExtent &&
        !_scrollController.position.outOfRange) {
      log("reach the top");
    }
  }

  void _handleAtachmentPressed() {
    showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: SizedBox(
            height: 144,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    _handleImageSelection();
                  },
                  child: Align(
                    alignment: AlignmentDirectional.centerStart,
                    child: Text(
                      'Photo',
                      style: kText15RegularMain,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    _handleFileSelection();
                  },
                  child: Align(
                    alignment: AlignmentDirectional.centerStart,
                    child: Text('File', style: kText15RegularMain),
                  ),
                ),
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Align(
                    alignment: AlignmentDirectional.centerStart,
                    child: Text('Hủy', style: kText15RegularMain),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _handleFileSelection() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.any,
    );

    if (result != null && result.files.single.path != null) {
      final message = types.FileMessage(
        author: _user,
        createdAt: DateTime.now().millisecondsSinceEpoch,
        id: const Uuid().v4(),
        mimeType: lookupMimeType(result.files.single.path!),
        name: result.files.single.name,
        size: result.files.single.size,
        uri: result.files.single.path!,
      );

      _chatDetailBloc.add(ChatDetailSend(
        content: null,
        roomId: widget.roomOverview.id,
        file: File(result.files.single.path!),
      ));
    }
  }

  void _handleImageSelection() async {
    final result = await ImagePicker().pickImage(
      imageQuality: 70,
      maxWidth: 1440,
      source: ImageSource.gallery,
    );

    if (result != null) {
      final bytes = await result.readAsBytes();
      final image = await decodeImageFromList(bytes);

      final message = types.ImageMessage(
        author: _user,
        createdAt: DateTime.now().millisecondsSinceEpoch,
        height: image.height.toDouble(),
        id: const Uuid().v4(),
        name: result.name,
        size: bytes.length,
        uri: result.path,
        width: image.width.toDouble(),
      );

      _chatDetailBloc.add(ChatDetailSend(
        content: null,
        roomId: widget.roomOverview.id,
        file: File(result.path),
      ));
    }
  }

  void _handleMessageTap(BuildContext context, types.Message message) async {
    if (message is types.FileMessage) {
      await OpenFile.open(message.uri);
    }
  }

  // void _handlePreviewDataFetched(
  //   types.TextMessage message,
  //   types.PreviewData previewData,
  // ) {
  //   final index = _messages.indexWhere((element) => element.id == message.id);
  //   final updatedMessage = _messages[index].copyWith(previewData: previewData);

  //   WidgetsBinding.instance?.addPostFrameCallback((_) {
  //     setState(() {
  //       _messages[index] = updatedMessage;
  //     });
  //   });
  // }

  void _handleSendPressed(types.PartialText message) {
    final textMessage = types.TextMessage(
      author: _user,
      createdAt: DateTime.now().millisecondsSinceEpoch,
      id: const Uuid().v4(),
      text: message.text,
    );

    _chatDetailBloc.add(ChatDetailSend(
        content: message.text, roomId: widget.roomOverview.id, file: null));
  }

  // void _loadMessages() async {
  //   final response = await rootBundle.loadString('assets/messages.json');
  //   final messages = (jsonDecode(response) as List)
  //       .map((e) => types.Message.fromJson(e as Map<String, dynamic>))
  //       .toList();

  //   setState(() {
  //     _messages = messages;
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: getAppBar(),
        body: SafeArea(
          bottom: false,
          child: BlocBuilder<ChatDetailBloc, ChatDetailState>(
            builder: (context, state) {
              if (state is ChatDetailState) {
                return Chat(
                    scrollController: _scrollController,
                    showUserAvatars: true,
                    showUserNames: true,
                    messages:
                        parsedEntityMessageToMessages(state.listSortedMessage),
                    onAttachmentPressed: _handleAtachmentPressed,
                    onMessageTap: _handleMessageTap,
                    //onPreviewDataFetched: _handlePreviewDataFetched,
                    onSendPressed: _handleSendPressed,
                    user: _user,
                    theme: CustomChatroomTheme,
                    emptyState: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Icon(
                          FontAwesomeIcons.commentDots,
                          color: cwColorGreyNoteText,
                          size: 160,
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Text(
                          "Oh, hãy bắt đầu cuộc trò chuyện nào!",
                          style: kText15RegularGreyNotetext,
                        )
                      ],
                    ));
              } else {
                return const Text('Load fail');
              }
            },
          ),
        ));
  }

  AppBar getAppBar() {
    return AppBar(
        iconTheme: const IconThemeData(color: cwColorBlackIcon),
        backgroundColor: cwColorBackground,
        elevation: 0,
        centerTitle: false,
        toolbarHeight: 100.h,
        titleSpacing: 0,
        title: Row(
          children: [
            CircleAvatar(
                radius: 22.w,
                backgroundImage: widget.roomOverview.avatarUrl == null
                    ? const AssetImage("assets/images/defauldavatar.png")
                        as ImageProvider
                    : NetworkImage(widget.roomOverview.avatarUrl!)),
            SizedBox(
              width: 5.w,
            ),
            SizedBox(
              width: 130.w,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    widget.roomOverview.name,
                    style: kText15MediumBlack, 
                    overflow: TextOverflow.clip
                  ),
                  Text(
                    "online",
                    style: kText13RegularNote,
                  )
                ],
              ),
            )
          ],
        ),
        actions: [
          IconButton(
            padding: const EdgeInsets.all(0),
            icon: Icon(
              Icons.phone,
              size: 25.w,
              color: cwColorMain,
            ),
            onPressed: () {},
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 5),
            child: IconButton(
                padding: const EdgeInsets.all(0),
                icon: Icon(
                  FontAwesomeIcons.video,
                  size: 25.w,
                  color: cwColorMain,
                ),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (BuildContext context) =>
                              CallSample()));
                }),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(0, 0, 0, 10.h),
            child: PopupMenuButton(
              padding: const EdgeInsets.all(0),
              icon: Icon(
                FontAwesomeIcons.ellipsisV,
                color: cwColorMain,
                size: 20.w,
              ),
              itemBuilder: (BuildContext context) => <PopupMenuEntry>[
                PopupMenuItem(
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => BlocProvider(
                                  create: (context) => MessageSettingBloc(sl()),
                                  child: OptionChatRoom(
                                    room: widget.roomOverview,
                                  ),
                                )),
                      );
                    },
                    child: const ListTile(
                      title: Text('Tùy chọn'),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ]);
  }
}

class SkeletonloaderChatRoom extends StatelessWidget {
  const SkeletonloaderChatRoom({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SkeletonLoader(
      builder: Container(
        child: Text(
          "Đang tải....",
          style: kText15RegularGreyNotetext,
        ),
        color: cwColor25BackgroundButton,
      ),
      items: 1,
      period: const Duration(seconds: 2),
      highlightColor: const Color(0x505AA469),
      direction: SkeletonDirection.ltr,
    );
  }
}
