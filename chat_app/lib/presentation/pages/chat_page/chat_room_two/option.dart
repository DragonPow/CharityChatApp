import 'package:chat_app/configs/colorconfig.dart';
import 'package:chat_app/configs/fontconfig.dart';
import 'package:chat_app/domain/entities/room_overview_entity.dart';
import 'package:chat_app/presentation/bloc/message_setting/message_setting_bloc.dart';
import 'package:chat_app/presentation/components/avatarcicle.dart';
import 'package:chat_app/presentation/pages/chat_page/chat_room_two/fileandimage.dart';
import 'package:chat_app/presentation/pages/chat_page/chat_room_two/make_nickname.dart';
import 'package:chat_app/presentation/pages/chat_page/call_video/video_call_agora.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class OptionChatRoom extends StatelessWidget {
  final RoomOverviewEntity room;
  const OptionChatRoom({Key? key, required this.room}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    void onTapImageAndFile() {
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (_) => BlocProvider.value(
                  value: BlocProvider.of<MessageSettingBloc>(context)
                    ..add(MessageSettingLoadImageFile(
                      startIndex: 0,
                      number: 10,
                      roomId: room.id,
                      typeLoad: 'image',
                    ))
                    ..add(MessageSettingLoadImageFile(
                      startIndex: 0,
                      number: 10,
                      roomId: room.id,
                      typeLoad: 'file',
                    )),
                  child: FileAndImage(roomId: room.id),
                )),
      );
    }

    void onTapMakeNickName() {
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (_) => BlocProvider.value(
                  value: BlocProvider.of<MessageSettingBloc>(context),
                  child: MakeNickName(
                    listJoiner: room.joiners,
                    roomId: room.id,
                  ),
                )),
      );
    }

    void onTapSearchInChat() {
      showDialog<String>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: Text(
            'Đặt tên cho cuộc trò chuyện',
            style: ktext17RegularBlack,
          ),
          content: TextFormField(),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context, 'Hủy'),
              child: Text(
                'Hủy',
                style: kText15RegularRed,
              ),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, 'Lưu'),
              child: Text(
                'Lưu',
                style: kText15RegularMain,
              ),
            ),
          ],
        ),
      );
    }

    void onTapBan() {
      showDialog<String>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: Text(
            'Chặn tin nhắn và cuộc gọi',
            style: ktext17RegularBlack,
          ),
          content: Text(
            "Tài khoản của bạn từ bây giờ sẽ không nhận được tin nhắn hay cuộc goiij từ tài khoản này",
            style: kText15RegularBlack,
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
              onPressed: () => Navigator.pop(context, 'Tìm kiếm'),
              child: Text(
                'Tìm kiếm',
                style: kText15RegularMain,
              ),
            ),
          ],
        ),
      );
    }

    return Scaffold(
      appBar: getAppBar(),
      body: SingleChildScrollView(
        child: Column(children: [
          SizedBox(
            height: 30.h,
          ),
          AvatarCicle(imgUrl: room.avatarUrl ?? "", radius: 120),
          SizedBox(
            height: 10.h,
          ),
          Text(
            room.name,
            style: kText24BoldBlack,
          ),
          SizedBox(
            height: 20.h,
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 90.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                 room.type == "group" ? Center(
                  child: Ink(
                    decoration: const ShapeDecoration(
                      color: cwColor25GreyNoteText,
                      shape: CircleBorder(),
                    ),
                    child: IconButton(
                      icon: Padding(
                        padding: EdgeInsets.only(bottom: 3.h),
                        child: const Icon(
                          Icons.people,
                          size: 30,
                        ),
                      ),
                      color: cwColorBlack,
                      onPressed: () {},
                    ),
                  ),
                ) : const SizedBox(width: 0,),
                Center(
                  child: Ink(
                    decoration: const ShapeDecoration(
                      color: cwColor25GreyNoteText,
                      shape: CircleBorder(),
                    ),
                    child: IconButton(
                      icon: Padding(
                        padding: EdgeInsets.only(bottom: 3.h),
                        child: const Icon(
                          FontAwesomeIcons.video,
                          size: 25,
                        ),
                      ),
                      color: cwColorBlack,
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (_) => VideoCallAgora(
                                  roomId: room.id,
                                )));
                      },
                    ),
                  ),
                ),
                Center(
                  child: Ink(
                    decoration: const ShapeDecoration(
                      color: cwColor25GreyNoteText,
                      shape: CircleBorder(),
                    ),
                    child: IconButton(
                      icon: Padding(
                        padding: EdgeInsets.only(bottom: 3.h),
                        child: const Icon(
                          FontAwesomeIcons.phone,
                          size: 25,
                        ),
                      ),
                      color: cwColorBlack,
                      onPressed: () {},
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 15,
          ),
          Option(
              label: "File và hình ảnh  ",
              iconData: Icons.image_outlined,
              colorIcon: cwColorGreyNoteText,
              onTap: onTapImageAndFile),
          Option(
            label: "Đặt biệt danh  ",
            iconData: Icons.edit,
            colorIcon: cwColorGreyNoteText,
            onTap: onTapMakeNickName,
          ),
          
          Option(
            label: "Đổi tên cuộc trò chuyện",
            iconData: Icons.label,
            colorIcon: cwColorGreyNoteText,
            onTap: onTapSearchInChat,
          ),
        ]),
      ),
    );
  }

  AppBar getAppBar() {
    return AppBar(
      iconTheme: const IconThemeData(color: cwColorBlackIcon),
      backgroundColor: cwColorBackground,
      centerTitle: true,
      elevation: 0,
      title: Text(
        "Tùy chỉnh ",
        style: kText17BoldBlack,
      ),
    );
  }
}

class Option extends StatelessWidget {
  final String label;
  final IconData iconData;
  final Color colorIcon;
  final void Function()? onTap;
  const Option({
    required this.label,
    required this.iconData,
    required this.colorIcon,
    this.onTap,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 5.h),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 5),
                  child: Text(
                    label,
                    style: ktext17RegularBlack,
                  ),
                ),
                IconButton(
                  icon: Icon(
                    iconData,
                    color: colorIcon,
                  ),
                  onPressed: () {},
                )
              ],
            ),
            const Divider(
              color: cwColorGreyHintText,
              height: 2,
            )
          ],
        ),
      ),
      onTap: onTap,
    );
  }
}
