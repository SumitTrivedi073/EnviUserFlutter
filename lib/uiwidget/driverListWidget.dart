import 'dart:convert';

import 'package:carousel_slider/carousel_controller.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:envi/sidemenu/searchDriver/confirmDriver.dart';
import 'package:envi/theme/color.dart';
import 'package:envi/uiwidget/robotoTextWidget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../web_service/HTTP.dart' as HTTP;
import '../appConfig/Profiledata.dart';
import '../sidemenu/pickupDropAddressSelection/model/searchPlaceModel.dart';
import '../sidemenu/searchDriver/model/driverListModel.dart';
import '../theme/images.dart';
import '../theme/string.dart';
import '../utils/utility.dart';
import '../web_service/APIDirectory.dart';

class DriverListItem extends StatefulWidget {
  final SearchPlaceModel? fromAddress;
  final SearchPlaceModel? toAddress;
  final void Function(String) callback;

  const DriverListItem(
      {Key? key, this.toAddress, this.fromAddress, required this.callback})
      : super(key: key);

  @override
  // TODO: implement createState
  State<StatefulWidget> createState() => DriverListItemPageState();
}

class DriverListItemPageState extends State<DriverListItem> {
  var listItemCount = 4;
  List<Content> DriverList = [];
  List<VehiclePriceClass> vehiclePriceClasses = [];
  late Distance distance;
  int? selectedIndex = 0;
  CarouselController carouselController = CarouselController();
  bool isLoading = false;
  bool isForwardArrowGreen = true;
  bool isBackArrowGreen = true;
  String Errormsg = '';

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  void initState() {
    super.initState();
    if (DriverList.isEmpty) {
      _firstLoad("0");
    }
  }

  void _firstLoad(String retry) async {
    Map data;
    data = {
      "fromAddress": widget.fromAddress!.address,
      "toAddress": widget.toAddress!.address,
      "phoneNumber": Profiledata().getphone(),
      "retry": retry,
      "userId": Profiledata().getusreid(),
      "userName": Profiledata().getname(),
      "location": {
        "latitude": widget.fromAddress!.latLng.latitude,
        "longitude": widget.fromAddress!.latLng.longitude
      },
      "toLocation": {
        "latitude": widget.toAddress!.latLng.latitude,
        "longitude": widget.toAddress!.latLng.longitude
      },
    };
    setState(() {
      isLoading = true;
    });
    dynamic res = await HTTP.post(context,searchDriver(), data);
    if (res != null && res.statusCode != null && res.statusCode == 200) {
      setState(() {
        isLoading = false;

        DriverList = (jsonDecode(res.body)['content'] as List)
            .map((i) => Content.fromJson(i))
            .toList();

        vehiclePriceClasses =
            (jsonDecode(res.body)['vehiclePriceClasses'] as List)
                .map((i) => VehiclePriceClass.fromJson(i))
                .toList();

        distance = Distance.fromJson(jsonDecode(res.body)['distance']);
        widget.callback(distance.text.toString());
      });
    } else {
      Errormsg = jsonDecode(res.body)['message'];

      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return isLoading
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : Container(child: getDriverList(DriverList));
  }

  Widget driverListItems(int index) {
    var tmp = DriverList[index].driverName ?? '';
    var driverName = tmp.length > 10 ? '${tmp.substring(0, 9)}..' : tmp;
    return Wrap(children: [
      Container(
        child: GestureDetector(
          onTap: () {
            setState(() {
              selectedIndex = index;
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
              child: Column(
                children: [
                  Container(
                    color: const Color(0xFFD8EBED),
                    child: Padding(
                      padding: const EdgeInsets.all(8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                             Align(alignment: Alignment.topLeft,
                             child:  robotoTextWidget(
                                 textval: driverName,
                                 colorval: AppColor.black,
                                 sizeval: 12,
                                 fontWeight: FontWeight.w400),),
                              robotoTextWidget(
                                  textval:
                                      '${DriverList[index].durationToPickUpLocation} Minutes Away',
                                  colorval: AppColor.black,
                                  sizeval: 16,
                                  fontWeight: FontWeight.w600),
                            ],
                          ),
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
                              ClipRRect(
                                  borderRadius: BorderRadius.circular(40.0),
                                  child: Image.network(
                                    encodeImgURLString(
                                        DriverList[index].driverPhoto),
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
                                  ))
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(padding: const EdgeInsets.all(8),
                  child: Column(children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SvgPicture.asset(
                          "assets/svg/car-type-sedan.svg",
                          width: 40,
                          height: 30,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            robotoTextWidget(
                                textval: DriverList[index]
                                    .priceClass!
                                    .type
                                    .toString()
                                    .toCapitalized(),
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
                                    Image.asset(
                                        'assets/images/passengers-icon.png',
                                        height: 15,
                                        width: 15,
                                        fit: BoxFit.cover),
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
                              size: 25.0,
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
                             "₹${vehiclePriceClasses[index].priceClass.totalFare?.toStringAsFixed(0)}",
                             colorval: AppColor.black,
                             sizeval: 30,
                             fontWeight: FontWeight.w800),
                         const SizedBox(width: 10,),
                         vehiclePriceClasses[index]
                             .priceClass
                             .sellerDiscount!
                             .toDouble() !=
                             0.0
                             ? Text(
                           '₹${getTotalPrice(
                               vehiclePriceClasses[index]
                                   .priceClass
                                   .totalFare!
                                   .toDouble(),
                               vehiclePriceClasses[index]
                                   .priceClass
                                   .sellerDiscount!
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
                            .priceClass
                            .discountPercent
                            .toString() !=
                            null &&
                            vehiclePriceClasses[index]
                                .priceClass
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
                                '${vehiclePriceClasses[index].priceClass.discountPercent.toString()} % Off',
                                colorval: AppColor.purple,
                                sizeval: 13,
                                fontWeight: FontWeight.w400),
                          ],
                        )
                            : Container()
                      ],
                    ),
                  ],),)
                ],
              )),
        ),
      )
    ]);
  }

