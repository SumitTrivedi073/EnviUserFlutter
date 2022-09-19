import 'package:envi/database/favoritesData.dart';
import 'package:envi/database/favoritesDataDao.dart';
import 'package:envi/theme/styles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../database/database.dart';
import '../../theme/color.dart';
import '../../theme/string.dart';
import '../../theme/theme.dart';
import '../../uiwidget/appbarInside.dart';
import '../../uiwidget/robotoTextWidget.dart';
import '../../web_service/Constant.dart';
import '../upcomingride/model/ScheduleTripModel.dart';
import 'addFavoritePage.dart';

class FavoritePlacesPage extends StatefulWidget {
  @override
  State<FavoritePlacesPage> createState() => _FavoritePlacesPageState();
}

class _FavoritePlacesPageState extends State<FavoritePlacesPage> {
  bool _isFirstLoadRunning = false;
  int pagecount = 1;
  late ScrollController _controller;
  bool _hasNextPage = true;
  bool _isLoadMoreRunning = false;
  int _limit = 20;

  List<FavoritesData> arraddress = [];
  late final FavoritesDataDao dao;
  late final FavoritesData? homeDetail;
  late final FavoritesData? workDetail;
  @override
  void initState() {
    super.initState();
    loadData();

    // _controller = new ScrollController()..addListener(_loadMore);
  }

  Future<void> loadData() async {
    final database =
        await $FloorFlutterDatabase.databaseBuilder('envi_user.db').build();
    dao = database.taskDao;
    homeDetail = await dao.findTaskByTitle("Home");
    workDetail = await dao.findTaskByTitle("Work");
    List<FavoritesData> temparr = await dao.getFavoriate();
    setState(() {
      arraddress = temparr;
    });
    //findTaskByidentifier("5bf57942-b1be-4df2-a9a9-1e588bf8e1dd");
    print("==========${arraddress}");
  }

