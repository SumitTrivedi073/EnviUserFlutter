import 'dart:convert';

import 'package:envi/theme/color.dart';
import 'package:envi/uiwidget/appbarInside.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../appConfig/Profiledata.dart';
import '../../appConfig/landingPageSettings.dart';
import '../../theme/string.dart';
import '../../theme/theme.dart';
import '../../uiwidget/robotoTextWidget.dart';
import '../../web_service/APIDirectory.dart';
import '../../web_service/Constant.dart';

import 'dart:convert' as convert;
import '../../../../web_service/HTTP.dart' as HTTP;
import '../onRide/model/SosModel.dart';
import 'model/rideHistoryModel.dart';

class RideHistoryPage extends StatefulWidget {
  @override
  State<RideHistoryPage> createState() => _RideHistoryPageState();
}

class _RideHistoryPageState extends State<RideHistoryPage> {
  bool _isFirstLoadRunning = false;
  int pagecount = 1;
  late ScrollController _controller;
  bool _hasNextPage = true;
  bool _isLoadMoreRunning = false;
  int _limit = 20;
  late dynamic userId;
  List<RideHistoryModel> arrtrip = [];
  @override
  void initState() {
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


    userId = Profiledata().getusreid();

    dynamic res = await HTTP.get(getUserTripHistory(userId, pagecount, _limit));
    print(res.body);
    if (res!=null && res.statusCode != null && res.statusCode == 200) {
      setState(() {
        if(jsonDecode(res.body)['content']['result'] !=null) {
          arrtrip = (jsonDecode(res.body)['content']['result'] as List)
              .map((i) => RideHistoryModel.fromJson(i))
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
        final List<RideHistoryModel> fetchedPosts =
            (jsonDecode(res.body)['content']['result'] as List)
                .map((i) => RideHistoryModel.fromJson(i))
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
              title: TitelRideHistory,
              isBackButtonNeeded: true,
            ),
            totalTripHeader(),

            Expanded(
              child: _isFirstLoadRunning
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : Container(
                      margin: const EdgeInsets.only(right: 10.0),
                      child: _buildPosts(context)),
            ),
            // when the _loadMore function is running
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
        child: ListView.builder(
          controller: _controller,
          itemBuilder: (context, index) {
            return ListItem(index);
          },
          itemCount: arrtrip.length,
          padding: const EdgeInsets.all(8),
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
              CellRow2(index),
              CellRow3(index),
            ]));
  }

  Container CellRow1(int index) {
    return Container(
      color: AppColor.cellheader,
      height: 38,
      padding: const EdgeInsets.only(top: 10, bottom: 10, left: 15, right: 15),
      foregroundDecoration: BoxDecoration(
          borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(10), topRight: Radius.circular(10)),
          border: Border.all(color: AppColor.border, width: 1.0)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(children: [
            const Icon(
              Icons.nights_stay_sharp,
              color: AppColor.black,
            ),
            robotoTextWidget(
              textval:
                  "${getdayTodayTomarrowYesterday(arrtrip[index].start_time)}",
              colorval: AppColor.black,
              sizeval: 15.0,
              fontWeight: FontWeight.bold,
            ),
          ]),
          robotoTextWidget(
            textval: "₹ ${arrtrip[index].price.totalFare}",
            colorval: AppColor.black,
            sizeval: 18.0,
            fontWeight: FontWeight.bold,
          ),
        ],
      ),
    );
  }

  Container CellRow2(int index) {
    var driverImage = Uri.encodeFull(arrtrip[index].driverPhoto);

    return Container(
      color: AppColor.white,
      height: 94,
      padding: const EdgeInsets.only(top: 10, bottom: 10, left: 15, right: 15),
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
                    children: [
                      const Icon(
                        Icons.star,
                        color: AppColor.butgreen,
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      robotoTextWidget(
                        textval: arrtrip[index].toAddress.length > 30
                            ? arrtrip[index].toAddress.substring(0, 30)
                            : arrtrip[index].toAddress,
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
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(left: 25),
                      ),
                      robotoTextWidget(
                        textval: arrtrip[index].fromAddress.length > 30
                            ? arrtrip[index].fromAddress.substring(0, 30)
                            : arrtrip[index].fromAddress,
                        colorval: AppColor.greyblack,
                        sizeval: 14.0,
                        fontWeight: FontWeight.normal,
                      ),
                    ],
                  ),
                ],
              ),
              Image.network(
                driverImage,
                fit: BoxFit.fill,
                height: 40,
                width: 40,
              ),
            ],
          ),
          const SizedBox(
            height: 7,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(children: [
                const Padding(
                  padding: EdgeInsets.only(left: 25),
                ),
                robotoTextWidget(
                  textval: "${arrtrip[index].distance} Km",
                  colorval: AppColor.darkgrey,
                  sizeval: 13.0,
                  fontWeight: FontWeight.w800,
                ),
              ]),
              robotoTextWidget(
                textval: arrtrip[index].vehicle.Vnumber,
                colorval: AppColor.darkgrey,
                sizeval: 13.0,
                fontWeight: FontWeight.bold,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Container CellRow3(int index) {
    return Container(
      color: AppColor.white,
      height: 38,
      padding: const EdgeInsets.only(top: 10, bottom: 10, left: 15, right: 15),
      foregroundDecoration: BoxDecoration(
          borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(10),
              bottomRight: Radius.circular(10)),
          border: Border.all(color: AppColor.border, width: 1.0)),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
        Align(
          alignment: Alignment.center,
          child: MaterialButton(
            child: robotoTextWidget(
              textval: Invoice,
              colorval: AppColor.butgreen,
              sizeval: 14.0,
              fontWeight: FontWeight.bold,
            ),
            onPressed: () {
              sendInvoice(arrtrip[index].passengerTripMasterId);
            },
          ),
        ),
        Container(
          width: 1,
          color: AppColor.border,
        ),
        MaterialButton(
          child: robotoTextWidget(
            textval: Support,
            colorval: AppColor.butgreen,
            sizeval: 14.0,
            fontWeight: FontWeight.bold,
          ),
          onPressed: () {
            makingPhoneCall(LandingPageConfig().getcustomerCare() != null
                ? LandingPageConfig().getcustomerCare()
                : '');
          },
        ),
      ]),
    );
  }

  Card totalTripHeader() {
    return Card(
      elevation: 5,
      semanticContainer: true,
      clipBehavior: Clip.antiAliasWithSaveLayer,
      color: AppColor.detailheader,
      child: Container(
        color: AppColor.detailheader,
        height: 56,
        margin: const EdgeInsets.only(left: 5, right: 5),
        padding: const EdgeInsets.only(top: 9, bottom: 5, right: 5),
        foregroundDecoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(15)),
        ),
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(
                  child: Column(
                children: const [
                  RotatedBox(
                    quarterTurns: 3,
                    child: robotoTextWidget(
                      textval: "YOUR\nSTATS",
                      colorval: AppColor.greyblack,
                      sizeval: 13.0,
                      fontWeight: FontWeight.w800,
                    ),
                  )
                ],
              )),
              Expanded(
                  flex: 2,
                  child: Column(
                    children: const [
                      robotoTextWidget(
                        textval: "22",
                        colorval: AppColor.white,
                        sizeval: 22.0,
                        fontWeight: FontWeight.bold,
                      ),
                      robotoTextWidget(
                        textval: "Rides Taken",
                        colorval: AppColor.lightwhite,
                        sizeval: 13.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ],
                  )),
              Expanded(
                  flex: 2,
                  child: Column(
                    children: const [
                      robotoTextWidget(
                        textval: "175 Kg",
                        colorval: AppColor.white,
                        sizeval: 22.0,
                        fontWeight: FontWeight.bold,
                      ),
                      robotoTextWidget(
                        textval: "CO2 Emission Prevented",
                        colorval: AppColor.lightwhite,
                        sizeval: 13.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ],
                  )),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> makingPhoneCall(String phone) async {
    var url = Uri.parse("tel:$phone");
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  Future<void> sendInvoice(String passengerTripMasterId) async {
    Map data;
    data = {
      "mailid": Profiledata().getmailid(),
      "passengerTripMasterId":passengerTripMasterId

    };
    print("data=======>$data");
    var jsonData = null;
    dynamic res = await HTTP.post(SendInvoice(), data);
    if (res != null && res.statusCode != null && res.statusCode == 200) {
      setState(() {
        jsonData = convert.jsonDecode(res.body);
        print("jsonData=======>$jsonData");
        SosModel sosModel = SosModel.fromJson(jsonData);
        showSnackbar(context, sosModel.message);
      });
    } else {
      throw "Driver Not Booked";
    }
  }
}
