import 'package:chat_app/presentation/components/avatarcicle.dart';
import 'package:flutter/material.dart';
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
           AvatarCicle(imgUrl: widget.imageUrl, radius: 50),
          Text(
            widget.name,
            style: kText10RegularBlack,
          )
        ],
      ),
    );
  }
}
