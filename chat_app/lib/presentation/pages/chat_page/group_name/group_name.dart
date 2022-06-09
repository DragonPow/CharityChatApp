import 'dart:io';

import 'package:chat_app/configs/colorconfig.dart';
import 'package:chat_app/configs/fontconfig.dart';
import 'package:chat_app/domain/entities/user_active_entity.dart';
import 'package:chat_app/presentation/bloc/make_name_group/make_name_group_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../dependencies_injection.dart';
import '../../../../domain/entities/room_entity.dart';
import '../../../bloc/chat_detail/chat_detail_bloc.dart';
import '../add_people/component/member.dart';
import '../chat_room_two/chatroomtwo.dart';

class GroupName extends StatefulWidget {
  final List<UserActiveEntity> listMember;
  const GroupName({Key? key, required this.listMember}) : super(key: key);

  @override
  State<GroupName> createState() => _GroupName();
}

class _GroupName extends State<GroupName> {
  var members;
  var avatar;
  var _makeNameGroupBloc;
  var _nameTextController;

  @override
  void initState() {
    super.initState();
    _makeNameGroupBloc = BlocProvider.of<MakeNameGroupBloc>(context);
    members = widget.listMember;
    _nameTextController = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    _nameTextController.dispose();
  }

  void _handleImageSelection() async {
    final result = await ImagePicker().pickImage(
      imageQuality: 70,
      maxWidth: 1440,
      source: ImageSource.gallery,
    );
    if (result == null) return;

    final bytes = await result.readAsBytes();
    final image = await decodeImageFromList(bytes);
    avatar = File(result.path);
    // change avatar group
    _makeNameGroupBloc
        .add(MakeNameGroupChoiceAvatar(avatar: File(result.path)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: getAppBar(),
      body: SingleChildScrollView(
        child: Column(children: [
          SizedBox(
            height: 20.h,
          ),
          Stack(
            children: [
              BlocConsumer<MakeNameGroupBloc, MakeNameGroupState>(
                listenWhen: (context, state) {
                  return state is MakeNameGroupChoiceAvatarSuccess ||
                      state is MakeNameGroupInitial;
                },
                listener: (context, state) {},
                builder: (context, state) {
                  if (state is MakeNameGroupChoiceAvatarSuccess) {
                    avatar = state.avatar;
                    return CircleAvatar(
                      backgroundImage: FileImage(File(state.avatar.path)),
                      radius: 100,
                    );
                  } else {
                    return const CircleAvatar(
                      backgroundImage: AssetImage("assets/images/avatar.png"),
                      radius: 100,
                    );
                  }
                },
              ),
              Positioned(
                  bottom: 10,
                  right: 20,
                  child: Container(
                    width: 25.w,
                    height: 25.w,
                    alignment: Alignment.center,
                    decoration: const BoxDecoration(
                        shape: BoxShape.circle, color: cwColorWhite),
                    child: IconButton(
                      padding: const EdgeInsets.all(0),
                      icon: const FaIcon(
                        FontAwesomeIcons.camera,
                        color: cwColorMain,
                        size: 16,
                      ),
                      onPressed: () => {_handleImageSelection()},
                    ),
                  )),
            ],
          ),
          SizedBox(
            height: 10.h,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 30.w),
            child: TextFormField(
              style: ktext17RegularBlack,
              textAlign: TextAlign.center,
              controller: _nameTextController,
              decoration: InputDecoration(
                  border: const UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                  enabledBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                  focusedBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                  hintText: "Tên nhóm",
                  hintStyle: ktext17RegularGreyText),
            ),
          ),
          SizedBox(
            height: 20.h,
          ),
          BlocConsumer<MakeNameGroupBloc, MakeNameGroupState>(
            listenWhen: (context, state) {
              return state is MakeNameGroupRemoveMemSuccess ||
                  state is MakeNameGroupInitial;
            },
            listener: (context, state) {
              if (state is MakeNameGroupCreateSuccess) {
                Navigator.of(context).push(
                  MaterialPageRoute(
                      builder: (context) => BlocProvider(
                            create: (context) =>
                                ChatDetailBloc(chatRepository: sl()),
                            child: ChatRoom(
                              roomOverview: state.roomEntity,
                            ),
                          )),
                );
              }
            },
            builder: (context, state) {
              if (state is MakeNameGroupRemoveMemSuccess) {
                return Padding(
                  padding: EdgeInsets.symmetric(horizontal: 4.w),
                  child: Wrap(
                    children: List.generate(
                      state.listMember.length,
                      (index) => Member(
                        member: members[index],
                        onTap: () => {
                          _makeNameGroupBloc.add(MakeNameGroupRemoveMem(
                              listMember: state.listMember,
                              removedMember: state.listMember[index]))
                        },
                      ),
                    ),
                  ),
                );
              } else {
                return Padding(
                  padding: EdgeInsets.symmetric(horizontal: 4.w),
                  child: Wrap(
                    children: List.generate(
                      members.length,
                      (index) => Member(
                        member: members[index],
                        onTap: () => {
                          _makeNameGroupBloc.add(MakeNameGroupRemoveMem(
                              listMember: members,
                              removedMember: members[index]))
                        },
                      ),
                    ),
                  ),
                );
              }
            },
          )
        ]),
      ),
    );
  }

  AppBar getAppBar() {
    return AppBar(
      iconTheme: const IconThemeData(color: cwColorBlackIcon),
      backgroundColor: cwColorBackground,
      title: const Text("Nhóm mới"),
      titleTextStyle: kText20MediumBlack,
      centerTitle: true,
      elevation: 0,
      actions: [
        TextButton(
            onPressed:() =>  onCreateButtonPress(),
            child: Text(
              "Tạo",
              style: kText17SemiboldMain,
            ))
      ],
      flexibleSpace: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage("assets/images/style.png"), fit: BoxFit.cover),
        ),
      ),
    );
  }

  void onCreateButtonPress() {
    _makeNameGroupBloc.add(MakeNameGroupCreate(
        avatar: avatar,
        room: RoomEntity(
            messages: [],
            name: _nameTextController.text,
            users: members,
            typeRoom: members.length > 1 ? 'group' : "private",
            id: '')));
  }
}
