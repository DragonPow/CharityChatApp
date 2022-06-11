import 'package:chat_app/configs/colorconfig.dart';
import 'package:chat_app/helper/network/socket_service.dart';
import 'package:chat_app/presentation/bloc/active_user/active_user_bloc.dart';
import 'package:chat_app/presentation/bloc/chat_overview/chat_overview_bloc.dart';
import 'package:chat_app/presentation/bloc/login/login_bloc.dart';
import 'package:chat_app/presentation/bloc/new_message/new_message_bloc.dart';
import 'package:chat_app/presentation/pages/login_page/login_page.dart';
import 'package:chat_app/presentation/rootapp.dart';
import 'package:chat_app/utils/local_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'dependencies_injection.dart' as di;
import 'dependencies_injection.dart';
import 'presentation/bloc/main_bloc/main_bloc_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // HttpOverrides.global = MyHttpOverrides();
  await initMain();
  runApp(BlocProvider(
    create: (context) => MainBlocBloc(sl()),
    child: const MyApp(),
  ));
}

Future<void> initMain() async {
  await di.init();
  final socket = sl<SocketService>();
  socket.connect();
  socket.addEventReconnect((data) async {
    final token = await sl<LocalStorageService>().getToken();
    socket.emit('online', token);
  });
}

// Future<void> testLogin() async {
//   final storage = sl<LocalStorageService>();
//   final socket = sl<SocketService>();
//   try {
//     final mockData = await storage.getMockUserData(1);
//     final token = await sl<IAuthenticateRepository>()
//         .logIn(mockData['email'], mockData['password']);
//   } catch (e) {
//     print(e);
//   }
// }

class MyApp extends StatelessWidget {
  final bool isChangeAccount;
  const MyApp({Key? key, this.isChangeAccount = false}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (!isChangeAccount)
     { BlocProvider.of<MainBlocBloc>(context).add(MainBlocCheck());}
    sl<SocketService>().addEventListener('request-login', (_) {
      BlocProvider.of<MainBlocBloc>(context).add(MainBlocLogout());
    });

    return ScreenUtilInit(
        designSize: const Size(360, 780),
        minTextAdapt: true,
        builder: () => BlocBuilder<MainBlocBloc, MainBlocState>(
              builder: (context, state) {
                if (state is MainBlocAlreadyLogin) {
                  return MaterialApp(
                    debugShowCheckedModeBanner: false,
                    theme: ThemeData(primaryColor: cwColorMain),
                    home: MultiBlocProvider(
                      providers: [
                        BlocProvider(
                          create: (context) => ChatOverviewBloc(sl()),
                        ),
                        BlocProvider(
                          create: (context) => ActiveUserBloc(sl()),
                        ),
                        BlocProvider(
                          create: (context) => NewMessageBloc(sl(), sl()),
                        ),
                      ],
                      child: const RootApp(),
                    ),
                  );
                } else {
                  return MaterialApp(
                    debugShowCheckedModeBanner: false,
                    theme: ThemeData(primaryColor: cwColorMain),
                    home: BlocProvider(
                      create: (context) => LoginBloc(sl()),
                      child: const LoginPage(),
                    ),
                  );
                }
              },
            ));
  }
}
