import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:chat_app/configs/colorconfig.dart';
import 'package:flutter/material.dart';

class AvatarCicle extends StatelessWidget {
  final String imgUrl;
  final double radius;
  const AvatarCicle({Key? key, required this.imgUrl, required this.radius}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
              width: radius.w,
              height: radius.w,
              decoration: const BoxDecoration(
                  gradient: LinearGradient(colors: cwColorGradientActive),
                  shape: BoxShape.circle),
              child: Padding(
                padding: EdgeInsets.all(2.w),
                child: Container(
                  width: radius - 4.w,
                  height: radius - 4.w,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                        image: NetworkImage(imgUrl != ""
                            ? imgUrl
                            : "images/avatar.png"),
                        fit: BoxFit.cover),
                    border: Border.all(color: cwColorBackground, width: 2.w),
                  ),
                ),
              ));
  }
}