  @override
  void dispose() {
    // _controller.removeListener(_loadMore);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(PageBackgroundImage),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          children: [
            AppBarInsideWidget(
              title: TitelFavoritePlaces,
            ),

            presetplace(),

            Expanded(
              child: _isFirstLoadRunning
                  ? Center(
                      child: CircularProgressIndicator(),
                    )
                  : Container(
                      margin: const EdgeInsets.only(right: 10.0),
                      child: _buildPosts(context)),
            ),
            Container(
                width: 200,
                height: 40.0,
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                margin: const EdgeInsets.only(top: 30.0, bottom: 50),
                child: Center(
                  child: MaterialButton(
                    color: AppColor.butgreen,
                    height: 40,
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => AddEditFavoritePlacesPage(
                                  isforedit: "1",
                                  titleEditable: "0",
                                  data: null)));
                    },
                    child: Row(children: [
                      SvgPicture.asset(
                        "assets/svg/add-place-plus.svg",
                        width: 22,
                        height: 24,
                        color: AppColor.white,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      robotoTextWidget(
                          textval: ADDPLACE,
                          colorval: AppColor.white,
                          sizeval: 16.0,
                          fontWeight: FontWeight.bold),
                    ]),
                  ),
                )),
            if (_isLoadMoreRunning == true)
              Padding(
                padding: const EdgeInsets.only(top: 10, bottom: 40),
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              ),
            // When nothing else to load
            if (_hasNextPage == false)
              Container(
                padding: const EdgeInsets.only(top: 30, bottom: 40),
                color: Colors.green,
                child: Center(
                  child: Text(
                    'You have fetched all of the content',
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  InkWell _buildPosts(BuildContext context) {
    return InkWell(
        onTap: () {
          //onSelectTripDetailPage(context);
        },
        child: ListView.separated(
          itemBuilder: (context, index) {
            return ListItem(index);
          },
          itemCount: arraddress.length,
          padding: const EdgeInsets.all(8),
          separatorBuilder: (context, index) {
            return const Divider(
              thickness: 0.5,
              indent: 20,
              endIndent: 20,
              color: Colors.transparent,
            );
          },
        ));
  }

  Column ListItem(int index) {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const SizedBox(
            height: 20,
          ),

          //CellRow2(index),
          GestureDetector(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => AddEditFavoritePlacesPage(
                            isforedit: "0",
                            titleEditable: "0",
                            data: arraddress[index],
                          )));
              print("Tapped a Container");
            },
            child: CellRow1(index),
          ),
          const SizedBox(
            height: 20,
          ),
          Container(
            height: 1,
            color: AppColor.border,
          ),
        ]);
  }

  Container CellRow1(int index) {
    return Container(
        color: AppColor.white.withOpacity(0.1),
        padding: const EdgeInsets.only(left: 18, right: 18),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(children: [
                  SvgPicture.asset(
                    "assets/svg/place-custom.svg",
                    width: 22,
                    height: 24,
                    color: AppColor.darkGreen,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  robotoTextWidget(
                    textval: arraddress[index].title,
                    colorval: AppColor.black,
                    sizeval: 14.0,
                    fontWeight: FontWeight.bold,
                  ),
                ]),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(children: [
                  const SizedBox(
                    width: 22,
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width - 98,
                    child: robotoTextWidget(
                      textval: arraddress[index].address,
                      colorval: AppColor.darkgrey,
                      sizeval: 14.0,
                      fontWeight: FontWeight.normal,
                    ),
                  )
                ]),
              ],
            ),
          ],
        ));
  }

  Container presetplace() {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 22,
          ),
          Row(children: [
            const SizedBox(
              width: 22,
            ),
            robotoTextWidget(
              textval: presetplacetext,
              colorval: AppColor.grey,
              sizeval: 14.0,
              fontWeight: FontWeight.normal,
            ),
          ]),
          const SizedBox(
            height: 5,
          ),
          Container(
            height: 1,
            color: AppColor.border,
          ),
          const SizedBox(
            height: 20,
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => AddEditFavoritePlacesPage(
                            isforedit: "0",
                            titleEditable: "1",
                            data: homeDetail == null
                                ? FavoritesData.optional(
                                    title: "Home",
                                    address: "",
                                    longitude: "0.0",
                                    latitude: " 0.0",
                                  )
                                : homeDetail!,
                          )));
              print("Tapped a Container");
            },
            child: Container(
                color: AppColor.white.withOpacity(0.1),
                padding: const EdgeInsets.only(left: 20, right: 20),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(children: [
                          SvgPicture.asset(
                            "assets/svg/place-home.svg",
                            width: 22,
                            height: 24,
                            color: AppColor.darkGreen,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          robotoTextWidget(
                            textval: hometext,
                            colorval: AppColor.black,
                            sizeval: 14.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ]),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(children: [
                          SizedBox(
                            width: 42,
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width - 98,
                            child: robotoTextWidget(
                              textval:
                                  homeDetail == null ? "" : homeDetail!.address,
                              colorval: AppColor.darkgrey,
                              sizeval: 14.0,
                              fontWeight: FontWeight.normal,
                            ),
                          )
                        ]),
                      ],
                    ),
                  ],
                )),
          ),
          const SizedBox(
            height: 20,
          ),
          Container(
            height: 1,
            color: AppColor.border,
          ),
          const SizedBox(
            height: 20,
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => AddEditFavoritePlacesPage(
                            isforedit: "0",
                            titleEditable: "1",
                            data: homeDetail == null
                                ? FavoritesData.optional(
                                    title: "Work",
                                    address: "",
                                    longitude: "0.0",
                                    latitude: " 0.0",
                                  )
                                : homeDetail!,
                          )));

              print("Tapped a Container");
            },
            child: Container(
                color: AppColor.white.withOpacity(0.1),
                padding: const EdgeInsets.only(left: 20, right: 20),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(children: [
                          SvgPicture.asset(
                            "assets/svg/place-work.svg",
                            width: 22,
                            height: 24,
                            color: AppColor.darkGreen,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          robotoTextWidget(
                            textval: worktext,
                            colorval: AppColor.black,
                            sizeval: 14.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ]),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(children: [
                          SizedBox(
                            width: 42,
                          ),
                          Container(
                              width: MediaQuery.of(context).size.width *
                                  (209 / 360),
                              child: Container(
                                width: MediaQuery.of(context).size.width - 98,
                                child: robotoTextWidget(
                                  textval: workDetail == null
                                      ? ""
                                      : workDetail!.address,
                                  colorval: AppColor.darkgrey,
                                  sizeval: 14.0,
                                  fontWeight: FontWeight.normal,
                                ),
                              )),

                          // robotoTextWidget(
                          //   textval: "arraddress[index].address",
                          //   colorval: AppColor.darkgrey,
                          //   sizeval: 14.0,
                          //   fontWeight: FontWeight.normal,
                          // ),
                        ]),
                      ],
                    ),
                  ],
                )),
          ),
          const SizedBox(
            height: 20,
          ),
          Container(
            height: 1,
            color: AppColor.border,
          ),
          const SizedBox(
            height: 22,
          ),
          Row(children: [
            const SizedBox(
              width: 22,
            ),
            robotoTextWidget(
              textval: customplacetext,
              colorval: AppColor.grey,
              sizeval: 14.0,
              fontWeight: FontWeight.normal,
            ),
          ]),
          const SizedBox(
            height: 5,
          ),
          Container(
            height: 1,
            color: AppColor.border,
          ),
        ],
      ),
    );
  }
}
