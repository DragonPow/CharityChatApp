import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../configs/colorconfig.dart';
import '../../../../components/avataruser.dart';

class Member extends StatefulWidget {
  final String name;
  final String imgUrl;
  const Member({Key? key, required this.imgUrl, required this.name})
      : super(key: key);

  @override
  State<Member> createState() => _Member();
}

class _Member extends State<Member> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.passthrough,
      children: <Widget>[
        SizedBox(
            child: AvatarUser(
          imageUrl: widget.imgUrl,
          name: widget.name,
          radius: 40.w,
          id: '',
        )),
        Positioned(
            top: 0,
            right: 5.w,
            child: InkWell(
              child: Container(
                width: 15.w,
                height: 15.w,
                alignment: Alignment.center,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: cwColorGreyNoteText,
                ),
                child: Center(
                  child: Icon(
                    Icons.close,
                    color: cwColorWhite,
                    size: 10.w,
                  ),
                ),
              ),
            )),
      ],
    );
  }
}
