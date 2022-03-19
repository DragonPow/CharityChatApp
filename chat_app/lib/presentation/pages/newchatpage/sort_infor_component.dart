import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../configs/colorconfig.dart';
import '../../../configs/fontconfig.dart';
import '../../components/avatarcicle.dart';

class SortInforComponent extends StatefulWidget {
  const SortInforComponent({Key? key}) : super(key: key);
  @override
  State<SortInforComponent> createState() => _SortInforComponent();
}

class _SortInforComponent extends State<SortInforComponent> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            AvatarCicle(
                radius: 43.w,
                imgUrl:
                    "https://images.unsplash.com/photo-1494790108377-be9c29b29330?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8Mnx8YXZhdGFyfGVufDB8fDB8fA%3D%3D&auto=format&fit=crop&w=500&q=60"),
            SizedBox(
              width: 5.w,
            ),
            Text(
              "Anna Hoang",
              style: kText17SemiboldBlack,
            )
          ],
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(50.w, 0, 10.w, 0),
          child: const Divider(
            color: cwColorBackground,
            height: 2,
          ),
        ),
        SizedBox(height: 5.h,)
      ],
    );
  }
}
