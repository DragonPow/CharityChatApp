import 'package:chat_app/configs/colorconfig.dart';
import 'package:chat_app/configs/fontconfig.dart';
import 'package:chat_app/presentation/bloc/main_bloc/main_bloc_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../bloc/login/login_bloc.dart';
import '../../bloc/root_app/root_app_bloc.dart';
import '../../components/password_input.dart';

class LoginPage extends StatefulWidget {
  final bool isChangeAccount;
  const LoginPage({Key? key, this.isChangeAccount = false}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late TextEditingController _emailTextEditController;
  late TextEditingController _passTextEditController;
  var _loginBloc;

  @override
  void initState() {
    super.initState();
    _emailTextEditController = TextEditingController();
    _passTextEditController = TextEditingController();
    _loginBloc = BlocProvider.of<LoginBloc>(context);
  }

  @override
  void dispose() {
    _emailTextEditController.dispose();
    _passTextEditController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: cwColorWhite,
        elevation: 0,
        iconTheme:const IconThemeData(color: cwColorBlack),
        leading: widget.isChangeAccount? IconButton(icon:  const Icon(Icons.arrow_back), onPressed: () =>Navigator.of(context).pop(),) : null
      ),
      backgroundColor: cwColorWhite,
      body: Center(
        child: SingleChildScrollView(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Image(
                    image: AssetImage("assets/images/logo.png")),
                SizedBox(
                  height: 15.h,
                ),
                Text(
                  "Đăng nhập vào tài khoản của bạn",
                  style: kText15RegularGreyNotetext,
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(20.w, 50.h, 20.w, 0),
                  child: TextFormField(
                    controller: _emailTextEditController,
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
                      fillColor: cwColorWhite,
                      filled: true,
                    ),
                  ),
                ),
                SizedBox(
                  height: 15.h,
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
                    textcontroller: _passTextEditController,
                  ),
                ),
                BlocConsumer<LoginBloc, LoginState>(
                  listener: (context, state) {
                    if (state is LoginSuccess) {
                      BlocProvider.of<RootAppBloc>(context).add(const RootAppChangeTap(tap: 0));
                      BlocProvider.of<MainBlocBloc>(context).add(MainBlocLogin());
                      if(widget.isChangeAccount) Navigator.of(context).popUntil((route) => route.isFirst);
                     // Navigator.pushAndRemoveUntil(context, newRoute, (route) => false)
                    } else {
                      if (state is LoginWrongPassOrEmail) {
                        showDialog<String>(
                          context: context,
                          builder: (BuildContext context) => AlertDialog(
                            title: const Text('Sai email hoặc mật khẩu'),
                            content: const Text(
                                'Vui lòng kiểm tra lại email hoặc mật khẩu'),
                            actions: <Widget>[
                              TextButton(
                                onPressed: () => Navigator.pop(context, 'Hủy'),
                                child: const Text('Hủy'),
                              ),
                              TextButton(
                                onPressed: () =>
                                    Navigator.pop(context, 'Xác nhận'),
                                child: const Text('Xác nhận'),
                              ),
                            ],
                          ),
                        );
                      }
                    }
                  },
                  builder: (context, state) {
                    return BlocBuilder<LoginBloc, LoginState>(
                      builder: (context, state) {
                        if (state is LoginLoading) {
                          return Padding(
                            padding: EdgeInsets.only(top: 10.h),
                            child: const CircularProgressIndicator(),
                          );
                        }

                        return Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 20.w, vertical: 30.h),
                          child: ElevatedButton(
                            onPressed: () {
                              _loginBloc.add(LoginPageLogin(
                                  email: _emailTextEditController.text,
                                  pass: _passTextEditController.text));
                            },
                            child: Text(
                              'Đăng nhập',
                              style: kText18RegularWhite,
                            ),
                            style: ElevatedButton.styleFrom(
                                alignment: Alignment.center,
                                primary: cwColorMain,
                                fixedSize: Size(
                                    MediaQuery.of(context).size.width, 60.h),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30))),
                          ),
                        );
                      },
                    );
                  },
                )
              ]),
        ),
      ),
    );
  }
}
