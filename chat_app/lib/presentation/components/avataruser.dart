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
          const AvatarCicle(imgUrl: "https://images.unsplash.com/photo-1635805737707-575885ab0820?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8NXx8bW92aWUlMjBwb3N0ZXJ8ZW58MHx8MHx8&auto=format&fit=crop&w=500&q=60", radius: 50),
          Text(
            widget.name,
            style: kText10RegularBlack,
          )
        ],
      ),
    );
  }
}
