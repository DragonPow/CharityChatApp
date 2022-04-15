import 'package:chat_app/configs/fontconfig.dart';
import 'package:chat_app/presentation/components/avatarcicle.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../configs/colorconfig.dart';

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
            BlockAcount(),
            BlockAcount(),
            BlockAcount()
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
  const BlockAcount({
    Key? key,
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
                  imgUrl:
                      "https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8MXx8YXZhdGFyfGVufDB8fDB8fA%3D%3D&auto=format&fit=crop&w=700&q=60",
                  radius: 50.h),
              SizedBox(
                width: 5.w,
              ),
              Text(
                "Huỳnh Nhực ",
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
