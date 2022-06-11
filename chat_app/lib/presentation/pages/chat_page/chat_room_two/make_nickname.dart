import 'package:chat_app/configs/colorconfig.dart';
import 'package:chat_app/configs/fontconfig.dart';
import 'package:chat_app/domain/entities/user_room_entity.dart';
import 'package:chat_app/presentation/bloc/message_setting/message_setting_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MakeNickName extends StatelessWidget {
  final List<UserRoomEntity> listJoiner;
  final String roomId;
  const MakeNickName({Key? key, required this.listJoiner, required this.roomId})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: getAppBar(),
      body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: ListView.builder(
            // physics: const NeverScrollableScrollPhysics(),
            // shrinkWrap: true,
            itemCount: listJoiner.length,
            itemBuilder: (BuildContext context, int index) {
              return NickName(
                  id: listJoiner[index].id,
                  imgUrl: listJoiner[index].avatarUri,
                  name: listJoiner[index].name,
                  nickName: listJoiner[index].nameAlias,
                  onClickChangeAlias: (String? alias) {
                    BlocProvider.of<MessageSettingBloc>(context)
                        .add(MessageSettingChangeNameAlias(
                      newNameAlias: {
                        listJoiner[index].id: alias,
                      },
                      roomId: roomId,
                    ));
                    // listJoiner[index] = listJoiner[index].copyWith(nameAlias: alias);
                  });
            },
          )),
    );
  }

  AppBar getAppBar() {
    return AppBar(
      backgroundColor: cwColorBackground,
      centerTitle: true,
      iconTheme: const IconThemeData(color: cwColorBlack),
      elevation: 0,
      title: Text(
        "Biệt danh",
        style: kText20MediumBlack,
      ),
    );
  }
}

class NickName extends StatefulWidget {
  final String id;
  final String? imgUrl;
  final String? nickName;
  final String name;
  final Function(String? alias)? onClickChangeAlias;
  const NickName({
    Key? key,
    required this.id,
    required this.imgUrl,
    this.nickName,
    required this.name,
    this.onClickChangeAlias,
  }) : super(key: key);

  @override
  State<NickName> createState() => _NickNameState();
}

class _NickNameState extends State<NickName> {
  late TextEditingController nickNameController;
  @override
  void initState() {
    super.initState();

    nickNameController = TextEditingController(text: widget.nickName);
  }

  @override
  void dispose() {
    nickNameController.dispose();
    super.dispose();
  }

  void onTap(String nickname) {
    showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: Text(
          'Chỉnh sửa biệt danh',
          style: ktext17RegularBlack,
        ),
        content: TextFormField(
          controller: nickNameController,
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(context, 'Hủy'),
            child: Text(
              'Hủy',
              style: kText15RegularMain,
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context, 'Lưu');
              // if (nickNameController.text.isNotEmpty) {
              widget.onClickChangeAlias?.call(nickNameController.text.isEmpty
                  ? null
                  : nickNameController.text);
              // }
              setState(() {});
            },
            child: Text(
              'Lưu',
              style: kText15RegularMain,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Column(
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 25.h,
                backgroundImage: widget.imgUrl != null
                    ? NetworkImage(widget.imgUrl!)
                    : const AssetImage("assets/images/defauldavatar.png")
                        as ImageProvider,
              ),
              SizedBox(
                width: 10.w,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    nickNameController.text.isEmpty ? widget.name : nickNameController.text,
                    style: kText15BoldBlack,
                  ),
                  SizedBox(
                    height: 3.h,
                  ),
                  Text(
                    widget.name,
                    style: kText13RegularNote,
                  )
                ],
              )
            ],
          ),
          SizedBox(
            height: 15.h,
          )
        ],
      ),
      onTap: () {
        onTap(widget.nickName == null ? widget.name : widget.nickName!);
      },
    );
  }
}
