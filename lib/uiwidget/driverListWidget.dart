import 'dart:convert';

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
  List<DriverListModel> DriverList = [];
  late SharedPreferences sharedPreferences;

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
      "fromAddress":widget.fromAddress!.address,
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


    dynamic res = await HTTP.post(searchDriver(), data);
    if (res != null && res.statusCode != null && res.statusCode == 200) {

      setState(() {
       DriverList = (jsonDecode(res.body)['content'] as List)
            .map((i) => DriverListModel.fromJson(i))
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
                  child:  robotoTextWidget(
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
                          onPressed: () {},
                          icon: const Icon(
                            Icons.arrow_back_ios,
                            color: Colors.green,
                          ))
                    ]),
                    Row(children: [
                      Container(
                        width: 1,
                        color: AppColor.darkgrey,
                      ),
                      IconButton(
                          onPressed: () {},
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
            child:  Center(
              child:ListView.builder(
              itemBuilder: (context, index) {
                return GestureDetector(
                    onTap: () {},
                    child: Card(
                        margin: const EdgeInsets.all(5),
                        color: const Color(0xFFE4F3F5),
                        child: Padding(
                            padding: const EdgeInsets.all(8),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                                  children: [
                                    robotoTextWidget(
                                        textval: '${DriverList[index].durationToPickUpLocation} Minutes Away',
                                        colorval: AppColor.black,
                                        sizeval: 16,
                                        fontWeight: FontWeight.w600),
                                    Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                      children: [
                                        RatingBar.builder(
                                          initialRating: DriverList[index].driverRating!.toDouble(),
                                          minRating: 1,
                                          direction: Axis.horizontal,
                                          allowHalfRating: true,
                                          itemCount: 5,
                                          itemSize: 20,
                                          itemPadding: const EdgeInsets.symmetric(
                                              horizontal: 4.0),
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
                                            DriverList[index].driverPhoto.toString(),
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
                                            textval: DriverList[index].priceClass!.type.toString(),
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
                                                    textval: "${DriverList[index].priceClass!.passengerCapacity} People",
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
                                                Image.asset(
                                                    'assets/images/weight-icon.png',
                                                    height: 15,
                                                    width: 15,
                                                    fit: BoxFit.cover),
                                                const SizedBox(
                                                  width: 5,
                                                ),
                                                const robotoTextWidget(
                                                    textval: "7 Kg",
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
                                    const robotoTextWidget(
                                        textval: "₹220",
                                        colorval: AppColor.black,
                                        sizeval: 18,
                                        fontWeight: FontWeight.w800),
                                    const SizedBox(
                                      width: 25,
                                    ),
                                    const Text(
                                      "₹350",
                                      textAlign: TextAlign.justify,
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 2,
                                      style: TextStyle(
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
                                      children: const [
                                        robotoTextWidget(
                                            textval: "Special Offer",
                                            colorval: AppColor.purple,
                                            sizeval: 14,
                                            fontWeight: FontWeight.w800),
                                        robotoTextWidget(
                                            textval: "20% Off",
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
              },
              itemCount: DriverList.length,
              scrollDirection: Axis.horizontal,
              physics: const AlwaysScrollableScrollPhysics(),
            )),
          )
        ],
      ),
    ));
  }
}
