import 'package:chat_app/configs/colorconfig.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

var fontFamily = "Roboto";

var fontConfig = TextStyle(
    fontFamily: fontFamily,
    color: cwColorBlack,
    fontWeight: FontWeight.normal,
    fontSize: 13.sp);
var kText10RegularBlack = fontConfig.copyWith(fontSize: 10.sp);
var kText22BoldMain = fontConfig.copyWith(
    fontSize: 22.sp,
    fontFamily: "Lobster",
    color: cwColorMain,
    fontWeight: FontWeight.bold);
var kText15RegularGreyNotetext =
    fontConfig.copyWith(fontSize: 15.sp, color: cwColorGreyNoteText);
var kText15BoldMain = fontConfig.copyWith(fontSize: 15.sp, color: cwColorMain, fontWeight: FontWeight.w600);
var kText13BoldBlack = fontConfig.copyWith(fontWeight: FontWeight.bold);
var kText11RegularHintText = fontConfig.copyWith(fontSize: 11.sp, color: cwColorGreyHintText);
var kText11RegularWhite = fontConfig.copyWith(fontSize: 11.sp, color: cwColorWhite);