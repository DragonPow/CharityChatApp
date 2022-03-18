import 'package:chat_app/configs/colorconfig.dart';
import 'package:chat_app/presentation/rootapp.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size (360, 780),
      minTextAdapt: true,
      builder: () =>  MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
         // primarySwatch: Colors.green,
          primaryColor: cwColorMain
        ),
        home: const RootApp(),
      ),
    );
  }
}
