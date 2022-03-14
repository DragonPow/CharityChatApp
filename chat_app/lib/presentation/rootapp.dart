import 'package:chat_app/configs/colorconfig.dart';
import 'package:chat_app/configs/fontconfig.dart';
import 'package:chat_app/presentation/components/avataruser.dart';
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
        bottomNavigationBar: FancyBottomNavigation(
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
        ));
  }
}

AppBar getAppbar() {
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

Widget getBody(int currentPage) {
  return GestureDetector(
    child: currentPage == 0
        ? Container(
            height: 145,
            decoration: const BoxDecoration(
                image: DecorationImage(
                    image: AssetImage("assets/images/style.png"),
                    fit: BoxFit.fill)),
            child: Column(
              children: [
                SizedBox(
                  height: 40,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Container(
                      height: 40,
                      child: TextField(
                          maxLines: 1,
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              contentPadding: const EdgeInsets.all(13),
                              hintText: "Tìm kiếm",
                              hintStyle: kText15RegularGreyNotetext,
                              prefixIcon: const Icon(Icons.search))),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: cwColorWhite),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                            children: List.generate(
                                10,
                                (index) => const AvatarUser(
                                    radius: 50,
                                    imageUrl:
                                        "https://images.unsplash.com/photo-1599566150163-29194dcaad36?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=387&q=80",
                                    name: "Anan"))),
                      ),
                    ),
                  ],
                )
              ],
            ),
          )
        : currentPage == 1
            ? const Text("New Chat")
            : const Text("Friend"),
    onTap: () {},
  );
}