  String getTotalPrice(double totalFare, double discount) {
    double num1 = totalFare;
    double num2 = discount;
    double sum = num1 + num2;
    return sum.toStringAsFixed(0);
  }

  Widget getDriverList(List<Content> driverList) {
    if (driverList.isNotEmpty) {
      return Wrap(children: [
        Container(
          child: Card(
            elevation: 5,
            margin: const EdgeInsets.all(5),
            child: Column(
              children: [
                driverList.length >1 ?SizedBox(
                  height: 50,
                  child: Column(children: [
                    Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        child: robotoTextWidget(
                            textval: '${DriverList.length} Ride Options',
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
                                icon: Icon(Icons.arrow_forward_ios,
                                    color:
                                    (selectedIndex != DriverList.length - 1)
                                        ? Colors.green
                                        : AppColor.grey)),
                            Container(
                              width: 1,
                              color: AppColor.grey,
                            ),
                          ]),
                        ],
                      ),
                    ],
                  ),
                    Container(
                      height: 1,
                      color: AppColor.grey,
                    ),
                  ],)
                ):Container(height: 1,
                decoration: const BoxDecoration(
                  color: Colors.transparent
                ),),

                const SizedBox(
                  height: 5,
                ),
                CarouselSlider(
                  items: List.generate(
                      DriverList.length, (index) => driverListItems(index)),
                  carouselController: carouselController,
                  options: CarouselOptions(
                    enableInfiniteScroll: false,
                    scrollDirection: Axis.horizontal,
                    onPageChanged: (index, reason) {
                      selectedIndex = index;
                      setState(() {
                        if (selectedIndex == 0) {
                          isBackArrowGreen = false;
                        } else {
                          isBackArrowGreen = true;
                        }
                        if (selectedIndex == DriverList.length - 1) {
                          isForwardArrowGreen = false;
                        } else {
                          isForwardArrowGreen = true;
                        }
                      });
                    },
                    autoPlay: false,
                  ),
                ),
                Container(
                    margin: const EdgeInsets.all(5),
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    ConfirmDriver(
                                      driverDetail: DriverList[selectedIndex!],
                                      priceDetail:
                                          vehiclePriceClasses[selectedIndex!],
                                      fromAddress: widget.fromAddress,
                                      toAddress: widget.toAddress,
                                    )),
                            (Route<dynamic> route) => true);
                      },
                      style: ElevatedButton.styleFrom(
                        primary: AppColor.greyblack,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5), // <-- Radius
                        ),
                      ),
                      child: Padding(padding: const EdgeInsets.all(15),
                      child: robotoTextWidget(
                        textval: bookNow.toUpperCase(),
                        colorval: AppColor.white,
                        sizeval: 16,
                        fontWeight: FontWeight.w600,
                      ),),
                    ))
              ],
            ),
          ),
        )
      ]);
    } else {
      return Container(
        height: MediaQuery.of(context).size.height / 7,
        margin: const EdgeInsets.all(10),
        child: Card(
            elevation: 5,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: robotoTextWidget(
                        textval: Errormsg,
                        colorval: AppColor.darkGreen,
                        sizeval: 14,
                        fontWeight: FontWeight.w800),
                  ),
                  Container(
                      height: 40,
                      width: 120,
                      margin: const EdgeInsets.all(5),
                      child: ElevatedButton(
                        onPressed: () {
                          _firstLoad("1");
                        },
                        style: ElevatedButton.styleFrom(
                          primary: AppColor.greyblack,
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(12), // <-- Radius
                          ),
                        ),
                        child: robotoTextWidget(
                          textval: retry,
                          colorval: AppColor.white,
                          sizeval: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ))
                ],
              ),
            )),
      );
    }
  }
}
