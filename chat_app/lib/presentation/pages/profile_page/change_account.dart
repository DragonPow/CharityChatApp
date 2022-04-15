import 'package:chat_app/configs/colorconfig.dart';
import 'package:chat_app/configs/fontconfig.dart';
import 'package:chat_app/presentation/components/avatarcicle.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ChangeAccount extends StatelessWidget {
  const ChangeAccount({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: getAppBar(),
      body: Column(
        children: [
          SizedBox(height: 10.h,),
          ListTile(
          leading:  const AvatarCicle(imgUrl: "https://images.unsplash.com/photo-1494790108377-be9c29b29330?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8Mnx8YXZhdGFyfGVufDB8fDB8fA%3D%3D&auto=format&fit=crop&w=500&q=60", radius: 50, ),

          title: Text('Minh Nhực ', style: kText16BoldBlack,),

          subtitle: Text("Đã  đăng nhập", style: kText13RegularNote,),
          ),
           ListTile(
          leading:  const AvatarCicle(imgUrl: "https://images.unsplash.com/photo-1570295999919-56ceb5ecca61?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8NHx8YXZhdGFyfGVufDB8fDB8fA%3D%3D&auto=format&fit=crop&w=700&q=60", radius: 50, ),

          title: Text('Nguyễn Phạm Luân Lý ', style: kText16BoldBlack,),

          subtitle: Text("Đã  đăng nhập hơn 3 ngày trước  ", style: kText13RegularNote,),
          ),
          InkWell(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(width: 8.w,),
                IconButton(icon: const Icon( Icons.add_circle, color: cwColorGreyNoteText, size: 50,), onPressed: () {  },),
                SizedBox(width: 23.w,),
                Padding(
                  padding: const EdgeInsets.only(top: 18),

                  child: Text('Thêm tài khoản  ', style: kText17BoldBlack,),

                )
            ],),
            onTap: () => {},
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
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(30))),
    ),
      )

    );
  }

  AppBar getAppBar() {
    return AppBar(
      backgroundColor: cwColorBackground,
      elevation: 0,
      iconTheme: const IconThemeData(color: cwColorBlackIcon),
      centerTitle: true,
      toolbarHeight: 70.h,
      title: Text("Chuyển tài khoản ", style: kText20MediumBlack,),
    );
  }
}