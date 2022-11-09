import 'dart:convert';

import 'package:carousel_slider/carousel_controller.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:envi/theme/color.dart';
import 'package:envi/uiwidget/robotoTextWidget.dart';
import 'package:envi/utils/utility.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../sidemenu/bookScheduleTrip/model/vehiclePriceClasses.dart';
import '../sidemenu/home/homePage.dart';
import '../sidemenu/pickupDropAddressSelection/model/searchPlaceModel.dart';
import '../theme/string.dart';
import '../web_service/ApiCollection.dart';

class CarCategoriesWidget extends StatefulWidget {
  final SearchPlaceModel? fromAddress;
  final SearchPlaceModel? toAddress;
  final void Function(vehiclePriceClassesModel) callback;
  final void Function(String) callback2;
  final String scheduledAt;

  const CarCategoriesWidget(
      {Key? key,
      this.toAddress,
      this.fromAddress,
      required this.callback,
      required this.callback2,
      required this.scheduledAt})
      : super(key: key);

  @override
  // TODO: implement createState
  State<StatefulWidget> createState() => _CarCategoriesWidgetState();
}

class _CarCategoriesWidgetState extends State<CarCategoriesWidget> {
  var listItemCount = 0;
  var distance;
  List<vehiclePriceClassesModel> vehiclePriceClasses = [];
  int? selectedIndex = 0;
  CarouselController carouselController = CarouselController();
  bool isLoading = false;
  bool isForwardArrowGreen = true;
  bool isBackArrowGreen = true;

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _firstLoad();
  }

  void _firstLoad() async {
    setState(() {
      isLoading = true;
    });
    final response = await ApiCollection.getScheduleEstimationdata(
        widget.fromAddress!.latLng.latitude,
        widget.fromAddress!.latLng.longitude,
        widget.toAddress!.latLng.latitude,
        widget.toAddress!.latLng.longitude,
        widget.scheduledAt);
    if (response != null && response.statusCode == 200) {
      setState(() {
        isLoading = false;
        vehiclePriceClasses = (jsonDecode(response.body)['content']
                ['vehiclePriceClasses'] as List)
            .map((i) => vehiclePriceClassesModel.fromJson(i))
            .toList();
        distance = jsonDecode(response.body)['content']['estimatedDistance'];
        widget.callback2(distance.toStringAsFixed(2));
        widget.callback(vehiclePriceClasses[0]);
      });
    } else {
      var errmsg = jsonDecode(response.body)['msg'];
      setState(() {
        isLoading = false;
      });
      showDialog(
        context: context,
        builder: (BuildContext context) => dialogueError(context, errmsg),
      );
    }
  }

  Widget dialogueError(BuildContext context, String msg) {
    return AlertDialog(
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10))),
      content: SizedBox(
          height: 100,
          child: Column(children: [
            Padding(
              padding: const EdgeInsets.only(top: 5),
              child: Text(
                appName,
                style: const TextStyle(
                    color: AppColor.butgreen,
                    fontFamily: 'Roboto',
                    fontWeight: FontWeight.w600,
                    fontSize: 14),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              msg,
              style: const TextStyle(
                  color: AppColor.black,
                  fontFamily: 'Roboto',
                  fontWeight: FontWeight.w200,
                  fontSize: 14),
            ),
            const SizedBox(
              height: 10,
            ),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    const HomePage(title: "title")),
                            (Route<dynamic> route) => false);
                      },
                      style: ElevatedButton.styleFrom(
                        primary: AppColor.greyblack,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12), // <-- Radius
                        ),
                      ),
                      child: const robotoTextWidget(
                        textval: "Ok",
                        colorval: AppColor.white,
                        sizeval: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            )
          ])),
    );
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return isLoading
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : Container(
            margin: const EdgeInsets.only(
              left: 10,
              right: 10,
            ),
            child: Card(
              elevation: 5,
              margin: const EdgeInsets.all(5),
              child: Column(
                children: [
                  SizedBox(
                    height: 40,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          child: robotoTextWidget(
                              textval:
                                  '${vehiclePriceClasses.length} Ride Option',
                              colorval: AppColor.black,
                              sizeval: 14,
                              fontWeight: FontWeight.w800),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    height: 1,
                    color: AppColor.grey,
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  CarouselSlider(
                    items: List.generate(vehiclePriceClasses.length,
                        (index) => driverListItems(index)),
                    carouselController: carouselController,
                    options: CarouselOptions(
                      enableInfiniteScroll: false,
                      scrollDirection: Axis.horizontal,
                      aspectRatio: 2.2,
                      enlargeCenterPage: false,
                      disableCenter: false,
                      viewportFraction: 0.85,
                      onPageChanged: (index, reason) {
                        selectedIndex = index;
                        setState(() {
                          if (selectedIndex == 0) {
                            isBackArrowGreen = false;
                          } else {
                            isBackArrowGreen = true;
                          }
                          if (selectedIndex == vehiclePriceClasses.length - 1) {
                            isForwardArrowGreen = false;
                          } else {
                            isForwardArrowGreen = true;
                          }
                        });
                      },
                      autoPlay: false,
                    ),
                  )
                ],
              ),
            ),
          );
  }

  Widget driverListItems(int index) {
    return
    Wrap(children: [GestureDetector(
      onTap: () {
        setState(() {
          selectedIndex = index;
          widget.callback(vehiclePriceClasses[index]);
        });
      },
      child: Card(
        margin: const EdgeInsets.all(5),
        color: const Color(0xFFE4F3F5),
        shape: selectedIndex == index
            ? RoundedRectangleBorder(
            side: const BorderSide(color: Colors.green, width: 2.0),
            borderRadius: BorderRadius.circular(5.0))
            : RoundedRectangleBorder(
            side: const BorderSide(color: Colors.white, width: 2.0),
            borderRadius: BorderRadius.circular(5.0)),
        child: Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SvgPicture.asset(
                      "assets/svg/car-type-sedan.svg",
                      width: 50,
                      height: 40,
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        robotoTextWidget(
                            textval: vehiclePriceClasses[index]
                                .type
                                .toString()
                                .toCapitalized(),
                            colorval: AppColor.black,
                            sizeval: 16,
                            fontWeight: FontWeight.w200),
                        const SizedBox(
                          height: 5,
                        ),
                        Row(
                          children: [
                            Row(
                              children: [
                                Image.asset('assets/images/passengers-icon.png',
                                    height: 15, width: 15, fit: BoxFit.cover),
                                const SizedBox(
                                  width: 5,
                                ),
                                robotoTextWidget(
                                    textval:
                                    "${vehiclePriceClasses[index].passengerCapacity} People",
                                    colorval: AppColor.black,
                                    sizeval: 16,
                                    fontWeight: FontWeight.w200)
                              ],
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Row(
                              children: [
                                Image.asset('assets/images/weight-icon.png',
                                    height: 15, width: 15, fit: BoxFit.cover),
                                const SizedBox(
                                  width: 5,
                                ),
                                robotoTextWidget(
                                    textval: vehiclePriceClasses[index]
                                        .bootSpace
                                        .toString(),
                                    colorval: AppColor.black,
                                    sizeval: 16,
                                    fontWeight: FontWeight.w200)
                              ],
                            )
                          ],
                        )
                      ],
                    )
                  ],
                ),
                Container(
                  margin: const EdgeInsets.only(top: 5),
                  color: AppColor.border,
                  height: 2,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    robotoTextWidget(
                        textval: estimateFare,
                        colorval: AppColor.darkgrey,
                        sizeval: 12,
                        fontWeight: FontWeight.w600),
                    IconButton(
                        onPressed: () {},
                        icon: const Icon(
                          Icons.info_outlined,
                          size: 20.0,
                          color: Colors.grey,
                        ))
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(children: [
                      robotoTextWidget(
                          textval:
                          "₹${vehiclePriceClasses[index].total_fare.toStringAsFixed(0)}",
                          colorval: AppColor.black,
                          sizeval: 30,
                          fontWeight: FontWeight.w800),
                      SizedBox(width: 10,),
                      vehiclePriceClasses[index]
                          .seller_discount
                          .toDouble() !=
                          0.0
                          ? Text(
                        '₹${getTotalPrice(
                            vehiclePriceClasses[index]
                                .total_fare
                                .toDouble(),
                            vehiclePriceClasses[index]
                                .seller_discount
                                .toDouble())}',
                        textAlign: TextAlign.justify,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                        style: const TextStyle(
                            fontSize: 22,
                            color: AppColor.black,
                            fontWeight: FontWeight.w600,
                            fontFamily: 'Roboto',
                            decoration: TextDecoration.lineThrough),
                      )
                          : Container(),

                    ],),
                    vehiclePriceClasses[index]
                        .discountPercent
                        .toString() !=
                        null &&
                        vehiclePriceClasses[index]
                            .discountPercent !=
                            0.0
                        ? Column(
                      children: [
                        const robotoTextWidget(
                            textval: "Special Offer",
                            colorval: AppColor.purple,
                            sizeval: 14,
                            fontWeight: FontWeight.w800),
                        robotoTextWidget(
                            textval:
                            '${vehiclePriceClasses[index].discountPercent.toString()} % Off',
                            colorval: AppColor.purple,
                            sizeval: 13,
                            fontWeight: FontWeight.w400),
                      ],
                    )
                        : Container()
                  ],
                ),

              ],
            )),
      ),
    )],);
  }

  String getTotalPrice(double totalFare, double discount) {
    double num1 = totalFare;
    double num2 = discount;
    double sum = num1 + num2;
    return "${sum.toStringAsFixed(0)}";
  }
}
