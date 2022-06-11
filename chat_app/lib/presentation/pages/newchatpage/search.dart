import 'package:chat_app/configs/colorconfig.dart';
import 'package:chat_app/presentation/bloc/search_user/search_user_bloc.dart';
import 'package:chat_app/presentation/pages/chat_page/add_people/component/non_member.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../configs/fontconfig.dart';
import '../../../dependencies_injection.dart';
import '../../bloc/chat_detail/chat_detail_bloc.dart';
import '../chat_page/add_people/add_people.dart';
import '../chat_page/chat_room_two/chatroomtwo.dart';

class SearchNewGroup extends StatefulWidget {
  final bool isCreateGroup;
  final Function? onClickUser;
  const SearchNewGroup({Key? key, this.isCreateGroup = false, this.onClickUser})
      : super(key: key);

  @override
  State<SearchNewGroup> createState() => _SearchNewGroupState();
}

class _SearchNewGroupState extends State<SearchNewGroup> {
  late SearchUserBloc _searchBloc;
  late TextEditingController _searchEditTextController;

  @override
  void initState() {
    super.initState();
    _searchBloc = BlocProvider.of<SearchUserBloc>(context);
    _searchBloc.add(const SearchUserLoad(number: 10, startIndex: 0));
    _searchEditTextController = TextEditingController(text: "");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        floatHeaderSlivers: true,
        headerSliverBuilder: (context, value) {
          return [
            SliverAppBar(
              pinned: true,
              stretch: true,
              floating: true,
              toolbarHeight: 70.h,
              automaticallyImplyLeading: false,
              backgroundColor: cwColorBackground,
              title: SizedBox(
                height: 60.h,
                child: Padding(
                  padding: EdgeInsets.fromLTRB(0, 5.h, 0, 10.h),
                  child: Container(
                    height: 50.h,
                    child: TextField(
                        controller: _searchEditTextController,
                        onChanged: (c) => {
                              _searchBloc.add(SearchUserSearch(
                                  number: 10, startIndex: 0, searchvalue: c))
                            },
                        maxLines: 1,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.all(13),
                          hintText: "Tìm kiếm",
                          hintStyle: kText15RegularGreyNotetext,
                          prefixIcon: IconButton(
                            icon: const Icon(Icons.arrow_back_ios),
                            color: cwColorBlack,
                            onPressed: () => {Navigator.pop(context)},
                          ),
                          suffixIcon: IconButton(
                            icon: const Icon(Icons.close),
                            color: cwColorBlack,
                            onPressed: () =>
                                {_searchEditTextController.text = ""},
                            splashRadius: 20.w,
                          ),
                        )),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: cwColorBackground),
                  ),
                ),
              ),
            ),
          ];
        },
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.fromLTRB(20.w, 0.h, 20.w, 10.h),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 20.h,
                ),
                Text(
                  "Gợi ý",
                  style: kText13RegularNote,
                ),
                BlocConsumer<SearchUserBloc, SearchUserState>(
                  listener: (context, state) {
                   if(state is SearchUserOpenRoomSuccess)
                   {
                     Navigator.of(context).push(
                                      MaterialPageRoute(
                                          builder: (context) =>
                                           BlocProvider(
                                                create: (context) => ChatDetailBloc(
                                                    chatRepository: sl()),
                                                child: ChatRoom(
                                                  roomId:state.roomEntity.id,
                                                ),
                                              )
                                              ),
                                    );
                   }
                  },
                  builder: (context, state) {
                    return BlocBuilder<SearchUserBloc, SearchUserState>(
                      builder: (context, state) {
                        if (state is SearchUserLoadSuccess) {
                          return ListView.builder(
                              physics: const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: state.listFriend.length,
                              itemBuilder: (BuildContext context, int index) {
                                return InkWell(
                                  child: NonMember(
                                      isCreateGroup: widget.isCreateGroup,
                                      nonmember: state.listFriend[index],
                                      onTap: widget.onClickUser ?? () => {}),
                                  onTap: () => {
                                    _searchBloc.add(SearchUserOpenRoom(
                                        otherUser: state.listFriend[index]))
                                    
                                  },
                                );
                              });
                        } else {
                          return const SkeletonloaderAddMem();
                        }
                      },
                    );
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
