import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../configs/colorconfig.dart';
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
        children: [
          Container(
              width: widget.radius,
              height: widget.radius,
              decoration: const BoxDecoration(
                  gradient: LinearGradient(colors: cwColorGradientActive),
                  shape: BoxShape.circle),
              child: Padding(
                padding: const EdgeInsets.all(2),
                child: Container(
                  width: widget.radius - 4,
                  height: widget.radius - 4,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                        image: NetworkImage(widget.imageUrl != ""
                            ? widget.imageUrl
                            : "images/avatar.png"),
                        fit: BoxFit.cover),
                    border: Border.all(color: cwColorBackground, width: 2),
                  ),
                ),
              )),
          Text(
            widget.name,
            style: kText10RegularBlack,
          )
        ],
      ),
    );
  }
}
