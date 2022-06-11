import 'package:chat_app/configs/colorconfig.dart';
import 'package:chat_app/configs/fontconfig.dart';
import 'package:chat_app/presentation/bloc/chat_overview/home_room_bloc.dart';
import 'package:chat_app/presentation/bloc/root_app/root_app_bloc.dart';
import 'package:chat_app/presentation/pages/chat_page/chatpage.dart';
import 'package:chat_app/presentation/pages/profile_page/profile_page.dart';
import 'package:chat_app/presentation/pages/newchatpage/new_chat_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fancy_bottom_navigation/fancy_bottom_navigation.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../dependencies_injection.dart';
import 'bloc/active_user/active_user_bloc.dart';
import 'bloc/chat_overview/chat_overview_bloc.dart';
import 'bloc/new_message/new_message_bloc.dart';

class RootApp extends StatefulWidget {
  const RootApp({Key? key}) : super(key: key);

  @override
  State<RootApp> createState() => _RootAppState();
}

class _RootAppState extends State<RootApp> {
  var _rootAppBloc;

  @override
  void initState() {
    super.initState();
    _rootAppBloc = BlocProvider.of<RootAppBloc>(context);
    _rootAppBloc.add(const RootAppChangeTap(tap: 0));
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RootAppBloc, RootAppState>(
      builder: (context, state) {
        if(state is RootAppChangeTapSuccess){
          return Scaffold(
            backgroundColor: cwColorWhite,
            appBar: getAppbar(state.tap),
            body: getBody(state.tap),
            bottomNavigationBar: getBottomTabBar(state.tap));
        } else {
          return Scaffold(
            backgroundColor: cwColorWhite,
            appBar: getAppbar(0),
            body: getBody(0),
            bottomNavigationBar: getBottomTabBar(0));
        }
      },
    );
  }

  AppBar getAppbar(int currentPage) {
    return currentPage == 0
        ? chatAndFriendsAppbar()
        : currentPage == 1
            ? newChatAppbar()
            : friendsAppbar();
  }

  AppBar chatAndFriendsAppbar() {
    return AppBar(
      backgroundColor: cwColorBackground,
      //centerTitle: true,
      elevation: 0,
      title: Padding(
        padding: EdgeInsets.symmetric(vertical: 15.h),
        child: Text(
          "MeerChats",
          style: kText24BoldMain,
        ),
      ),
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
        ? MultiBlocProvider(
            providers: [
              BlocProvider(
                create: (context) => HomeRoomBloc(
                  Map.from({
                    HomeRoomState.private: ChatOverviewBloc(sl()),
                    HomeRoomState.group: ChatOverviewBloc(sl()),
                  }),
                ),
              ),
              BlocProvider(
                create: (context) => ActiveUserBloc(sl()),
              ),
            ],
            child: const ChatPage(),
          )
        : currentPage == 1
            ? BlocProvider(
                create: (context) => NewMessageBloc(sl(), sl()),
                child: const NewChatPage(),
              )
            : const ProfilePage();
  }

  FancyBottomNavigation getBottomTabBar(int currentPage) {
    return FancyBottomNavigation(
      initialSelection: currentPage,
      tabs: [
        TabData(iconData: FontAwesomeIcons.commentDots, title: "Chat"),
        TabData(iconData: FontAwesomeIcons.plus, title: "Mới"),
        TabData(iconData: Icons.people, title: "Hồ sơ")
      ],
      onTabChangedListener: (int position) {
       _rootAppBloc.add( RootAppChangeTap(tap: position));
      },
    );
  }
}
