import 'package:chat_app/configs/colorconfig.dart';
import 'package:chat_app/configs/fontconfig.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MakeNickName extends StatelessWidget {
  const MakeNickName({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: getAppBar(),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: const [
          NickName(
            imgUrl:
                'https://images.unsplash.com/photo-1580489944761-15a19d654956?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8N3x8YXZhdGFyfGVufDB8fDB8fA%3D%3D&auto=format&fit=crop&w=500&q=60',
            name: "Huynh Thi Minh Nhuc",
            nickName: "Be iu",
          ),
           NickName(
            imgUrl:
                'https://images.unsplash.com/photo-1566492031773-4f4e44671857?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8MjB8fGF2YXRhcnxlbnwwfHwwfHw%3D&auto=format&fit=crop&w=500&q=60',
            name: "Tan Thanh",
            nickName: "Ba iu",
          )
        ]),
      ),
    );
  }

  AppBar getAppBar() {
    return AppBar(
      backgroundColor: cwColorBackground,
      centerTitle: true,
      iconTheme: const IconThemeData(color: cwColorBlack),
      elevation: 0,
      title: Text(
        "Biệt danh",
        style: kText20MediumBlack,
      ),
    );
  }
}

class NickName extends StatelessWidget {
  final String imgUrl;
  final String? nickName;
  final String name;
  const NickName(
      {Key? key, required this.imgUrl, this.nickName, required this.name})
      : super(key: key);

  @override
  Widget build(BuildContext context) {

    void onTap(String nickname) {
      TextEditingController nickNameController = TextEditingController(text: nickName);
       showDialog<String>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title:Text('Chỉnh sửa biệt danh', style: ktext17RegularBlack,),
          content: TextFormField(controller: nickNameController,),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context, 'Hủy'),
              child: Text('Hủy',style: kText15RegularMain,),
            ),
             TextButton(
              onPressed: () => Navigator.pop(context, 'Lưu'),
              child: Text('Lưu', style: kText15RegularMain,),
            ),
          ],
        ),
      );
    }

    return InkWell(
      child: Column(
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 25.h,
                backgroundImage: NetworkImage(imgUrl),
              ),
              SizedBox(
                width: 10.w,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    nickName == null ? name : nickName!,
                    style: kText15BoldBlack,
                  ),
                  SizedBox(
                    height: 3.h,
                  ),
                  Text(
                    name,
                    style: kText13RegularNote,
                  )
                ],
              )
            ],
          ),
          SizedBox(height: 15.h,)
        ],
      ),
      onTap: () =>  onTap(nickName == null? name : nickName!),
    );
  }
}
