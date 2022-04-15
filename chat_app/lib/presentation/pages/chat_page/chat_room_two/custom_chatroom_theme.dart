import 'package:chat_app/configs/colorconfig.dart';
import 'package:chat_app/configs/fontconfig.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';


// ignore: constant_identifier_names
const CustomChatroomTheme = DefaultChatTheme(
    attachmentButtonIcon: Icon(FontAwesomeIcons.folderPlus, color: cwColorMain),
    inputPadding: EdgeInsets.fromLTRB(24, 20, 24, 20),
    inputTextDecoration: InputDecoration(
      border: InputBorder.none,
      contentPadding: EdgeInsets.zero,
      isCollapsed: true,
    ),
    inputMargin: EdgeInsets.zero,
    inputBorderRadius: BorderRadius.vertical(
      top: Radius.circular(20),
    ),
    inputBackgroundColor: Color.fromARGB(13, 0, 0, 0),
    inputTextColor: cwColorBlack,
    inputTextStyle: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w500,
      height: 1.5,
    ),
    messageBorderRadius: 20,
    messageInsetsHorizontal: 20,
    messageInsetsVertical: 16,
    primaryColor: Color(0xff5AA469),
    receivedEmojiMessageTextStyle: TextStyle(fontSize: 40),
    receivedMessageBodyTextStyle: TextStyle(
      color: Color(0xff1d1c21),
      fontSize: 16,
      fontWeight: FontWeight.w500,
      height: 1.5,
    ),
    receivedMessageCaptionTextStyle: TextStyle(
      color: Color(0xff9e9cab),
      fontSize: 12,
      fontWeight: FontWeight.w500,
      height: 1.333,
    ),
    receivedMessageDocumentIconColor: Color(0xff5AA469),
    receivedMessageLinkDescriptionTextStyle: TextStyle(
      color: Color(0xff1d1c21),
      fontSize: 14,
      fontWeight: FontWeight.w400,
      height: 1.428,
    ),
    receivedMessageLinkTitleTextStyle: TextStyle(
      color: Color(0xff1d1c21),
      fontSize: 16,
      fontWeight: FontWeight.w800,
      height: 1.375,
    ),
    errorIcon: Icon(FontAwesomeIcons.xbox, color: cwColorRed,),
    errorColor:  cwColorRed,
    emptyChatPlaceholderTextStyle: TextStyle(
      color: Color(0xff9e9cab),
      fontSize: 16,
      fontWeight: FontWeight.w500,
      height: 1.5,
    ),
    documentIcon: Icon(FontAwesomeIcons.fileInvoice, color: cwColorMain),
    deliveredIcon: Icon(Icons.delivery_dining, color: cwColorMain),
    dateDividerTextStyle: TextStyle(
      color: Color(0xff9e9cab),
      fontSize: 12,
      fontWeight: FontWeight.w800,
      height: 1.333,
    ),
    dateDividerMargin: EdgeInsets.only(
      bottom: 32,
      top: 16,
    ),
    secondaryColor: Color(0xfff5f5f7),
    seenIcon: Icon(FontAwesomeIcons.check, color: cwColorMain, size: 12,),
    sendButtonIcon: Icon(FontAwesomeIcons.paperPlane, color: cwColorMain),
    sendButtonMargin: EdgeInsets.only(bottom: 0, top: 0, right: 5, left: 5),
    sendingIcon: null,
    sentEmojiMessageTextStyle: TextStyle(fontSize: 40),
    sentMessageBodyTextStyle: TextStyle(
      color: Color(0xffffffff),
      fontSize: 16,
      fontWeight: FontWeight.w500,
      height: 1.5,
    ),
    sentMessageCaptionTextStyle: TextStyle(
      color: Color(0x80ffffff),
      fontSize: 12,
      fontWeight: FontWeight.w500,
      height: 1.333,
    ),
    sentMessageDocumentIconColor: Color(0xffffffff),
    sentMessageLinkDescriptionTextStyle: TextStyle(
      color: Color(0xffffffff),
      fontSize: 14,
      fontWeight: FontWeight.w400,
      height: 1.428,
    ),
    sentMessageLinkTitleTextStyle: TextStyle(
      color: neutral7,
      fontSize: 16,
      fontWeight: FontWeight.w800,
      height: 1.375,
    ),
    statusIconPadding: EdgeInsets.symmetric(horizontal: 4),
    userAvatarImageBackgroundColor: Colors.black,
    userAvatarTextStyle: TextStyle(
      color: cwColorBlack,
      fontSize: 12,
      fontWeight: FontWeight.w800,
      height: 1.333,
    ),
    userNameTextStyle: TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.w800,
      height: 1.333,
    ),
    attachmentButtonMargin: null,
    backgroundColor: Color(0xffffffff));
