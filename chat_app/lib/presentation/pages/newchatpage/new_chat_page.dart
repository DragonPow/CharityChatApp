import 'package:chat_app/presentation/pages/chat_page/add_people/add_people.dart';
import 'package:chat_app/presentation/pages/newchatpage/sort_infor_component.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../configs/colorconfig.dart';
import '../../../configs/fontconfig.dart';
import '../../../dataexample/active_user.dart';

class NewChatPage extends StatefulWidget {
  const NewChatPage({Key? key}) : super(key: key);

  @override
  State<NewChatPage> createState() => _NewChatPage();
}

class _NewChatPage extends State<NewChatPage> {
  get kText17SemiboldBlack => null;

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
                                      builder: (context) => const AddPeople()),
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
              ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: actives.length,
                  itemBuilder: (BuildContext context, int index) {
                    return SortInforComponent(imgUrl: actives[index]["img"], name:actives[index]["name"]);
                  }),
            ],
          ),
        ),
      ),
    );
  }
}
