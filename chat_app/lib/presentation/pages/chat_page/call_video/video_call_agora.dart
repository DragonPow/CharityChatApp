import 'package:agora_uikit/agora_uikit.dart';
import 'package:chat_app/utils/account.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';

import '../../../../helper/constant.dart';

class VideoCallAgora extends StatefulWidget {
  final String roomId;
  VideoCallAgora({Key? key, required this.roomId}) : super(key: key);

  @override
  State<VideoCallAgora> createState() => _VideoCallAgoraState();
}

class _VideoCallAgoraState extends State<VideoCallAgora> {
  late AgoraClient agoraClient;

  @override
  void initState() {
    super.initState();
    initAgora();
  }


  @override
  void dispose() {
    agoraClient.engine.leaveChannel();
    super.dispose();
  }

  // @override
  // void initState() {
  //   super.initState();
  //   // initialize agora sdk
  //   initialize();
  // }

  void initAgora() async {
    agoraClient = AgoraClient(
    agoraConnectionData: AgoraConnectionData(
        appId: appId,
        tempToken: token,
        channelName: channelName,
        username: Account.instance!.name),
    enabledPermission: [Permission.camera, Permission.microphone],
    agoraEventHandlers: AgoraRtcEventHandlers(leaveChannel: (r) {
      Navigator.of(context).pop();
    })
  );
    await agoraClient.initialize();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Agora'),
          centerTitle: true,
        ),
        body: Stack(children: [
          AgoraVideoViewer(
            client: agoraClient,
            // layoutType: Layout.floating,
            enableHostControls: true,
          ),
          AgoraVideoButtons(client: agoraClient)
          // _toolbar()
        ]));
  }
}
