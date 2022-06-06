import 'dart:developer';
import 'dart:io';

import 'package:chat_app/configs/colorconfig.dart';
import 'package:chat_app/domain/repositories/authenticate_repository.dart';
import 'package:chat_app/helper/network/socket_service.dart';
import 'package:chat_app/presentation/bloc/chat_detail/chat_detail_bloc.dart';
import 'package:chat_app/presentation/rootapp.dart';
import 'package:chat_app/utils/account.dart';
import 'package:chat_app/utils/local_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'dependencies_injection.dart' as di;
import 'dependencies_injection.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // HttpOverrides.global = MyHttpOverrides();
  await di.init();
  sl<SocketService>().connect();
  await testLogin(); // test login
  runApp(const MyApp());
}

Future<void> testLogin() async {
  final storage = sl<LocalStorageService>();
  final socket = sl<SocketService>();
  final mockData = await storage.getMockUserData(0);
  final token = await sl<IAuthenticateRepository>()
      .logIn(mockData['email'], mockData['password']);
  if (token != null) {
    socket.addEventReconnect((data) => socket.emitLogin(token));
  } else {
    log('Login fail');
  }
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
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
