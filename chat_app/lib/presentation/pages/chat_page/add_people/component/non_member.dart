import 'package:chat_app/domain/entities/user_active_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../configs/colorconfig.dart';
import '../../../../../configs/fontconfig.dart';
import '../../../../components/avatarcicle.dart';

class NonMember extends StatefulWidget {
  final UserActiveEntity nonmember;
  final Function? onTap;
  final bool isCreateGroup;
  const NonMember(
      {Key? key,
      required this.nonmember,
      required this.onTap,
      this.isCreateGroup = false})
      : super(key: key);

  @override
  State<NonMember> createState() => _NonMember();
}

class _NonMember extends State<NonMember> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 5.h),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  AvatarCicle(imgUrl: widget.nonmember.avatarUri, radius: 44),
                  SizedBox(
                    width: 5.w,
                  ),
                  Text(
                    widget.nonmember.name,
                    style: ktext17RegularBlack,
                  ),
                ],
              ),
              widget.isCreateGroup
                  ? TextButton(
                      onPressed: () => {widget.onTap!()},
                      child: Text(
                        "Mời",
                        style: kText17SemiboldMain,
                      ))
                  : const SizedBox(
                      width: 0,
                      height: 0,
                    )
            ],
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: const Divider(
              color: cwColorBackground,
              height: 2,
            ),
          )
        ],
      ),
    );
  }
}
