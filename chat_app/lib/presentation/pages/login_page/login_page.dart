import 'package:chat_app/configs/colorconfig.dart';
import 'package:chat_app/configs/fontconfig.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:async/async.dart';

import '../../components/password_input.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final IconData eyeIcon = Icons.remove_red_eye_outlined;
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  CancelableOperation? isLoading;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    passwordController.dispose();
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Image(
                  image: AssetImage('asset/login.png'),
                  width: MediaQuery.of(context).size.width,
                ),
                SizedBox(
                  height: 20.h,
                ),
                Text(
                  'Đăng nhập vào tài khoản của bạn',
                  style: kText18RegularNoteText,
                ),
                SizedBox(
                  height: 50.h,
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(20.w, 0, 20.w, 0),
                  child: TextFormField(
                    controller: emailController,
                    decoration: InputDecoration(
                      prefixIcon: Icon(
                        Icons.people,
                        color: cwColorMain,
                        size: 23.h,
                      ),
                      errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                              color: cwColorRed.withOpacity(1), width: 1)),
                      focusedErrorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                              color: cwColorRed.withOpacity(1), width: 2)),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                              color: cwColorMain.withOpacity(1), width: 2)),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                              color: cwColorMain.withOpacity(1), width: 1)),
                      hintText: 'Email',
                      hintStyle: kText15RegularGreyNotetext,
                      fillColor:
                          cwColorBackground.withOpacity(0.2).withOpacity(0.2),
                      filled: true,
                    ),
                  ),
                ),
                SizedBox(
                  height: 20.h,
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(20.w, 0, 20.w, 0),
                  child: PassWordInput(
                    textInputType: TextInputType.text,
                    hint: 'Mật khẩu',
                    background: cwColorBackground,
                    boder: cwColorMain,
                    securitytext: true,
                    ispass: true,
                    textcontroller: passwordController,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(10.w),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton.icon(
                          onPressed: () => {},
                          icon: Icon(
                            Icons.check_circle,
                            color: cwColorMain,
                            size: 20.h,
                          ),
                          label: const Text(
                            'Nhớ tài khoản',
                            style: TextStyle(color: cwColorBlackIcon),
                          )),
                      TextButton(
                        onPressed: () {},
                        child: Text(
                          'Quên mật khẩu?',
                          style: kText15BoldMain,
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(30.w, 10.h, 30.w, 10.h),
                  child: ElevatedButton(
                        onPressed: () => {
                          //TODO: navigator to SignInpage
                        },
                        child: Text(
                          'Đăng nhập',
                          style: kText18BoldWhite,
                        ),
                        style: ElevatedButton.styleFrom(
                            alignment: Alignment.center,
                            primary: cwColorMain,
                            fixedSize:
                                Size(MediaQuery.of(context).size.width, 60.h),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30))),
                      )
                ),
                SizedBox(
                  height: 10.h,
                ),
                Text('Hoặc ', style: kText15RegularGreyNotetext),
                SizedBox(
                  height: 10.h,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      decoration: BoxDecoration(
                          border: Border.all(color: cwColorMain),
                          borderRadius: BorderRadius.circular(30)),
                      width: MediaQuery.of(context).size.width - 60.w,
                      height: 60.h,
                      child: TextButton.icon(
                        onPressed: () => {},
                        icon: const FaIcon(FontAwesomeIcons.google),
                        label: const Text(
                          "Đăng nhập với google",
                          style: TextStyle(color: cwColorBlack),
                        ),
                      ),
                    )
                  ],
                ),
                TextButton(
                  onPressed: () {
                  },
                  child: RichText(
                      text: TextSpan(
                          text: "Bạn chưa có tài khoản?",
                          style: kText16RegularBlack,
                          children: <TextSpan>[
                        TextSpan(text: ' Đăng ký!', style: kText17RegularRed),
                      ])),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
