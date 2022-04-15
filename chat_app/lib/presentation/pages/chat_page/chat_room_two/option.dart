
import 'package:chat_app/configs/colorconfig.dart';
import 'package:chat_app/configs/fontconfig.dart';
import 'package:chat_app/dataexample/current_account.dart';
import 'package:chat_app/presentation/components/avatarcicle.dart';
import 'package:chat_app/presentation/pages/chat_page/chat_room_two/fileandimage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class OptionChatRoom extends StatelessWidget {
  const OptionChatRoom({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: getAppBar(),
      body: Column(children: [
        SizedBox(
          height: 30.h,
        ),
         AvatarCicle(
            imgUrl: currentAccount[0]['img'],
            radius: 120),
        SizedBox(
          height: 10.h,
        ),
        Text(
          currentAccount[0]['name'],
          style: kText24BoldBlack,
        ),
        SizedBox(
          height: 20.h,
        ),
        Padding(
          padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 90.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Center(
                child: Ink(
                  decoration: const ShapeDecoration(
                    color: cwColor25GreyNoteText,
                    shape: CircleBorder(),
                  ),
                  child: IconButton(
                    icon: Padding(
                      padding: EdgeInsets.only(bottom: 3.h),
                      child: const Icon(
                        Icons.people,
                        size: 30,
                      ),
                    ),
                    color: cwColorBlack,
                    onPressed: () {},
                  ),
                ),
              ),
               Center(
                child: Ink(
                  decoration: const ShapeDecoration(
                    color: cwColor25GreyNoteText,
                    shape: CircleBorder(),
                  ),
                  child: IconButton(
                    icon: Padding(
                      padding: EdgeInsets.only(bottom: 3.h),
                      child: const Icon(
                        FontAwesomeIcons.video,
                        size: 25,
                      ),
                    ),
                    color: cwColorBlack,
                    onPressed: () {},
                  ),
                ),
              ),
               Center(
                child: Ink(
                  decoration: const ShapeDecoration(
                    color: cwColor25GreyNoteText,
                    shape: CircleBorder(),
                  ),
                  child: IconButton(
                    icon: Padding(
                      padding: EdgeInsets.only(bottom: 3.h),
                      child: const Icon(
                        FontAwesomeIcons.phone,
                        size: 25,
                      ),
                    ),
                    color: cwColorBlack,
                    onPressed: () {},
                  ),
                ),
              ),
            ],
          ),
        ),
       const SizedBox(height: 15,),
       const  Option(label: "Tìm kiếm trong cuộc trò chuyện ", iconData: Icons.search, colorIcon: cwColorGreyNoteText,),
       const  Option(label: "File và hình ảnh  ", iconData: Icons.image_outlined, colorIcon: cwColorGreyNoteText, ),
       const  Option(label: "Đặt biệt danh  ", iconData: Icons.edit, colorIcon: cwColorGreyNoteText,),
       const  Option(label: "Chặn người dùng  ", iconData: FontAwesomeIcons.ban, colorIcon: cwColorRed,),
      ]),
    );
  }

  AppBar getAppBar() {
    return AppBar(
      iconTheme: const IconThemeData(color: cwColorBlackIcon),
      backgroundColor: cwColorBackground,
      toolbarHeight: 70.h,
      centerTitle: true,
      elevation: 0,
      title: Text(
        "Tùy chỉnh ",
        style: kText20MediumBlack,
      ),
    );
  }
}

class Option extends StatelessWidget {
    final String label;
    final IconData iconData;
    final Color colorIcon;
  const Option({
    required this.label,
    required this.iconData,
    required this.colorIcon,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Padding(
        padding:  EdgeInsets.symmetric(horizontal: 20.w, vertical: 5.h),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,

              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 5),
                  child: Text (label, style: ktext17RegularBlack ,),
                ),
                IconButton(icon: Icon(iconData, color: colorIcon,), onPressed: () {  } ,)
            ],),
            const Divider(color: cwColorGreyHintText, height: 2,)
          ],
        ),
      ),
      onTap: () => {

          Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => const FileAndImage()),
  )


      },
    );
  }
}
