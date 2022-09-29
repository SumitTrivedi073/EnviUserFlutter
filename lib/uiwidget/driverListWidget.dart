import 'dart:convert';

import 'package:carousel_slider/carousel_controller.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:envi/sidemenu/searchDriver/confirmDriver.dart';
import 'package:envi/theme/color.dart';
import 'package:envi/uiwidget/robotoTextWidget.dart';
import 'package:envi/web_service/Constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../web_service/HTTP.dart' as HTTP;
import '../sidemenu/pickupDropAddressSelection/model/searchPlaceModel.dart';
import '../sidemenu/searchDriver/model/driverListModel.dart';
import '../theme/string.dart';
import '../web_service/APIDirectory.dart';

class DriverListItem extends StatefulWidget {
  final SearchPlaceModel? fromAddress;
  final SearchPlaceModel? toAddress;

  const DriverListItem({Key? key, this.toAddress, this.fromAddress})
      : super(key: key);

  @override
  // TODO: implement createState
  State<StatefulWidget> createState() => _DriverListItemPageState();
}

class _DriverListItemPageState extends State<DriverListItem> {
  var listItemCount = 4;
  List<Content> DriverList = [];
  List<VehiclePriceClass> vehiclePriceClasses = [];
  late SharedPreferences sharedPreferences;
  int? selectedIndex;
  CarouselController carouselController = CarouselController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _firstLoad();
  }

  void _firstLoad() async {
    sharedPreferences = await SharedPreferences.getInstance();
    Map data;
    data = {
      "fromAddress": widget.fromAddress!.address,
      "toAddress": widget.toAddress!.address,
      "phoneNumber": sharedPreferences.getString(Loginphone),
      "retry": "0",
      "userId": sharedPreferences.getString(LoginID),
      "userName": sharedPreferences.getString(LoginName),
      "location": {
        "latitude": widget.fromAddress!.latLng!.latitude,
        "longitude": widget.fromAddress!.latLng!.longitude
      },
      "toLocation": {
        "latitude": widget.toAddress!.latLng!.latitude,
        "longitude": widget.toAddress!.latLng!.longitude
      },
    };

    print("data=======>$data");
    dynamic res = await HTTP.post(searchDriver(), data);
    if (res != null && res.statusCode != null && res.statusCode == 200) {
      setState(() {
        DriverList = (jsonDecode(res.body)['content'] as List)
            .map((i) => Content.fromJson(i))
            .toList();

        vehiclePriceClasses =
            (jsonDecode(res.body)['vehiclePriceClasses'] as List)
                .map((i) => VehiclePriceClass.fromJson(i))
                .toList();
      });
    } else {
      throw "Can't get DriverList.";
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Expanded(
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
                      textval: '${DriverList.length} Ride Option',
                      colorval: AppColor.black,
                      sizeval: 14,
                      fontWeight: FontWeight.w800),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Row(children: [
                      Container(
                        width: 1,
                        color: AppColor.darkgrey,
                      ),
                      IconButton(
                          onPressed: () {
                            if (selectedIndex != 0) {
                              carouselController.previousPage();
                            }
                          },
                          icon: Icon(
                            Icons.arrow_back_ios,
                            color: (selectedIndex != 0)
                                ? Colors.green
                                : AppColor.grey,
                          ))
                    ]),
                    Row(children: [
                      Container(
                        width: 1,
                        color: AppColor.darkgrey,
                      ),
                      IconButton(
                          onPressed: () {
                            if (selectedIndex != DriverList.length - 1) {
                              carouselController.nextPage();
                            }
                          },
                          icon: const Icon(
                            Icons.arrow_forward_ios,
                            color: Colors.green,
                          )),
                      Container(
                        width: 1,
                        color: AppColor.grey,
                      ),
                    ]),
                  ],
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
          Expanded(
              child: CarouselSlider(
            items: List.generate(
                DriverList.length, (index) => driverListItems(index)),
            carouselController: carouselController,
            options: CarouselOptions(
              onPageChanged: (index, reason) {
                selectedIndex = index;
              },
              autoPlay: false,
            ),
          )),
          Container(
              height: 40,
              margin: const EdgeInsets.all(5),
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(
                          builder: (BuildContext context) => ConfirmDriver(
                                driverDetail: DriverList[selectedIndex!],
                                priceDetail:
                                    vehiclePriceClasses[selectedIndex!],
                                fromAddress: widget.fromAddress,
                                toAddress: widget.toAddress,
                              )),
                      (Route<dynamic> route) => false);
                },
                style: ElevatedButton.styleFrom(
                  primary: AppColor.greyblack,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12), // <-- Radius
                  ),
                ),
                child: robotoTextWidget(
                  textval: bookNow,
                  colorval: AppColor.white,
                  sizeval: 14,
                  fontWeight: FontWeight.w600,
                ),
              ))
        ],
      ),
    ));
  }

  Widget driverListItems(int index) {
    return GestureDetector(
      onTap: (){
        selectedIndex = index;
        print("selectedIndex========>$selectedIndex");
      },
      child: Card(
        margin: const EdgeInsets.all(5),
        color: const Color(0xFFE4F3F5),
        child: Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              children: [
                Row(
                  children: [
                    robotoTextWidget(
                        textval:
                        '${DriverList[index].durationToPickUpLocation} Minutes Away',
                        colorval: AppColor.black,
                        sizeval: 16,
                        fontWeight: FontWeight.w600),
                    Row(
                      children: [
                        RatingBar.builder(
                          initialRating:
                          DriverList[index].driverRating!.toDouble(),
                          minRating: 1,
                          direction: Axis.horizontal,
                          allowHalfRating: true,
                          itemCount: 5,
                          itemSize: 14,
                          itemPadding:
                          const EdgeInsets.symmetric(horizontal: 2.0),
                          itemBuilder: (context, _) => const Icon(
                            Icons.star,
                            color: Colors.amber,
                          ),
                          onRatingUpdate: (rating) {
                            print(rating);
                          },
                        ),
                        Card(
                          child: Image.network(
                            DriverList[index].driverPhoto ?? '',
                            fit: BoxFit.fill,
                            height: 40,
                            width: 50,
                          ),
                        )
                      ],
                    ),
                  ],
                ),
                Row(
                  children: [
                    SvgPicture.asset(
                      "assets/svg/car-type-sedan.svg",
                      width: 40,
                      height: 30,
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    Column(
                      children: [
                        robotoTextWidget(
                            textval:
                            DriverList[index].priceClass!.type.toString(),
                            colorval: AppColor.black,
                            sizeval: 14,
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
                                    "${DriverList[index].priceClass!.passengerCapacity} People",
                                    colorval: AppColor.black,
                                    sizeval: 14,
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
                                    textval: DriverList[index]
                                        .priceClass!
                                        .bootSpace
                                        .toString(),
                                    colorval: AppColor.black,
                                    sizeval: 14,
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
                  margin: const EdgeInsets.only(top: 10),
                  color: AppColor.border,
                  height: 2,
                ),
                const SizedBox(
                  height: 5,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    robotoTextWidget(
                        textval: estimateFare,
                        colorval: AppColor.darkgrey,
                        sizeval: 12,
                        fontWeight: FontWeight.w600),
                    const SizedBox(
                      width: 30,
                    ),
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
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    robotoTextWidget(
                        textval:
                        "₹${vehiclePriceClasses[index].priceClass.totalFare}",
                        colorval: AppColor.black,
                        sizeval: 18,
                        fontWeight: FontWeight.w800),
                    const SizedBox(
                      width: 25,
                    ),
                    Text(
                      getTotalPrice(
                          vehiclePriceClasses[index]
                              .priceClass
                              .totalFare!
                              .toInt(),
                          vehiclePriceClasses[index]
                              .priceClass
                              .sellerDiscount!
                              .toInt()),
                      textAlign: TextAlign.justify,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                      style: const TextStyle(
                          fontSize: 16,
                          color: AppColor.black,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Roboto',
                          decoration: TextDecoration.lineThrough),
                    ),
                    const SizedBox(
                      width: 25,
                    ),
                    Column(
                      children: [
                        const robotoTextWidget(
                            textval: "Special Offer",
                            colorval: AppColor.purple,
                            sizeval: 14,
                            fontWeight: FontWeight.w800),
                        robotoTextWidget(
                            textval:
                            '${vehiclePriceClasses[index].priceClass.discountPercent.toString()} % Off',
                            colorval: AppColor.purple,
                            sizeval: 13,
                            fontWeight: FontWeight.w400),
                      ],
                    )
                  ],
                ),
              ],
            )),
      ),
    );
  }

  String getTotalPrice(int totalFare, int discount) {
    int num1 = totalFare;

    int num2 = discount;

    int sum = num1 + num2;
    print('sum:$sum');
    return "₹$sum";
  }
}