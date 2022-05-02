import 'package:chat_app/configs/colorconfig.dart';
import 'package:chat_app/presentation/rootapp.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'dependencies_injection.dart' as di;
import 'package:day_night_switcher/day_night_switcher.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    bool isDarkModeEnabled = true;

    return ScreenUtilInit(
      designSize: const Size(360, 780),
      minTextAdapt: true,
      builder: () => MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
         // primarySwatch: Colors.green,
          primaryColor: cwColorMain
        ),
        // theme: ThemeData.light(),
        // darkTheme: ThemeData.dark().copyWith(
        //   appBarTheme: AppBarTheme(color: const Color(0xFF253341)),
        //   scaffoldBackgroundColor: const Color(0xFF15202B),
        // ),
        // themeMode: isDarkModeEnabled ? ThemeMode.dark : ThemeMode.light,
        home: const RootApp(),
      ),
    );
  }
}
