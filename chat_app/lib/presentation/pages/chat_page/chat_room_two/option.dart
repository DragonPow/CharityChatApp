
import 'package:chat_app/configs/colorconfig.dart';
import 'package:chat_app/configs/fontconfig.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class OptionChatRomTwo extends StatelessWidget {
  const OptionChatRomTwo({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Padding(
        padding:  EdgeInsets.symmetric(horizontal: 20.w, vertical: 5.h),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //   children: [
            //     Padding(
            //       padding: const EdgeInsets.only(left: 5),
            //       child: Text (label, style: ktext17RegularBlack,),
            //     ),
            //     IconButton(icon: Icon(iconData, color: colorIcon,), onPressed: () {  } ,)
            // ],
            ),
            const Divider(color: cwColorGreyHintText, height: 2,)
          ],
        ),
      ),
      onTap: () => {
  //         Navigator.push(
  //   context,
  //   MaterialPageRoute(builder: (context) => const FileAndImage()),
  // )


      },
    );
  }
}