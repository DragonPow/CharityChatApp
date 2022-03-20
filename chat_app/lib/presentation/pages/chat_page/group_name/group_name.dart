import 'package:chat_app/configs/colorconfig.dart';
import 'package:chat_app/configs/fontconfig.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../add_people/component/member.dart';

class GroupName extends StatefulWidget {
  const GroupName({Key? key}) : super(key: key);

  @override
  State<GroupName> createState() => _GroupName();
}

class _GroupName extends State<GroupName> {
  List<Member> members = [
    const Member(),
    const Member(),
    const Member(),
    const Member(),
    const Member(),
    const Member(),
    const Member()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: getAppBar(),
      body: SingleChildScrollView(
        child: Column(children: [
          SizedBox(height: 20.h,),
          Stack(
            children: [
              const CircleAvatar(
                backgroundImage: AssetImage("assets/images/avatar.png"),
                radius: 100,
              ),
              Positioned(
                  bottom: 10,
                  right: 20,
                  child: Container(
                    width: 25.w,
                    height: 25.w,
                    decoration: const BoxDecoration(
                        shape: BoxShape.circle, color: cwColorWhite),
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: IconButton(
                        icon: const FaIcon(FontAwesomeIcons.camera, color: cwColorMain, size: 16,),
                        onPressed: () => {},
                      ),
                    ),
                  )),
            ],
          ),
          SizedBox(height: 10.h,),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 30.w),
            child: TextFormField(
              initialValue: "Tên nhóm",
              style: ktext17RegularGreyText,
              textAlign: TextAlign.center,
              decoration: const InputDecoration(
                border: UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey),),
                enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey),),
                focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey),),
              ),
            ),
          ),
          SizedBox(height: 20.h,),
          Padding(
            padding:  EdgeInsets.symmetric(horizontal: 4.w),
            child: Wrap(
              children: members,
            ),
          )
        ]),
      ),
    );
  }

  AppBar getAppBar() {
    return AppBar(
      backgroundColor: cwColorBackground,
      title: const Text("Nhóm mới"),
      titleTextStyle: kText20MediumBlack,
      centerTitle: true,
      elevation: 0,
      actions: [
        TextButton(
            onPressed: () => {},
            child: Text(
              "Tạo",
              style: kText17SemiboldMain,
            ))
      ],
      flexibleSpace: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage("assets/images/style.png"), fit: BoxFit.cover),
        ),
      ),
    );
  }
}
