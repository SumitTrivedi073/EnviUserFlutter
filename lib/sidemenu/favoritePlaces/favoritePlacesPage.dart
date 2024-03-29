import 'package:envi/database/favoritesData.dart';
import 'package:envi/database/favoritesDataDao.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_svg/svg.dart';

import '../../database/database.dart';
import '../../theme/color.dart';
import '../../theme/string.dart';
import '../../uiwidget/appbarInside.dart';
import '../../uiwidget/robotoTextWidget.dart';
import '../../web_service/Constant.dart';
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
  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  List<FavoritesData> arraddress = [];
  late final FavoritesDataDao dao;
  FavoritesData? homeDetail = null;
  FavoritesData? workDetail = null;
  @override
  void initState() {
    super.initState();

    loadData();
    // _controller = new ScrollController()..addListener(_loadMore);
  }

  getTrimmedAddress(String val) {
    final split = val.split(',');
    final Map<int, String> values = {
      for (int i = 0; i < split.length; i++) i: split[i]
    };
    final value1 = values[0];
    final value2 = values[1] ?? '';
    return (values.length != 1) ? '$value1,$value2' : '$value1';
  }

  Future<void> getdata() async {
    List<FavoritesData> temparr = await dao.getFavoriate();
    homeDetail = await dao.findTaskByTitle("Home");
    workDetail = await dao.findTaskByTitle("Work");
    setState(() {
      arraddress = temparr;
    });
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
  }

  void comebackFromADD(String a) {}
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
              pagetitle: TitelFavoritePlaces,
              isBackButtonNeeded: true,
            ),

            presetplace(),

            Expanded(
              child: _isFirstLoadRunning
                  ? const Center(
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
                    onPressed: () async {
                      var come = await Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const AddEditFavoritePlacesPage(
                                    isforedit: "1",
                                    titleEditable: "0",
                                    data: null,
                                  )));
                     await getdata();
                    },
                    child: Row(children: [
                      SvgPicture.asset(
                        "assets/svg/add-place-plus.svg",
                        width: 20,
                        height: 20,
                        theme:  const SvgTheme(currentColor: AppColor.white,fontSize: 12.0, xHeight: 20),
                      ),
                      const SizedBox(
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
              const Padding(
                padding: EdgeInsets.only(top: 10, bottom: 40),
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              ),
            // When nothing else to load
            if (_hasNextPage == false)
              Container(
                padding: const EdgeInsets.only(top: 30, bottom: 40),
                color: Colors.green,
                child: const Center(
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
          GestureDetector(
            onTap: () async {
               Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => AddEditFavoritePlacesPage(
                            isforedit: "0",
                            titleEditable: "0",
                            data: arraddress[index],
                          )));
              getdata();
            },
            child: CellRow1(index),
          ),
          const SizedBox(
            height: 5,
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
        padding: const EdgeInsets.only(left: 10, right: 15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(children: [
                  const Icon(
                    Icons.person_outline,
                    size: 30,
                    color: AppColor.darkGreen,
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  robotoTextWidget(
                    textval: getTrimmedAddress(arraddress[index].title),
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
                    width: 35,
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width - 98,
                    child: robotoTextWidget(
                      textval: arraddress[index].address,
                      colorval: AppColor.darkgrey,
                      sizeval: 12.0,
                      fontWeight: FontWeight.normal,
                    ),
                  )
                ]),
              ],
            ),
          ],
        ));
  }

  Column presetplace() {
    return Column(
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
            fontWeight: FontWeight.w600,
          ),
        ]),
        const SizedBox(
          height: 10,
        ),
        Container(
          height: 1,
          color: AppColor.border,
        ),
        const SizedBox(
          height: 10,
        ),
        GestureDetector(
          onTap: () async {
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
                                  identifier: "0")
                              : homeDetail!,
                        )));
            getdata();
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
                          'assets/svg/place-home.svg',
                          height: 20,
                          width: 20,
                        ),
                        const SizedBox(
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
                        const SizedBox(
                          width: 42,
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width - 98,
                          child: robotoTextWidget(
                            textval:
                                homeDetail == null ? "" : homeDetail!.address,
                            colorval: AppColor.darkgrey,
                            sizeval: 12.0,
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
          height: 10,
        ),
        Container(
          height: 1,
          color: AppColor.border,
        ),
        const SizedBox(
          height: 10,
        ),
        GestureDetector(
          onTap: () async {
           await Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => AddEditFavoritePlacesPage(
                          isforedit: "0",
                          titleEditable: "1",
                          data: workDetail == null
                              ? FavoritesData.optional(
                                  title: "Work",
                                  address: "",
                                  longitude: "0.0",
                                  latitude: " 0.0",
                                  identifier: "0")
                              : workDetail!,
                        )));
            getdata();
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
                          'assets/svg/place-work.svg',
                          height: 20,
                          width: 20,
                        ),
                        const SizedBox(
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
                        const SizedBox(
                          width: 42,
                        ),
                        SizedBox(
                            width: MediaQuery.of(context).size.width *
                                (209 / 360),
                            child: SizedBox(
                              width: MediaQuery.of(context).size.width - 98,
                              child: robotoTextWidget(
                                textval: workDetail == null
                                    ? ""
                                    : workDetail!.address,
                                colorval: AppColor.darkgrey,
                                sizeval: 12.0,
                                fontWeight: FontWeight.normal,
                              ),
                            )),
                      ]),
                    ],
                  ),
                ],
              )),
        ),
        const SizedBox(
          height: 10,
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
            fontWeight: FontWeight.w600,
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
    );
  }
}
