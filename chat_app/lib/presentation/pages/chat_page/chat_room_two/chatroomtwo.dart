import 'package:chat_app/configs/colorconfig.dart';
import 'package:chat_app/configs/fontconfig.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:skeleton_loader/skeleton_loader.dart';

class ChatRomTwo extends StatelessWidget {
  const ChatRomTwo({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: getAppBar(),
      body:   const SkeletonloaderChatRoom(), 
    );
  }

  AppBar getAppBar() {
    return AppBar(
      backgroundColor: cwColorBackground,
      elevation: 0,
      centerTitle: false,
      toolbarHeight: 100.h,
      title: Row(children: [
         const CircleAvatar(
          radius: 30,
          backgroundImage: NetworkImage("https://images.unsplash.com/photo-1570295999919-56ceb5ecca61?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8NHx8YXZhdGFyfGVufDB8fDB8fA%3D%3D&auto=format&fit=crop&w=500&q=60"),
        ),
        SizedBox(width: 5.w,),
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text("Minh Phương", style: kText15MediumBlack,),
            Text("online", style: kText13RegularNote,)
          ],
        )
      ],),
      actions: [
        IconButton(
            icon: const Icon(
              Icons.videocam_outlined,
              size: 28,
              color: cwColorBlack,
            ),
            onPressed: () {}),
        IconButton(
            icon: const  Icon(
              Icons.call,
              size: 28,
              color: cwColorBlack
            ),
            onPressed: () {})
      ],
    );
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
        child: Text("Đang tải....", style: kText15RegularGreyNotetext,),
        color: cwColor25BackgroundButton,
      ),
      items: 1,
      period: const Duration(seconds: 2),
      highlightColor:const  Color(0x505AA469),
      direction: SkeletonDirection.ltr,
    );
  }
}