import 'dart:convert';

import 'package:carousel_slider/carousel_controller.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:envi/theme/color.dart';
import 'package:envi/uiwidget/robotoTextWidget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../sidemenu/bookScheduleTrip/model/vehiclePriceClasses.dart';
import '../sidemenu/pickupDropAddressSelection/model/searchPlaceModel.dart';
import '../theme/string.dart';
import '../web_service/ApiCollection.dart';

class CarCategoriesWidget extends StatefulWidget {
  final SearchPlaceModel? fromAddress;
  final SearchPlaceModel? toAddress;
  final void Function(vehiclePriceClassesModel) callback;
  final void Function(String) callback2;

  const CarCategoriesWidget(
      {Key? key,
      this.toAddress,
      this.fromAddress,
      required this.callback,
      required this.callback2})
      : super(key: key);

  @override
  // TODO: implement createState
  State<StatefulWidget> createState() => _CarCategoriesWidgetState();
}

class _CarCategoriesWidgetState extends State<CarCategoriesWidget> {
  var listItemCount = 0;
  var distance;
  List<vehiclePriceClassesModel> vehiclePriceClasses = [];
  int? selectedIndex;
  CarouselController carouselController = CarouselController();
  bool isLoading = false;

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
        widget.toAddress!.latLng.longitude);
    if (response != null&&response.statusCode == 200) {
        setState(() {
          isLoading = false;
          vehiclePriceClasses = (jsonDecode(response.body)['content']
                  ['vehiclePriceClasses'] as List)
              .map((i) => vehiclePriceClassesModel.fromJson(i))
              .toList();
          distance = jsonDecode(response.body)['content']['estimatedDistance'];
          widget.callback2(distance.toString());
        });

    }else{
      setState(() { isLoading == false;});
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return isLoading
        ? const Center(
      child: CircularProgressIndicator(),
    )
        :Card(
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
                      textval: '${vehiclePriceClasses.length} Ride Option',
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
          Container(
            margin: EdgeInsets.symmetric(vertical: 2.0),
            height: 170.0,
            child: ListView.builder(
              // controller: _controller,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                return driverListItems(index);
              },
              itemCount: vehiclePriceClasses.length,
              padding: const EdgeInsets.all(3),
            ),
          )
        ],
      ),
    );
  }

  Widget driverListItems(int index) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedIndex = index;
          print("selectedIndex========>$selectedIndex");
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
                            textval: vehiclePriceClasses[index].type.toString(),
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
                                        "${vehiclePriceClasses[index].passengerCapacity} People $index",
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
                                    textval: vehiclePriceClasses[index]
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
                        textval: "₹${vehiclePriceClasses[index].total_fare}",
                        colorval: AppColor.black,
                        sizeval: 18,
                        fontWeight: FontWeight.w800),
                    const SizedBox(
                      width: 25,
                    ),
                    Text(
                      getTotalPrice(
                          vehiclePriceClasses[index].total_fare.toDouble(),
                          vehiclePriceClasses[index].seller_discount.toDouble()),
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
                                '${vehiclePriceClasses[index].discountPercent.toString()} % Off',
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

  String getTotalPrice(double totalFare, double discount) {
    double num1 = totalFare;

    double num2 = discount;

    double sum = num1 + num2;
    print('sum:$sum');
    return "₹$sum";
  }
}
