import 'dart:convert';

import 'package:chat_app/presentation/pages/chat_page/chat_room_two/custom_chatroom_theme.dart';
import 'package:chat_app/presentation/pages/chat_page/chat_room_two/option.dart';
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
import '../../../../helper/helper.dart';
import '../../../bloc/chat_detail/chat_detail_bloc.dart';

class ChatRoom extends StatefulWidget {
  const ChatRoom({Key? key}) : super(key: key);

  @override
  _ChatRoomState createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> {
  List<types.Message> _messages = [];
  final _user = const types.User(id: '00'); // id of current user
  var _chatDetailBloc;

  @override
  void initState() {
    super.initState();
    _chatDetailBloc = BlocProvider.of<ChatDetailBloc>(context);
    _chatDetailBloc.add(
        const ChatDetailLoadMessage(number: 10, roomId: "1", startIndex: 0));

    //_loadMessages();
  }
 @override
  void dispose() {
  //  _chatDetailBloc.dispose();
    super.dispose();
  }
  void _addMessage(types.Message message) {
    setState(() {
      _messages.insert(0, message);
    });
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

      _addMessage(message);
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

      _addMessage(message);
    }
  }

  void _handleMessageTap(BuildContext context, types.Message message) async {
    if (message is types.FileMessage) {
      await OpenFile.open(message.uri);
    }
  }

  void _handlePreviewDataFetched(
    types.TextMessage message,
    types.PreviewData previewData,
  ) {
    final index = _messages.indexWhere((element) => element.id == message.id);
    final updatedMessage = _messages[index].copyWith(previewData: previewData);

    WidgetsBinding.instance?.addPostFrameCallback((_) {
      setState(() {
        _messages[index] = updatedMessage;
      });
    });
  }

  void _handleSendPressed(types.PartialText message) {
    final textMessage = types.TextMessage(
      author: _user,
      createdAt: DateTime.now().millisecondsSinceEpoch,
      id: const Uuid().v4(),
      text: message.text,
    );

    _addMessage(textMessage);
  }

  void _loadMessages() async {
    final response = await rootBundle.loadString('assets/messages.json');
    final messages = (jsonDecode(response) as List)
        .map((e) => types.Message.fromJson(e as Map<String, dynamic>))
        .toList();

    setState(() {
      _messages = messages;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: getAppBar(),
        body: SafeArea(
          bottom: false,
          child: BlocBuilder<ChatDetailBloc, ChatDetailState>(
            builder: (context, state) {
              if (state is ChatDetailLoadSuccess){
                  return Chat(
                  showUserAvatars: true,
                  showUserNames: true,
                  messages: parsedEntityMessageToMessages(state.listMessage),
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
              }
              else{
                return const Text("Load failer");
              }
            },
          ),
        ));
  }
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
            backgroundImage: const NetworkImage(
                "https://images.unsplash.com/photo-1570295999919-56ceb5ecca61?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8NHx8YXZhdGFyfGVufDB8fDB8fA%3D%3D&auto=format&fit=crop&w=500&q=60"),
          ),
          SizedBox(
            width: 5.w,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Minh Phương",
                style: kText15MediumBlack,
              ),
              Text(
                "online",
                style: kText13RegularNote,
              )
            ],
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
              onPressed: () {}),
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
                          builder: (context) => const OptionChatRoom()),
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
