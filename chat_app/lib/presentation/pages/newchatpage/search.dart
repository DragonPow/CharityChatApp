import 'package:chat_app/configs/colorconfig.dart';
import 'package:chat_app/domain/entities/user_active_entity.dart';
import 'package:chat_app/presentation/pages/chat_page/add_people/component/non_member.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../configs/fontconfig.dart';

class SearchNewGroup extends StatelessWidget {
  final bool isCreateGroup;
  final Function? onClickUser;
  const SearchNewGroup({Key? key, this.isCreateGroup = false, this.onClickUser }) : super(key: key);

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
                padding: EdgeInsets.fromLTRB(0, 5.h, 0, 15.h),
                child: Container(
                  height: 50.h,
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
            children: [
              SizedBox(
                height: 20.h,
              ),
              Text(
                "Gợi ý",
                style: kText13RegularNote,
              ),
              SizedBox(
                height: 10.h,
              ),
              ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: 5,
                  itemBuilder: (BuildContext context, int index) {
                    return NonMember(isCreateGroup: isCreateGroup, nonmember: UserActiveEntity(id: "", name: "name", avatarUri:""), onTap: onClickUser!() ?? ()=>{});
                  })
            ],
          ),
        ),
      ),
    );
  }
}
