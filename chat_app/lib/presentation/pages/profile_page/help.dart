import 'package:chat_app/configs/colorconfig.dart';
import 'package:chat_app/configs/fontconfig.dart';
import 'package:chat_app/dataexample/helpQA.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Item {
  Item({
    required this.expandedValue,
    required this.headerValue,
    this.isExpanded = false,
  });

  String expandedValue;
  String headerValue;
  bool isExpanded;
}

List<Item> generateItems(int numberOfItems) {
  return List<Item>.generate(numberOfItems, (int index) {
    return Item(
      headerValue: helpQA[index]["ask"],
      expandedValue: helpQA[index]["answer"],
    );
  });
}

class Help extends StatefulWidget {
  const Help({Key? key}) : super(key: key);

  @override
  State<Help> createState() => _HelpState();
}

class _HelpState extends State<Help> {
  final List<Item> _data = generateItems(helpQA.length);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            "Trung tâm trợ giúp",
            style: kText17BoldBlack,
          ),
          iconTheme:const IconThemeData(color: cwColorBlack),
          centerTitle: true,
          backgroundColor: cwColorBackground,
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding:EdgeInsets.only(top: 20.h),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding:  EdgeInsets.symmetric(horizontal: 10.w),
                  child: Text(
                    "Các câu hỏi thường gặp",
                    style: kText17BoldBlack,
                  ),
                ),
                SizedBox(
                  height: 15.h,
                ),
                ExpansionPanelList(
                  expansionCallback: (int index, bool isExpanded) {
                    setState(() {
                      _data[index].isExpanded = !isExpanded;
                    });
                  },
                  children: _data.map<ExpansionPanel>((Item item) {
                    return ExpansionPanel(
                      headerBuilder: (BuildContext context, bool isExpanded) {
                        return ListTile(
                          title: Text(item.headerValue, style: kText15RegularMain,),
                        );
                      },
                      body: ListTile(
                          title: Text(item.expandedValue),),
                      isExpanded: item.isExpanded,
                    );
                  }).toList(),
                ),
                SizedBox(height: 10.h,),
                Padding(
                  padding:  EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
                  child: Text(
                    "Thông tin chăm sóc khách hàng",
                    style: kText17BoldBlack)
                ),
                 Padding(
                  padding:  EdgeInsets.fromLTRB(10.w, 0, 0, 10.h),
                  child: Text(
                    "Địa chỉ: Tầng M, Tòa nhà Petroland, Số 12 Tân Trào, Phường Tân Phú, Quận 7, Thành phố Hồ Chí Minh",
                    style: kText15RegularBlack,
                  ),
                ),
                 Padding(
                  padding:  EdgeInsets.fromLTRB(10.w, 0, 0, 10.h),
                  child: Text(
                    "Hotline : 1900 5454 41 (1000 đ/phút)",
                    style: kText15RegularBlack,
                  ),
                ),
                 Padding(
                  padding:  EdgeInsets.fromLTRB(10.w, 0, 0, 10.h),
                  child: Text(
                    "Email : hotro@unicine.vn",
                    style: kText15RegularBlack,
                  ),
                ),
                 Padding(
                  padding:  EdgeInsets.fromLTRB(10.w, 0, 0, 10.h),
                  child: Text(
                    "Tổng đài :028.1001.1410- 028.1111.2222",
                    style: kText15RegularBlack,
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
