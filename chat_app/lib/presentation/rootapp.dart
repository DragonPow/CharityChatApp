import 'package:chat_app/configs/colorconfig.dart';
import 'package:chat_app/configs/fontconfig.dart';
import 'package:chat_app/presentation/pages/chat_page/chatpage.dart';
import 'package:chat_app/presentation/pages/profile_page/profile_page.dart';
import 'package:chat_app/presentation/pages/newchatpage/new_chat_page.dart';
import 'package:chat_app/presentation/pages/newchatpage/sort_infor_component.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fancy_bottom_navigation/fancy_bottom_navigation.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class RootApp extends StatefulWidget {
  const RootApp({Key? key}) : super(key: key);

  @override
  State<RootApp> createState() => _RootAppState();
}

class _RootAppState extends State<RootApp> {
  int currentPage = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: cwColorWhite,
        appBar: getAppbar(),
        body: getBody(currentPage),
        bottomNavigationBar: getBottomTabBar());
  }

  AppBar getAppbar() {
    return currentPage == 0
        ? chatAndFriendsAppbar()
        : currentPage == 1
            ? newChatAppbar()
            : friendsAppbar();
  }

  AppBar chatAndFriendsAppbar() {
    return AppBar(
      backgroundColor: cwColorBackground,
      centerTitle: true,
      elevation: 0,
      title: Padding(
        padding: const EdgeInsets.only(top: 10),
        child: Text(
          "MeerChats",
          style: kText22BoldMain,
        ),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Container(
            width: 33,
            height: 33,
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: const DecorationImage(
                    image: NetworkImage(
                        "https://images.unsplash.com/photo-1494790108377-be9c29b29330?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8Mnx8YXZhdGFyfGVufDB8fDB8fA%3D%3D&auto=format&fit=crop&w=500&q=60"),
                    fit: BoxFit.cover),
                border: Border.all(color: cwColorWhite, width: 2)),
          ),
        )
      ],
    );
  }

  AppBar newChatAppbar() {
    return AppBar(
      backgroundColor: cwColorBackground,
      title: Text(
        "Tin nhắn mới",
        style: kText20MediumBlack,
      ),
      elevation: 0,
      centerTitle: true,
    );
  }

  AppBar friendsAppbar() {
    return AppBar(
      backgroundColor: cwColorBackground,
      title: Text(
        "Hồ sơ",
        style: kText20MediumBlack,
      ),
      elevation: 0,
      centerTitle: true,
    );
  }

  Widget getBody(int currentPage) {
    return currentPage == 0
        ? const ChatPage()
        : currentPage == 1
            ? const NewChatPage()
            : const ProfilePage();
  }
  FancyBottomNavigation getBottomTabBar() {
    return FancyBottomNavigation(
      tabs: [
        TabData(iconData: FontAwesomeIcons.commentDots, title: "Chat"),
        TabData(iconData: FontAwesomeIcons.plus, title: "Mới"),
        TabData(iconData: Icons.people, title: "Bạn bè")
      ],
      onTabChangedListener: (int position) {
        setState(() {
          currentPage = position;
        });
      },
    );
  }
}
