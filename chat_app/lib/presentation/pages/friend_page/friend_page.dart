import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../configs/colorconfig.dart';
import '../../../configs/fontconfig.dart';
import '../newchatpage/sort_infor_component.dart';

class FriendPage extends StatefulWidget {
  const FriendPage ({Key? key}):super(key: key);

  @override
  State<FriendPage> createState() => _FriendPage();
}

class _FriendPage extends State<FriendPage>{

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
                    title: SizedBox(
                      height: 60.h,
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(0, 0, 0, 15.h),
                        child: Container(
                          height: 40.h,
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
                  ),
                ];
              },
              body: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(20.w, 10.h, 20.w, 10.h),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 5.h,
                      ),
                      Text("Bạn bè (125)", style: kText20MediumBlack),
                      SizedBox(
                        height: 10.h,
                      ),
                      ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: 15,
                          itemBuilder: (BuildContext context, int index) {
                            return const SortInforComponent();
                          })
                    ],
                  ),
                ),
              ),
            );
  }
}