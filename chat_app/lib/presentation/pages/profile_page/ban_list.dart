import 'package:chat_app/configs/fontconfig.dart';
import 'package:chat_app/dataexample/active_user.dart';
import 'package:chat_app/presentation/components/avatarcicle.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../configs/colorconfig.dart';
import '../chat_page/chatpage.dart';

class BanList extends StatelessWidget {
  const BanList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: getAppBar(),
      body: SingleChildScrollView(
          child: Padding(
        padding: EdgeInsets.symmetric(vertical: 10.h),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  width: 10.w,
                ),
                Text(
                  "18 tài khoản",
                  style: ktext17RegularGreyText,
                ),
              ],
            ),
            SizedBox(
              height: 10.h,
            ),
            ListView.builder(
                shrinkWrap: true,
                itemCount: 3,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (BuildContext context, int index) {
                  return BlockAcount(imgUrl: actives[index]['img'], name: actives[index]['name']);
                }),
          ],
        ),
      )),
    );
  }

  AppBar getAppBar() {
    return AppBar(
      backgroundColor: cwColorBackground,
      elevation: 0,
      iconTheme: const IconThemeData(color: cwColorBlackIcon),
      centerTitle: true,
      toolbarHeight: 70.h,
      title: Text(
        "Danh sách chặn",
        style: kText20MediumBlack,
      ),
    );
  }
}

class BlockAcount extends StatelessWidget {
  final String name;
  final String imgUrl;
  const BlockAcount({
    Key? key,
    required this.imgUrl,
    required this.name
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 3.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              AvatarCicle(
                  imgUrl: imgUrl,
                  radius: 50.h),
              SizedBox(
                width: 5.w,
              ),
              Text(
                name,
                //style: kText17BoldBlack,
              ),
            ],
          ),
          TextButton(
            child: Text(
              "Bỏ chặn",
              style: kText15RegularMain,
              textAlign: TextAlign.right,
            ),
            onPressed: () => {},
          )
        ],
      ),
    );
  }
}
