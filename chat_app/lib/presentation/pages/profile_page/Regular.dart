import 'package:chat_app/configs/colorconfig.dart';
import 'package:chat_app/configs/fontconfig.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Regular extends StatelessWidget {
  const Regular({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: cwColorBackground,
          title: Text(
            "Pháp lý và chính sách",
            style: kText17BoldBlack,
          ),
          centerTitle: true,
          iconTheme: const IconThemeData(color: cwColorBlack),
        ),
        body: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(vertical: 15.h),
                child: Text(
                  'Điều khoản và dịch vụ',
                  style: kText15RegularBlack,
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 15.h),
                child: Text(
                  'Chính sách dữ liệu',
                  style: kText15RegularBlack,
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 15.h),
                child: Text(
                  'Chính sách cookie',
                  style: kText15RegularBlack,
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 15.h),
                child: Text(
                  'Thông báo cho bên thứ ba',
                  style: kText15RegularBlack,
                ),
              ),
            ],
          ),
        ));
  }
}
