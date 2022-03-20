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

var kText11RegularHintText = fontConfig.copyWith(fontSize: 11.sp, color: cwColorGreyHintText);
var kText11RegularWhite = fontConfig.copyWith(fontSize: 11.sp, color: cwColorWhite);

var kText13BoldBlack = fontConfig.copyWith(fontWeight: FontWeight.bold);

var kText15RegularGreyNotetext =
    fontConfig.copyWith(fontSize: 15.sp, color: cwColorGreyNoteText);
var kText15BoldMain = fontConfig.copyWith(fontSize: 15.sp, color: cwColorMain, fontWeight: FontWeight.w600);

var kText16RegularWhite = fontConfig.copyWith(fontSize: 16.sp, color: cwColorWhite);

var kText17SemiboldBlack = fontConfig.copyWith(fontSize: 17.sp, fontWeight: FontWeight.w500);
var kText17SemiboldMain = fontConfig.copyWith(fontSize: 17.sp, fontWeight: FontWeight.w500, color: cwColorMain);
var ktext17RegularBlack = fontConfig.copyWith(fontSize: 17);
var ktext17RegularGreyText = fontConfig.copyWith(fontSize: 17, color: cwColorGreyNoteText);

var kText18RegularMain = fontConfig.copyWith(fontSize: 18, color: cwColorMain);

var kText20MediumBlack = fontConfig.copyWith(fontSize: 20.sp, fontWeight: FontWeight.w600);

var kText22BoldMain = fontConfig.copyWith(
    fontSize: 22.sp,
    fontFamily: "Lobster",
    color: cwColorMain,
    fontWeight: FontWeight.bold);
