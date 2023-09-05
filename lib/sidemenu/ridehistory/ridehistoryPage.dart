import 'dart:convert';
import 'dart:convert' as convert;
import 'package:envi/theme/color.dart';
import 'package:envi/uiwidget/appbarInside.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../web_service/HTTP.dart' as HTTP;
import '../../appConfig/Profiledata.dart';
import '../../appConfig/landingPageSettings.dart';
import '../../theme/images.dart';
import '../../theme/string.dart';
import '../../theme/theme.dart';
import '../../uiwidget/robotoTextWidget.dart';
import '../../utils/utility.dart';
import '../../web_service/APIDirectory.dart';
import '../../web_service/Constant.dart';
import '../onRide/model/SosModel.dart';
import 'model/rideHistoryModel.dart';

class CarbonProfile {
  late double totalLifeTimeKMs;
  late double totalLifeTimeTrips;
  late String carbonSaved;
}

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

  dynamic carbonProfile;

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

  
  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }


  void _firstLoad() async {
    if (mounted) {
      setState(() {
        _isFirstLoadRunning = true;
      });
    }
    userId = Profiledata().getusreid();

    dynamic res = await HTTP.get(getUserTripHistory(userId, pagecount, _limit));
    if (res != null && res.statusCode != null && res.statusCode == 200) {
      {
        setState(() {
          _isFirstLoadRunning = false;
          if (jsonDecode(res.body)['content']['result'] != null) {
            carbonProfile = jsonDecode(res.body)['content']['carbonProfile'];
            arrtrip = (jsonDecode(res.body)['content']['result'] as List)
                .map((i) => RideHistoryModel.fromJson(i))
                .toList();
            if (arrtrip.length > 0) {
              if (arrtrip.length != _limit) {
                _hasNextPage = false;
                _isFirstLoadRunning = false;
              }
            }
          }
        });
      }
    } else {
      if (mounted) {
        setState(() {
          _isFirstLoadRunning = false;
        });
      }
    }
  }

  void _loadMore() async {
    if (_hasNextPage == true &&
        _isFirstLoadRunning == false &&
        _isLoadMoreRunning == false &&
        _controller.position.extentAfter < 300) {
      if (mounted) {
      setState(() {
        _isLoadMoreRunning = true;
      });
      }
      pagecount += 1;
      dynamic res =
          await HTTP.get(getUserTripHistory(userId, pagecount, _limit));

      if (res.statusCode == 200) {
        final List<RideHistoryModel> fetchedPosts =
            (jsonDecode(res.body)['content']['result'] as List)
                .map((i) => RideHistoryModel.fromJson(i))
                .toList();
        if (fetchedPosts.length > 0) {
          if (mounted) {
            setState(() {
              if (fetchedPosts.length != _limit) {
                _hasNextPage = false;
                _isLoadMoreRunning = false;
              }
              arrtrip.addAll(fetchedPosts);
            });
          }
        } else {
          // This means there is no more data
          // and therefore, we will not send another GET request
          if (mounted) {
            setState(() {
              _hasNextPage = false;
              _isLoadMoreRunning = false;
            });
          }
        }
      } else {
        if (mounted) {
          setState(() {
            _isLoadMoreRunning = false;
          });
        }
      }
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
              pagetitle: TitelRideHistory,
              isBackButtonNeeded: true,
            ),
            totalTripHeader(),

            Expanded(
              child: _isFirstLoadRunning
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : Container(
                      margin: const EdgeInsets.only(right: 5.0),
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

  Widget _buildPosts(BuildContext context) {
    if (arrtrip.isEmpty) {
      return const Center(child: robotoTextWidget(textval: "No trips data available",colorval: AppColor.black,
        sizeval: 14,fontWeight: FontWeight.w600,));
    }
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
            arrtrip[index].start_time!=null && arrtrip[index].start_time!="NA"? robotoTextWidget(
              textval:
                  "${getdayTodayTomarrowYesterday(arrtrip[index].start_time)}",
              colorval: AppColor.black,
              sizeval: 15.0,
              fontWeight: FontWeight.bold,
            ):Container(),
          ]),
          arrtrip[index].price.totalFare!=null &&  arrtrip[index].price.totalFare != 'NA'
              ? robotoTextWidget(
                  textval: "₹ ${arrtrip[index].price.totalFare}",
                  colorval: AppColor.black,
                  sizeval: 18.0,
                  fontWeight: FontWeight.bold,
                )
              : robotoTextWidget(
                  textval: arrtrip[index].status.toTitleCase(),
                  colorval: AppColor.black,
                  sizeval: 18.0,
                  fontWeight: FontWeight.bold,
                ),
        ],
      ),
    );
  }

  Container CellRow2(int index) {
    return Container(
      color: AppColor.white,
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
                      Icon(
                        Icons.location_on,
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width -100,
                        child: robotoTextWidget(
                          textval: arrtrip[index].toAddress,
                          colorval: AppColor.black,
                          sizeval: 14.0,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 3,
                  ),
                  Row(
                    children: [
                      Icon(
                        Icons.location_on,
                        color: Colors.red,
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width - 100,
                        child: robotoTextWidget(
                          textval: arrtrip[index].fromAddress,
                          colorval: AppColor.greyblack,
                          sizeval: 14.0,
                          fontWeight: FontWeight.w600,
                        ),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 3,
                  ),
                       Row(
                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                         children: [
                           ClipRRect(
                               borderRadius: BorderRadius.circular(50.0),
                               child: Image.network(
                                 encodeImgURLString(arrtrip[index].driverPhoto),
                                 errorBuilder: (context, error, stackTrace) {
                                   return Image.asset(
                                     Images.personPlaceHolderImage,
                                     height: 40,
                                     width: 40,
                                   );
                                 },
                                 fit: BoxFit.fill,
                                 height: 40,
                                 width: 40,
                               )),
                           SizedBox(width:5),
                           robotoTextWidget(
                             textval: arrtrip[index].name.toTitleCase(),
                             colorval: AppColor.darkgrey,
                             sizeval: 14.0,
                             fontWeight: FontWeight.w600,
                           ),
                         ],
                       ),

                ],
              ),

            ],
          ),
          const SizedBox(
            height: 5,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(children: [

                arrtrip[index].distance != 'NA'
                    ? robotoTextWidget(
                        textval: "Distance: ${arrtrip[index].distance} Km",
                        colorval: AppColor.darkgrey,
                        sizeval: 13.0,
                        fontWeight: FontWeight.w600,
                      )
                    : robotoTextWidget(
                  textval: 'Vehicle No: ${arrtrip[index].vehicle.Vnumber}',
                  colorval: AppColor.darkgrey,
                  sizeval: 12.0,
                  fontWeight: FontWeight.bold,
                ),
              ]),
              arrtrip[index].distance != 'NA'
                  ?   robotoTextWidget(
                textval: 'Vehicle Number: ${arrtrip[index].vehicle.Vnumber.toUpperCase()}',
                colorval: AppColor.darkgrey,
                sizeval: 12.0,
                fontWeight: FontWeight.w600,
              ):Container(),
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
      child: getFoooterView(index),
    );
  }

  Container totalTripHeader() {
    return Container(
      margin: EdgeInsets.only(left: 10,right: 10),
      child: Card(
        elevation: 5,
        semanticContainer: true,
        clipBehavior: Clip.antiAliasWithSaveLayer,
        color: AppColor.detailheader,
        child: Container(
          color: AppColor.detailheader,
          // height: 66,
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
                            colorval: AppColor.white,
                            sizeval: 13.0,
                            fontWeight: FontWeight.w800,
                          ),
                        )
                      ],
                    )),
                Expanded(
                    flex: 2,
                    child: Column(
                      children: [
                        robotoTextWidget(
                          textval: (carbonProfile != null)
                              ? " ${carbonProfile['totalLifeTimeTrips']}"
                              : '--', //Change here
                          colorval: AppColor.white,
                          sizeval: 20.0,
                          fontWeight: FontWeight.bold,
                        ),
                        const robotoTextWidget(
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
                      children: [
                        robotoTextWidget(
                          textval: (carbonProfile != null)
                              ? "${carbonProfile['carbonSaved']}"
                              : '--', //Change Here
                          colorval: AppColor.white,
                          sizeval: 20.0,
                          fontWeight: FontWeight.bold,
                        ),
                        const robotoTextWidget(
                          textval: "CO2 Emission Prevented",
                          colorval: AppColor.lightwhite,
                          sizeval: 10.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ],
                    )),
              ],
            ),
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
      "passengerTripMasterId": passengerTripMasterId
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

 Widget getFoooterView(int index) {
    if(arrtrip[index].status == RideHistoryCancelledStatus){
    return  SizedBox(
        width: MediaQuery.of(context).size.width,
        child: MaterialButton(
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
      );
    }
    else if(arrtrip[index].status == RideHistoryRejectedStatus){
      return  SizedBox(
        width: MediaQuery.of(context).size.width,
        child: MaterialButton(
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
      );
    }
    else{
      return  Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
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
      ]);
    }
  }
}
