import 'package:chat_app/presentation/components/avatarcicle.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../configs/fontconfig.dart';

class AvatarUser extends StatefulWidget {
  final double radius;
  final String imageUrl;
  final String name;
  const AvatarUser(
      {Key? key,
      required this.radius,
      required this.imageUrl,
      required this.name})
      : super(key: key);

  @override
  State<AvatarUser> createState() => _AvatarUserState();
}

class _AvatarUserState extends State<AvatarUser> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
           AvatarCicle(imgUrl: widget.imageUrl, radius: 50),
            SizedBox(
            width: 60.h,
            height: 60,
            child: Text(
            widget.name,
            style: kText10RegularBlack,
            overflow: TextOverflow.ellipsis,
            maxLines: 2,
            textAlign: TextAlign.center,
          )
          )
          
        ],
      ),
    );
  }
}
