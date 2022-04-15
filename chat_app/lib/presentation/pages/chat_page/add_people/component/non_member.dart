import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../configs/colorconfig.dart';
import '../../../../../configs/fontconfig.dart';
import '../../../../components/avatarcicle.dart';

class NonMember extends StatefulWidget {
  final String name;
  final String imgurl;
  const NonMember ({Key? key, required this.imgurl, required this.name}):super(key: key);

  @override
  State<NonMember> createState() => _NonMember();

  
}

class _NonMember extends State<NonMember>{
  @override
  Widget build(BuildContext context) {
    return Padding(
                 padding: EdgeInsets.only(top: 5.h),
                 child: Column(children: [
              Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                         AvatarCicle(imgUrl:widget.imgurl, radius: 44),
                        SizedBox(width: 5.w,),
                        Text(widget.name, style:  ktext17RegularBlack,),
                      ],
                    ),
                    TextButton(onPressed: () => {}, child: Text("Mời", style: kText17SemiboldMain,))
                  ],
              ),
              Padding(
                  padding:  EdgeInsets.symmetric(horizontal: 20.w),
                  child: const Divider(color: cwColorBackground, height: 2,),
              )
            ],),
               );
  }
  
}