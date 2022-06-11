import 'package:chat_app/presentation/pages/chat_page/add_people/add_people.dart';
import 'package:chat_app/presentation/pages/newchatpage/search.dart';
import 'package:chat_app/presentation/pages/newchatpage/sort_infor_component.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../configs/colorconfig.dart';
import '../../../configs/fontconfig.dart';
import '../../../dependencies_injection.dart';
import '../../bloc/add_member/add_member_bloc.dart';
import '../../bloc/chat_detail/chat_detail_bloc.dart';
import '../../bloc/new_message/new_message_bloc.dart';
import '../../bloc/search_user/search_user_bloc.dart';
import '../chat_page/chat_room_two/chatroomtwo.dart';

class NewChatPage extends StatefulWidget {
  const NewChatPage({Key? key}) : super(key: key);

  @override
  State<NewChatPage> createState() => _NewChatPage();
}

class _NewChatPage extends State<NewChatPage> {
  var _newMessageBloc;

  @override
  void initState() {
    super.initState();
    _newMessageBloc = BlocProvider.of<NewMessageBloc>(context);
    _newMessageBloc.add(const NewMessageLoad(number: 10, startIndex: 0));
  }

  @override
  Widget build(BuildContext context) {
    return NestedScrollView(
      floatHeaderSlivers: true,
      headerSliverBuilder: (context, value) {
        return [
          SliverAppBar(
            pinned: true,
            stretch: true,
            floating: true,
            automaticallyImplyLeading: false,
            backgroundColor: cwColorBackground,
            title: InkWell(
                child: SizedBox(
                  height: 60.h,
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(0, 5.h, 0, 15.h),
                    child: Container(
                      height: 50.h,
                      child: TextField(
                          enabled: false,
                          maxLines: 1,
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              contentPadding: const EdgeInsets.all(13),
                              hintText: "Tìm kiếm",
                              hintStyle: kText15RegularGreyNotetext,
                              prefixIcon: const Icon(Icons.search))),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: cwColorWhite),
                    ),
                  ),
                ),
                onTap: () => {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => BlocProvider(
                                    create: (context) =>
                                        SearchUserBloc(sl(), sl()),
                                    child: const SearchNewGroup(),
                                  )))
                    }),
          ),
        ];
      },
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.fromLTRB(20.w, 10.h, 20.w, 10.h),
          child: Column(
            children: [
              TextButton.icon(
                  icon: const FaIcon(
                    FontAwesomeIcons.users,
                    color: cwColorWhite,
                  ),
                  label: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Tạo nhóm mới",
                        style: kText16RegularWhite,
                      ),
                      IconButton(
                          onPressed: () => {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => BlocProvider(
                                            create: (context) =>
                                                AddMemberBloc(sl()),
                                            child: const AddPeople(),
                                          )),
                                )
                              },
                          icon: const FaIcon(
                            FontAwesomeIcons.angleRight,
                            color: cwColorWhite,
                          ))
                    ],
                  ),
                  onPressed: () => {},
                  style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all<Color>(cwColorMain),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                      padding: MaterialStateProperty.all<EdgeInsets>(
                          EdgeInsets.fromLTRB(20.w, 5.h, 0, 5.h)))),
              SizedBox(
                height: 20.h,
              ),
              BlocConsumer<NewMessageBloc, NewMessageState>(
                listener: (context, state) {
                  if (state is NewMessageOpenRoomSuccess) {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => BlocProvider(
                                  create: (context) =>
                                      ChatDetailBloc(chatRepository: sl()),
                                  child: ChatRoom(
                                    roomOverview: state.roomOverviewEntity,
                                  ),
                                )));
                  }
                  if (state is NewMessageOpenRoomFail) {
                    showDialog<String>(
                      context: context,
                      builder: (BuildContext context) => AlertDialog(
                        title: const Text('Lỗi hệ thống'),
                        content: const Text('Vui lòng thử lại sau!'),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () => Navigator.pop(context, 'Cancel'),
                            child: const Text('Hủy'),
                          ),
                          TextButton(
                            onPressed: () => Navigator.pop(context, 'OK'),
                            child: const Text('Xác nhận'),
                          ),
                        ],
                      ),
                    );
                  }
                },
                builder: (context, state) {
                  return BlocBuilder<NewMessageBloc, NewMessageState>(
                    builder: (context, state) {
                      if (state is NewMessageLoadSuccess) {
                        return ListView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: state.friendUsers.length,
                            itemBuilder: (BuildContext context, int index) {
                              return InkWell(
                                child: SortInforComponent(
                                    imgUrl: state.friendUsers[index].avatarUri,
                                    id: state.friendUsers[index].id,
                                    name: state.friendUsers[index].name),
                                onTap: () => {
                                  _newMessageBloc.add(NewMessageOpenRoom(
                                      otherUser: state.friendUsers[index]))
                                },
                              );
                            });
                      } else {
                        if (state is NewMessageLoadFail) {
                          return const Text("Load fail");
                        } else {
                          return const SkeletonloaderAddMem();
                        }
                      }
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
