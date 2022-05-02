import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../configs/colorconfig.dart';
import '../../../configs/fontconfig.dart';
import '../../components/avatarcicle.dart';

class SortInforComponent extends StatefulWidget {
  final String name;
  final String imgUrl;
  const SortInforComponent({Key? key, required this.imgUrl, required this.name}) : super(key: key);
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
                imgUrl: widget.imgUrl ),
            SizedBox(
              width: 5.w,
            ),
            Text(
              widget.name,
              style: kText15BoldBlack ,
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
