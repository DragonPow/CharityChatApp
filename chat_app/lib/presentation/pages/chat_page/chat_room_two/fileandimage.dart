import 'package:chat_app/configs/colorconfig.dart';
import 'package:chat_app/configs/fontconfig.dart';
import 'package:chat_app/presentation/bloc/message_setting/message_setting_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class FileAndImage extends StatefulWidget {
  const FileAndImage({Key? key}) : super(key: key);

  @override
  State<FileAndImage> createState() => _FileAndImageState();
}

class _FileAndImageState extends State<FileAndImage>
    with TickerProviderStateMixin {
  late TabController _tabController;
  int indextab = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    BlocProvider.of<MessageSettingBloc>(context);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MessageSettingBloc, MessageSettingState>(
      builder: (context, state) {
        if (state is! MessageSettingImageState) {
          return const Text('fail');
        }
        return Scaffold(
          backgroundColor: cwColorWhite,
          appBar: getAppBar(),
          body: NestedScrollView(
            floatHeaderSlivers: true,
            headerSliverBuilder: (context, value) {
              return [
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
                      Tab(text: "Hình ảnh "),
                      Tab(text: "File"),
                    ],
                    onTap: (index) {
                      setState(() {
                        indextab = index;
                      });
                    },
                  ),
                ),
              ];
            },
            body: indextab == 0 ? getImageGrid() : getFiles(),
          ),
        );
      },
    );
  }

  Widget getFiles() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Icon(
          FontAwesomeIcons.folderOpen,
          color: cwColorGreyNoteText,
          size: 160,
        ),
        const SizedBox(
          height: 20,
        ),
        Text(
          "File trống!",
          style: kText15RegularGreyNotetext,
        )
      ],
    );
  }

  GridView getImageGrid() {
    return GridView.count(
      primary: false,
      padding: const EdgeInsets.all(20),
      crossAxisSpacing: 10,
      mainAxisSpacing: 10,
      crossAxisCount: 2,
      children: <Widget>[
        InkWell(
          child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                image: const DecorationImage(
                    image: NetworkImage(
                        "https://media.istockphoto.com/photos/beautiful-sence-of-brooklyn-bridge-and-lower-manhattan-of-new-york-picture-id1169075524?b=1&k=20&m=1169075524&s=170667a&w=0&h=vo2f3bLYMR1JfYDJwIx5QL1r1xuvEX3sz6vd-o8aIxQ="),
                    fit: BoxFit.cover)),
          ),
          onTap: () => {},
        ),
        Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              image: const DecorationImage(
                  image: NetworkImage(
                      "https://media.istockphoto.com/photos/hong-kong-island-with-sunset-and-dusk-background-landscape-and-blue-picture-id1171336156?b=1&k=20&m=1171336156&s=170667a&w=0&h=G86fds9QZLtoWFxjfigPrLmrknYatwTk8EHBLXAv-XQ="),
                  fit: BoxFit.cover)),
        ),
        Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              image: const DecorationImage(
                  image: NetworkImage(
                      "https://media.istockphoto.com/photos/modern-luxury-restaurant-interior-with-romantic-sence-eiffel-tower-picture-id910903262?b=1&k=20&m=910903262&s=170667a&w=0&h=02-UM9NqEnWe45UdJIke-ziUi4eut3EXz0mg_QvifUc="),
                  fit: BoxFit.cover)),
        ),
        Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              image: const DecorationImage(
                  image: NetworkImage(
                      "https://media.istockphoto.com/photos/nice-sence-of-forest-mountain-picture-id646914058?b=1&k=20&m=646914058&s=170667a&w=0&h=IoWRsuWA6p6zGU0FLJ53Qidr1yVrHZ93sKBkRTWaWaA="),
                  fit: BoxFit.cover)),
        ),
        Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              image: const DecorationImage(
                  image: NetworkImage(
                      "https://media.istockphoto.com/photos/country-road-picture-id467019821?b=1&k=20&m=467019821&s=170667a&w=0&h=PEOIOTd_VRsHrAM-BUwXJMIAyKDKHaNKspWza4pxDfo="),
                  fit: BoxFit.cover)),
        ),
        Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              image: const DecorationImage(
                  image: NetworkImage(
                      "https://media.istockphoto.com/photos/girl-smelling-a-rose-picture-id172169200?b=1&k=20&m=172169200&s=170667a&w=0&h=k8t57Jy-MCdKsJqa04QhxrTU7N53_TstHnEDEEZW22M="),
                  fit: BoxFit.cover)),
        ),
      ],
    );
  }

  AppBar getAppBar() {
    return AppBar(
      iconTheme: const IconThemeData(color: cwColorBlackIcon),
      backgroundColor: cwColorBackground,
      centerTitle: true,
      elevation: 0,
      toolbarHeight: 70.h,
      title: Text("File và hình ảnh ", style: kText20MediumBlack),
    );
  }
}
