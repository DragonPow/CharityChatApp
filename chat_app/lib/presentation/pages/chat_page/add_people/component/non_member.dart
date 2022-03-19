import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../configs/colorconfig.dart';
import '../../../../../configs/fontconfig.dart';
import '../../../../components/avatarcicle.dart';

class NonMember extends StatefulWidget {
  const NonMember ({Key? key}):super(key: key);

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
                        const AvatarCicle(imgUrl: "https://images.unsplash.com/photo-1544725176-7c40e5a71c5e?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8MTN8fGF2YXRhcnxlbnwwfHwwfHw%3D&auto=format&fit=crop&w=500&q=60", radius: 44),
                        SizedBox(width: 5.w,),
                        Text("Jone Cena", style:  kText17SemiboldBlack,),
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