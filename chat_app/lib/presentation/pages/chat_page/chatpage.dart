import 'package:chat_app/configs/colorconfig.dart';
import 'package:chat_app/configs/fontconfig.dart';
import 'package:chat_app/dataexample/active_user.dart';
import 'package:chat_app/dataexample/shortchat.dart';
import 'package:chat_app/domain/entities/room_overview_entity.dart';
import 'package:chat_app/helper/helper.dart';
import 'package:chat_app/presentation/bloc/active_user/active_user_bloc.dart';
import 'package:chat_app/presentation/bloc/chat_overview/chat_overview_bloc.dart';
import 'package:chat_app/presentation/components/avataruser.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../dependencies_injection.dart';
import '../../bloc/chat_detail/chat_detail_bloc.dart';
import '../../components/avatarcicle.dart';
import 'package:skeleton_loader/skeleton_loader.dart';

import 'chat_room_two/chatroomtwo.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({Key? key}) : super(key: key);

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> with TickerProviderStateMixin {
  late TabController _tabController;
  var _chatOverviewsBloc;
  var _activeUsersBloc;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _chatOverviewsBloc = BlocProvider.of<ChatOverviewBloc>(context);
    _chatOverviewsBloc.add(const ChatOverviewLoad(
        number: 10, searchtype: "private", startIndex: 0, userId: '2'));
    _activeUsersBloc = BlocProvider.of<ActiveUserBloc>(context);
    _activeUsersBloc.add(const ActiveUserLoadEvent(number: 10, startIndex: 0));
  }

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return NestedScrollView(
      floatHeaderSlivers: true,
      headerSliverBuilder: (context, value) {
        return [
          SliverToBoxAdapter(
            child: Container(
              height: 170,
              decoration: const BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage("assets/images/style.png"),
                      fit: BoxFit.fill)),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 40,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Container(
                        height: 40,
                        child: TextField(
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
                  const SizedBox(
                    height: 10,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      BlocBuilder<ActiveUserBloc, ActiveUserState>(
                        builder: (context, state) {
                          if (state is ActiveUserLoadSuccess) {
                            return Padding(
                              padding: const EdgeInsets.only(left: 10),
                              child: SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.max,
                                    children: List.generate(
                                        state.listUserActive.length,
                                        (index) => AvatarUser(
                                              radius: 50,
                                              imageUrl: state
                                                  .listUserActive[index]
                                                  .avatarUri,
                                              name: state
                                                  .listUserActive[index].name,
                                              id: state
                                                  .listUserActive[index].id,
                                            ))),
                              ),
                            );
                          } else {
                            return Container();
                          }
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          SliverAppBar(
            pinned: true,
            stretch: true,
            floating: true,
            automaticallyImplyLeading: false,
            backgroundColor: Colors.white,
            title: TabBar(
              indicator: const UnderlineTabIndicator(
                  borderSide: BorderSide(
                    width: 2,
                    color: cwColorMain,
                  ),
                  insets: EdgeInsets.only(left: 0, right: 8, bottom: 4)),
              unselectedLabelColor: cwColorGreyNoteText,
              controller: _tabController,
              labelColor: cwColorMain,
              labelStyle: kText15BoldMain,
              isScrollable: true,
              tabs: const [
                Tab(text: "Chat"),
                Tab(text: "Nhóm chat "),
              ],
              onTap: (index) {
                index == 0
                    ? _chatOverviewsBloc.add(const ChatOverviewLoad(
                        number: 10,
                        searchtype: "private",
                        startIndex: 0,
                        userId: "2"))
                    : _chatOverviewsBloc.add(const ChatOverviewLoad(
                        number: 10,
                        searchtype: "group",
                        startIndex: 0,
                        userId: "2"));
              },
            ),
          ),
        ];
      },
      body: SingleChildScrollView(
        child: BlocBuilder<ChatOverviewBloc, ChatOverviewState>(
          builder: (context, state) {
            if (state is ChatOverviewLoadSuccess) {
              return ListView.builder(
                  shrinkWrap: true,
                  itemCount: state.listRoomOverview.length,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (BuildContext context, int index) {
                    return ShortChat( roomOverview: state.listRoomOverview[index],);
                  });
            } else {
              if (state is ChatOverviewLoadFail) {
                return const Text("Load chat fail");
              } else {
                return const Text("Loading");
              }
            }
          },
        ),
        // SkeletonloaderChat()
      ),
    );
  }
}

class SkeletonloaderChat extends StatelessWidget {
  const SkeletonloaderChat({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SkeletonLoader(
      builder: Column(children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
          child: Row(
            children: <Widget>[
              CircleAvatar(
                backgroundColor: Colors.white,
                radius: 30.h,
              ),
              SizedBox(
                width: 5.w,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(
                      height: 3.h,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                        SizedBox(
                          height: 20,
                          width: 100,
                        ),
                        SizedBox(
                          height: 10,
                          width: 50,
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 5.h,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const SizedBox(
                          height: 10,
                          width: 200,
                        ),
                        CircleAvatar(
                          backgroundColor: Colors.white,
                          radius: 15.h,
                        ),
                      ],
                    )
                  ],
                ),
              )
            ],
          ),
        ),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 30),
          child: Divider(
            color: cwColorBackground,
            height: 2,
          ),
        )
      ]),
      items: 10,
      period: const Duration(seconds: 2),
      highlightColor: const Color(0x505AA469),
      direction: SkeletonDirection.ltr,
    );
  }
}

class ShortChat extends StatelessWidget {
  final RoomOverviewEntity roomOverview;
  const ShortChat(
      {Key? key,
      required this.roomOverview})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Column(children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
          child: Row(
            children: <Widget>[
              AvatarCicle(imgUrl: roomOverview.avatarUrl ?? "", radius: 45),
              SizedBox(
                width: 5.w,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(
                      height: 3.h,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(roomOverview.name, style: kText13BoldBlack),
                        Text(
                          roomOverview.lastMessage != null ? parseDatetimeToTime(roomOverview.lastMessage!.timeCreate): "",
                          style: kText11RegularHintText,
                        )
                      ],
                    ),
                    SizedBox(
                      height: 5.h,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          roomOverview.lastMessage == null? "" : roomOverview.lastMessage!.getName,
                          style: kText11RegularHintText,
                        ),
                        Container(
                          width: 20.w,
                          height: 20.w,
                          decoration: const BoxDecoration(
                              shape: BoxShape.circle, color: cwColorMain),
                          child: Align(
                              alignment: Alignment.center,
                              child: Text(
                                "10", //TODO: Remove it
                                style: kText11RegularWhite,
                              )),
                        )
                      ],
                    )
                  ],
                ),
              )
            ],
          ),
        ),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 30),
          child: Divider(
            color: cwColorBackground,
            height: 2,
          ),
        )
      ]),
      onTap: () => {
        Navigator.of(context).push(
          MaterialPageRoute(
              builder: (context) => BlocProvider(
                    create: (context) => ChatDetailBloc(chatRepository: sl()),
                    child: ChatRoom( 
                      roomOverview: roomOverview,),
                  )),
        )
      },
    );
  }
}
