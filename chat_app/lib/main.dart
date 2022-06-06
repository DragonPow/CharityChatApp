import 'dart:io';

import 'package:chat_app/configs/colorconfig.dart';
import 'package:chat_app/helper/network/socket_service.dart';
import 'package:chat_app/presentation/bloc/chat_detail/chat_detail_bloc.dart';
import 'package:chat_app/presentation/rootapp.dart';
import 'package:chat_app/utils/account.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'dependencies_injection.dart' as di;
import 'dependencies_injection.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // HttpOverrides.global = MyHttpOverrides();
  await di.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    sl<SocketService>().connect();
    return ScreenUtilInit(
        designSize: const Size(360, 780),
        minTextAdapt: true,
        builder: () => MultiBlocProvider(
              providers: [
                BlocProvider<ChatDetailBloc>(
                  create: (context) => ChatDetailBloc(chatRepository: sl()),
                ),
              ],
              child: MaterialApp(
                debugShowCheckedModeBanner: false,
                theme: ThemeData(primaryColor: cwColorMain),
                home: const RootApp(),
              ),
            ));
  }
}
