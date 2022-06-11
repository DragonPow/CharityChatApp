import 'package:chat_app/configs/colorconfig.dart';
import 'package:chat_app/configs/fontconfig.dart';
import 'package:chat_app/helper/helper.dart';
import 'package:chat_app/main.dart';
import 'package:chat_app/presentation/components/avatarcicle.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../dependencies_injection.dart';
import '../../../utils/account.dart';
import '../../bloc/login/login_bloc.dart';
import '../../bloc/main_bloc/main_bloc_bloc.dart';
import '../login_page/login_page.dart';

class ChangeAccount extends StatelessWidget {
  const ChangeAccount({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: getAppBar(),
        body: Column(children: [
          SizedBox(
            height: 10.h,
          ),
          ListTile(
            leading: AvatarCicle(
              imgUrl: Account.instance!.imageUri != null
                  ? parseToServerUri(Account.instance!.imageUri!)
                  : "",
              radius: 50,
            ),
            title: Text(
              Account.instance!.name,
              style: kText16BoldBlack,
            ),
            subtitle: Text(
              "Đã  đăng nhập",
              style: kText13RegularNote,
            ),
          ),
          InkWell(
            child: Padding(
              padding: EdgeInsets.only(bottom: 12.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 8.w,
                  ),
                  IconButton(
                    icon: const Icon(
                      Icons.add_circle,
                      color: cwColorGreyNoteText,
                      size: 45,
                    ),
                    onPressed: () {},
                  ),
                  SizedBox(
                    width: 30.w,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 18),
                    child: Text(
                      'Đổi tài khoản khác ',
                      style: kText17BoldBlack,
                    ),
                  )
                ],
              ),
            ),
            onTap: () => {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>BlocProvider(
                      create: (context) => LoginBloc(sl()),
                      child: const LoginPage(isChangeAccount: true),
                    ),))
            },
          ),
        ]),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.all(15.0),
          child: ElevatedButton(
            onPressed: () => {},
            child: Text(
              "Tạo tài khoản mới",
              style: kText18RegularWhite,
            ),
            style: ElevatedButton.styleFrom(
                alignment: Alignment.center,
                primary: cwColorMain,
                fixedSize: Size(MediaQuery.of(context).size.width, 60.h),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30))),
          ),
        ));
  }

  AppBar getAppBar() {
    return AppBar(
      backgroundColor: cwColorBackground,
      elevation: 0,
      iconTheme: const IconThemeData(color: cwColorBlackIcon),
      centerTitle: true,
      toolbarHeight: 70.h,
      title: Text(
        "Chuyển tài khoản ",
        style: kText20MediumBlack,
      ),
    );
  }
}
