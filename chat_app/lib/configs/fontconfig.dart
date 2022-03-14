import 'package:chat_app/configs/colorconfig.dart';
import 'package:flutter/widgets.dart';

var fontFamily = "Roboto";

var fontConfig = TextStyle(
    fontFamily: fontFamily,
    color: cwColorBlack,
    fontWeight: FontWeight.normal,
    fontSize: 13);
var kText10RegularBlack = fontConfig.copyWith(fontSize: 10);
var kText22BoldMain = fontConfig.copyWith(
    fontSize: 22,
    fontFamily: "Lobster",
    color: cwColorMain,
    fontWeight: FontWeight.bold);
var kText15RegularGreyNotetext =
    fontConfig.copyWith(fontSize: 15, color: cwColorGreyNoteText);
