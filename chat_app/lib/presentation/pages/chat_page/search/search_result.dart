import 'package:chat_app/dataexample/active_user.dart';
import 'package:chat_app/presentation/pages/newchatpage/sort_infor_component.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../../configs/colorconfig.dart';
import '../../../../configs/fontconfig.dart';


class SearchResult extends StatefulWidget{
    const SearchResult ({Key? key}): super(key:key);

    @override
  State<SearchResult> createState() => _SearchResult();
}

class _SearchResult extends State<SearchResult>{
  get kText17SemiboldBlack => null;

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
                  toolbarHeight: 80,
                  automaticallyImplyLeading: false,
                  backgroundColor: cwColorBackground,
                  leading: Padding(
                    padding:  EdgeInsets.fromLTRB(10.w, 10.h, 0, 0),
                    child: IconButton(onPressed: () => {}, icon: const FaIcon(FontAwesomeIcons.angleLeft), color: cwColorBlack,),
                  ),
                  leadingWidth: 40,
                  title: SizedBox(
                    height: 50.h,
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(0, 10.h, 0, 0),
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
                            borderRadius: BorderRadius.circular(20),
                            color: cwColorWhite),
                      ),
                    ),
                  ),
                ),
              ];
            },
            body: SingleChildScrollView(
              child: Padding(
                padding:  EdgeInsets.fromLTRB(20.w, 0, 20.w, 10.h),
                child: Column(
                  children: [
                    ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: actives.length,
                        itemBuilder: (BuildContext context, int index) {
                          return SortInforComponent(id: "", imgUrl: actives[index]['img'], name: actives[index]['name']);
                        }),
                  ],
                ),
              ),
            ),
          ),
    );
  }

  
}