import 'package:chat_app/configs/colorconfig.dart';
import 'package:chat_app/configs/fontconfig.dart';
import 'package:chat_app/presentation/components/avatarcicle.dart';
import 'package:chat_app/presentation/pages/profile_page/ban_list.dart';
import 'package:chat_app/presentation/pages/profile_page/change_account.dart';
import 'package:chat_app/presentation/pages/profile_page/waiting_chat.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePage();
}

class _ProfilePage extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(height: 30.h,),
          AvatarCicle(
              imgUrl:
                  "https://images.unsplash.com/photo-1580489944761-15a19d654956?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8N3x8YXZhdGFyfGVufDB8fDB8fA%3D%3D&auto=format&fit=crop&w=500&q=60",
              radius: 115.w),
          SizedBox(
            height: 10.h,
          ),
          Text(
            "Minh Minh",
            style: kText24MeniumBlack,
          ),
          SizedBox(height: 20.h,),
          Option(
            icon: FontAwesomeIcons.moon,
            title: 'Chế độ ban đêm ',
            isToggle: true,
            backgoundColor: cwColorBlack,
          ),
          Option(
              title: "Tin nhắn chờ ",
              icon: FontAwesomeIcons.commentDots,
              backgoundColor: cwColorMain),
          Padding(
           padding:EdgeInsets.fromLTRB(20.w, 10.h, 0, 5.h),
            child: Row(
              children: [
                Text(
                  "Tùy chọn ",
                  style: kText15RegularGreyNotetext,
                ),
              ],
            ),
          ),
          SizedBox(
            height: 10.h,
          ),
          Option(
            icon: FontAwesomeIcons.ban,
            title: 'Danh sách chặn ',
            backgoundColor: cwColorRed,
            onClick: () => {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const BanList()),
              )
            },
          ),
          Padding(
            padding:EdgeInsets.fromLTRB(20.w, 10.h, 0, 5.h),
            child: Row(
              children: [
                Text(
                  "Tài khoản",
                  style: kText15RegularGreyNotetext,
                ),
              ],
            ),
          ),
          SizedBox(
            height: 10.h,
          ),
          Option(
            icon: Icons.change_circle,
            title: 'Chuyển tài khoản  ',
            backgoundColor: const Color(0xFF8A54FF),
          ),
          Option(
            icon: FontAwesomeIcons.questionCircle,
            title: 'Trợ giúp  ',
            backgoundColor: cwColorRed,
          ),
          Option(
            icon: FontAwesomeIcons.shieldAlt,
            title: 'Pháp lý & chính sách ',
            backgoundColor: cwColorGreyNoteText,
          ),
        ],
      ),
    );
  }
}

class Option extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color backgoundColor;
  bool isToggle;
  Function? onClick;
  Option(
      {Key? key,
      required this.title,
      required this.icon,
      required this.backgoundColor,
      this.isToggle = false,
      this.onClick})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  width: 40.w,
                  height: 40.w,
                  decoration: BoxDecoration(
                    color: backgoundColor,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    icon,
                    size: 19,
                    color: cwColorWhite,
                  ),
                ),
                SizedBox(width: 15.w),
                Expanded(
                    child: Text(
                  title,
                  style: ktext17RegularBlack,
                )),
                isToggle
                    ? Switch(
                        value: false,
                        onChanged: (value) {},
                        activeTrackColor: Colors.lightGreenAccent,
                        activeColor: Colors.green,
                      )
                    : Container(),
              ],
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(60.w, 0, 10.w, 5.h),
              child: const Divider(
                color: Color.fromARGB(90, 0, 0, 0),
              ),
            )
          ],
        ),
      ),
      onTap: () => {},
    );
  }
}
