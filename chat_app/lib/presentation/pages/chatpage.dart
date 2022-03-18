import 'package:chat_app/configs/colorconfig.dart';
import 'package:chat_app/configs/fontconfig.dart';
import 'package:chat_app/presentation/components/avataruser.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../components/avatarcicle.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({Key? key}) : super(key: key);

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage>  with TickerProviderStateMixin  {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
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
                  height: 145,
                  decoration: const BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage("assets/images/style.png"),
                          fit: BoxFit.fill)),
                  child: Column(
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
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 10),
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                  children: List.generate(
                                      10,
                                      (index) => const AvatarUser(
                                          radius: 50,
                                          imageUrl:
                                              "https://images.unsplash.com/photo-1599566150163-29194dcaad36?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=387&q=80",
                                          name: "Anan"))),
                            ),
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
                  onTap: (index) {},
                ),
              ),
            ];
          },
          body: SingleChildScrollView(
            child: ListView.builder(
                shrinkWrap: true,
                itemCount: 10,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (BuildContext context, int index) {
                  return const ShortChat();
                }),
          ),
        );
  }
}

class ShortChat extends StatelessWidget {
  const ShortChat({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Padding(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
        child: Row(
          children: <Widget>[
            const AvatarCicle(
                imgUrl:
                    "https://images.unsplash.com/photo-1635805737707-575885ab0820?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8NXx8bW92aWUlMjBwb3N0ZXJ8ZW58MHx8MHx8&auto=format&fit=crop&w=500&q=60",
                radius: 40),
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
                      Text("Pham tuan", style: kText13BoldBlack),
                      Text(
                        "12:30 am",
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
                        "Xin chào, mình làm quen nha!",
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
                              "13",
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
    ]);
  }
}
