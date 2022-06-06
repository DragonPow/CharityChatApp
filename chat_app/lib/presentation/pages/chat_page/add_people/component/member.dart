import 'package:chat_app/domain/entities/user_active_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../configs/colorconfig.dart';
import '../../../../components/avataruser.dart';

class Member extends StatefulWidget {
  final UserActiveEntity member;
  final  Function onTap;
  const Member({Key? key, required this.member, required this.onTap})
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
          imageUrl: widget.member.avatarUri,
          name: widget.member.name,
          radius: 40.w,
          id: widget.member.id,
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
                  child: IconButton(
                    onPressed: () => widget.onTap() ,
                    icon:  Icon(Icons.close,  size: 10.w, color:cwColorWhite ,),
                  ),
                ),
              ),
            )),
      ],
    );
  }
}
