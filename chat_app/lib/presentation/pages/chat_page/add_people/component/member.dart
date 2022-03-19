import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../configs/colorconfig.dart';
import '../../../../../configs/fontconfig.dart';
import '../../../../components/avatarcicle.dart';
import '../../../../components/avataruser.dart';

class Member extends StatefulWidget {
  const Member({Key? key}) : super(key: key);

  @override
  State<Member> createState() => _Member();
}

class _Member extends State<Member> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.passthrough,
      children: <Widget>[
        const SizedBox(
            child: AvatarUser(
          imageUrl:
              "https://images.unsplash.com/photo-1580489944761-15a19d654956?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8OHx8YXZhdGFyfGVufDB8fDB8fA%3D%3D&auto=format&fit=crop&w=500&q=60",
          name: 'Jone Cena',
          radius: 40,
        )),
        Positioned(
            top: 0,
            right: 0,
            child: InkWell(
              child: Container(
                width: 20,
                height: 20,
                alignment: Alignment.center,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: cwColorGreyNoteText,
                ),
                child: const Center(
                  child: Icon(
                    Icons.close,
                    color: cwColorWhite,
                    size: 15,
                  ),
                ),
              ),
            )),
      ],
    );
  }
}
