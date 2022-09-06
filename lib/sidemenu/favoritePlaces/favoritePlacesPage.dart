import 'package:envi/database/favoritesData.dart';
import 'package:envi/database/favoritesDataDao.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../database/database.dart';
import '../../theme/color.dart';
import '../../theme/string.dart';
import '../../theme/theme.dart';
import '../../uiwidget/appbarInside.dart';
import '../../uiwidget/robotoTextWidget.dart';
import '../../web_service/Constant.dart';
import '../upcomingride/model/ScheduleTripModel.dart';

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

  List<ScheduleTripModel> arrtrip = [];
  late final FavoritesDataDao dao;

  @override
  void initState()  {
    super.initState();
    loadData();


   // _controller = new ScrollController()..addListener(_loadMore);
  }
  Future<void> loadData() async {
    final database = await $FloorFlutterDatabase
        .databaseBuilder('envi_user.db')
        .build();
     dao = database.taskDao;
    var data =  await dao.getFavoriate() ;//findTaskByidentifier("5bf57942-b1be-4df2-a9a9-1e588bf8e1dd");
print("==========${data}");
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
              title: TitelUpcomingRides,
            ),
            robotoTextWidget(
              textval: "PRESET PLACES",
              colorval: AppColor.grey,
              sizeval: 14.0,
              fontWeight: FontWeight.normal,
            ),
            Expanded(
              child:_isFirstLoadRunning
                  ? Center(
                child: CircularProgressIndicator(),
              )
                  : Container(
                  margin: const EdgeInsets.only(right: 10.0),
                  child: _buildPosts(context)),
            ),
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
          itemCount: arrtrip.length,
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

  Card ListItem(int index) {
    return Card(
      elevation: 4,
      semanticContainer: true,
      clipBehavior: Clip.antiAliasWithSaveLayer,
      shape: const RoundedRectangleBorder(
        side: BorderSide(
          color: AppColor.border,
        ),
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            CellRow1(index),
            Container(
              height: 1,
              color: AppColor.border,
            ),
            CellRow2(index),
            Container(
              height: 1,
              color: AppColor.border,
            ),
            CellRow3(),
          ]),
    );
  }

  Container CellRow1(int index) {
    return Container(
      color: AppColor.alfaorange.withOpacity(.3),
      height: 38,
      padding: const EdgeInsets.only(top: 10, bottom: 10, left: 15, right: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(children:  [
            Icon(
              Icons.sunny,
              color: AppColor.black,
              size: 20.0,
            ),
            SizedBox(width: 10,),
            robotoTextWidget(
              textval: "${getdayTodayTomarrowYesterday(arrtrip[index].scheduledAt)}",
              colorval: AppColor.black,
              sizeval: 14.0,
              fontWeight: FontWeight.bold,
            ),
          ]),
          robotoTextWidget(
            textval: "₹ ~${arrtrip[index].estimatedPrice.toString()}",
            colorval: AppColor.black,
            sizeval: 14.0,
            fontWeight: FontWeight.bold,
          ),
        ],
      ),
    );
  }

  Container CellRow2(int index) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(PageBackgroundImage),
          fit: BoxFit.cover,
        ),
      ),
      child: Container(
        color: AppColor.alfaorange.withOpacity(0.1),
        height: 94,
        padding:
        const EdgeInsets.only(top: 10, bottom: 10, left: 15, right: 15),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children:  [
                        robotoTextWidget(
                          textval: arrtrip[index].toAddress.length > 30 ? arrtrip[index].toAddress.substring(0, 30) : arrtrip[index].toAddress,
                          colorval: AppColor.black,
                          sizeval: 14.0,
                          fontWeight: FontWeight.normal,
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 3,
                    ),
                    Row(
                      children:  [
                        robotoTextWidget(
                          textval: arrtrip[index].fromAddress.length > 30 ? arrtrip[index].fromAddress.substring(0, 30) : arrtrip[index].fromAddress,
                          colorval: AppColor.black,
                          sizeval: 14.0,
                          fontWeight: FontWeight.normal,
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(
              height: 7,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(children: const [
                  robotoTextWidget(
                    textval: "18 Kms",
                    colorval: AppColor.greyblack,
                    sizeval: 13.0,
                    fontWeight: FontWeight.bold,
                  ),
                ]),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Container CellRow3() {
    return Container(
      color: AppColor.white,
      height: 38,
      padding: const EdgeInsets.only(left: 15, right: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          MaterialButton(
            child: robotoTextWidget(
              textval: CancelBooking,
              colorval: Color(0xFFED0000),
              sizeval: 14.0,
              fontWeight: FontWeight.bold,
            ),
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}
