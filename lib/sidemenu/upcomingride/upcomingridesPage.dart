import 'dart:convert';

import 'package:envi/theme/color.dart';
import 'package:envi/uiwidget/appbarInside.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../theme/string.dart';
import '../../../uiwidget/robotoTextWidget.dart';
import '../../../web_service/Constant.dart';

import 'dart:convert' as convert;
import '../../../../web_service/HTTP.dart' as HTTP;
import '../../appConfig/Profiledata.dart';
import '../../theme/theme.dart';
import '../../utils/utility.dart';
import '../../web_service/APIDirectory.dart';
import '../../web_service/ApiCollection.dart';
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

    dynamic res = await HTTP.get(getUserTripHistory(userId, pagecount, _limit));
    if (res != null && res.statusCode != null && res.statusCode == 200)  {
      print(jsonDecode(res.body)['schedule_trip_list']);
      setState(() {

        if(jsonDecode(res.body)['schedule_trip_list'] !=null && jsonDecode(res.body)['schedule_trip_list'].toString().isNotEmpty) {

          arrtrip = (jsonDecode(res.body)['schedule_trip_list'] as List)
              .map((i) => ScheduleTripModel.fromJson(i))
              .toList();
        }
      });

    } else {
      setState(() {
        _isFirstLoadRunning = false;
      });
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
                  ? const Center(
                child: CircularProgressIndicator(),
              )
                  : Container(
                  child: _buildPosts(context)),
            ),
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

  Widget _buildPosts(BuildContext context) {
    if(arrtrip.length == 0 || arrtrip == null)return Center(child: Text("No trips data available"));
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
            arrtrip[index].status!=CancelledStatus? Container(
              height: 1,
              color: AppColor.border,
            ):Container(),
          arrtrip[index].status!=CancelledStatus?CellRow3(index):Container(),
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
            const Icon(
              Icons.sunny,
              color: AppColor.black,
              size: 20.0,
            ),
            const SizedBox(width: 10,),
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
                        SvgPicture.asset(
                        "assets/svg/from-location-img.svg",
                        width: 20,
                        height: 20,
                      ),
                        const SizedBox(
                          width: 5,
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width - 80,
                          child: robotoTextWidget(
                            textval: arrtrip[index].fromAddress,
                            colorval: AppColor.black,
                            sizeval: 16,
                            fontWeight: FontWeight.w200,
                          ),
                        ),
                       ],
                    ),
                    const SizedBox(
                      height: 3,
                    ),
                    Row(
                      children:  [
                        SvgPicture.asset(
                          "assets/svg/to-location-img.svg",
                          width: 20,
                          height: 20,
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width - 80,
                          child: robotoTextWidget(
                            textval: arrtrip[index].toAddress,
                            colorval: AppColor.black,
                            sizeval: 16,
                            fontWeight: FontWeight.w200,
                          ),
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(children:  [
                  robotoTextWidget(
                    textval: arrtrip[index].status,
                    colorval: AppColor.red,
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

  Container CellRow3(int index) {
    return Container(
      color: AppColor.white,
      height: 38,
      padding: const EdgeInsets.only(left: 15, right: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [

          MaterialButton(
            child: robotoTextWidget(
              textval: arrtrip[index].status == "cancelled"?"Already Cancelled":CancelBooking,
              colorval: Color(0xFFED0000),
              sizeval: 14.0,
              fontWeight: FontWeight.bold,
            ),
            onPressed: () {
              cancelBooking(arrtrip[index].passengerTripMasterId);
            },
          ),
        ],
      ),
    );
  }
  Future<void> cancelBooking(String passengerTripMasterId) async {

    final response = await ApiCollection.cancelSchedualeTrip(passengerTripMasterId);

    if (response != null) {
      print(jsonDecode(response.body));
      if (response.statusCode == 200) {
       _firstLoad();
      }
      showSnackbar(context,(jsonDecode(response.body)['msg'].toString()));
    }
  }
}
