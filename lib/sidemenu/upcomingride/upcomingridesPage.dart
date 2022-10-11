import 'dart:convert';

import 'package:envi/theme/color.dart';
import 'package:envi/uiwidget/appbarInside.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../theme/string.dart';
import '../../../uiwidget/robotoTextWidget.dart';
import '../../../web_service/Constant.dart';

import 'dart:convert' as convert;
import '../../../../web_service/HTTP.dart' as HTTP;
import '../../appConfig/Profiledata.dart';
import '../../theme/theme.dart';
import '../../web_service/APIDirectory.dart';
import '../ridehistory/model/rideHistoryModel.dart';
import 'model/ScheduleTripModel.dart';
class UpcomingRidesPage extends StatefulWidget {
  @override
  State<UpcomingRidesPage> createState() => _UpcomingRidesPageState();
}

class _UpcomingRidesPageState extends State<UpcomingRidesPage> {
  bool _isFirstLoadRunning = false;
  int pagecount = 1;
  late ScrollController _controller;
  bool _hasNextPage = true;
  bool _isLoadMoreRunning = false;
  int _limit = 20;
  late dynamic userId;
  List<ScheduleTripModel> arrtrip = [];
  @override
  void initState()  {
    super.initState();


    _firstLoad();
    _controller = new ScrollController()..addListener(_loadMore);
  }
  @override
  void dispose() {
    _controller.removeListener(_loadMore);
    super.dispose();
  }
  void _firstLoad() async {
    setState(() {
      _isFirstLoadRunning = true;
    });


    userId = Profiledata().getusreid() ;
print(userId);
    dynamic res = await HTTP.get(getUserTripHistory(userId, pagecount, _limit));
    print(jsonDecode(res.body)['schedule_trip_list']);
    if (res.statusCode == 200) {
      setState(() {

        if(jsonDecode(res.body)['content']['schedule_trip_list'] !=null) {
          arrtrip = (jsonDecode(res.body)['schedule_trip_list'] as List)
              .map((i) => ScheduleTripModel.fromJson(i))
              .toList();
        }
      });

    } else {
      setState(() {
        _isFirstLoadRunning = false;
      });
      throw "Can't get subjects.";
    }
    setState(() {
      _isFirstLoadRunning = false;
    });
  }

  void _loadMore() async {
    if (_hasNextPage == true &&
        _isFirstLoadRunning == false &&
        _isLoadMoreRunning == false &&
        _controller.position.extentAfter < 300) {
      setState(() {
        _isLoadMoreRunning = true;
      });
      pagecount += 1;
      dynamic res =
      await HTTP.get(getUserTripHistory(userId, pagecount, _limit));

      if (res.statusCode == 200) {
        final List<ScheduleTripModel> fetchedPosts =
        (jsonDecode(res.body)['content']['schedule_trip_list'] as List)
            .map((i) => ScheduleTripModel.fromJson(i))
            .toList();
        if (fetchedPosts.length > 0) {
          setState(() {
            if (fetchedPosts.length != _limit) {
              _hasNextPage = false;
            }
            arrtrip.addAll(fetchedPosts);
          });
        } else {
          // This means there is no more data
          // and therefore, we will not send another GET request
          setState(() {
            _hasNextPage = false;
          });
        }
      } else {
        setState(() {
          _isLoadMoreRunning = false;
        });
        throw "Can't get subjects.";
      }
      setState(() {
        _isLoadMoreRunning = false;
      });
    }
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
              isBackButtonNeeded: true,
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
                Row(children:  [
                  robotoTextWidget(
                    textval: "${arrtrip[index].estimatedDistance} Kms",
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
