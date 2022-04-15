import 'package:chat_app/configs/colorconfig.dart';
import 'package:chat_app/presentation/pages/chat_page/group_name/group_name.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../configs/fontconfig.dart';
import 'component/member.dart';
import 'component/non_member.dart';

class AddPeople extends StatefulWidget {
  const AddPeople({Key? key}) : super(key: key);

  @override
  State<AddPeople> createState() => _AddPeople();
}

class _AddPeople extends State<AddPeople> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: getAppBar(),
        body: NestedScrollView(
            floatHeaderSlivers: true,
            headerSliverBuilder: (context, value) {
              return [
                SliverAppBar(
                  pinned: true,
                  stretch: true,
                  floating: false,
                  toolbarHeight: 145.h,
                  automaticallyImplyLeading: false,
                  backgroundColor: cwColorBackground,
                  title: Column(
                    children: [
                      SizedBox(
                        height: 60.h,
                        child: Padding(
                          padding: EdgeInsets.fromLTRB(0, 5.h, 0, 15.h),
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
                      Column(
                        children: [
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: List.generate(
                                10,
                                (index) => const Member(),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 15.h,
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ];
            },
            body: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 10.h,
                    ),
                    ListView.builder(
                        shrinkWrap: true,
                        itemCount: 10,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (BuildContext context, int index) {
                          return const NonMember();
                        }),
                  ],
                ),
              ),
            )));
  }

  AppBar getAppBar() {
    return AppBar(
      iconTheme: const IconThemeData(color: cwColorBlackIcon),
      title: const Text(
        "Thêm thành viên ",
      ),
      titleTextStyle: kText20MediumBlack,
      centerTitle: true,
      backgroundColor: cwColorBackground,
      elevation: 0,
      //automaticallyImplyLeading: false,
      actions: [
        TextButton(
          child: Text("Tiếp", style: kText18RegularMain),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const GroupName()),
            );
          },
        )
      ],
    );
  }
}
