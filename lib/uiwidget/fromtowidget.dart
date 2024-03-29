import 'package:envi/theme/color.dart';
import 'package:envi/uiwidget/robotoTextWidget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../enum/BookingTiming.dart';
import '../sidemenu/pickupDropAddressSelection/model/searchPlaceModel.dart';
import '../sidemenu/pickupDropAddressSelection/selectPickupDropAddress.dart';
import '../theme/string.dart';
import '../utils/utility.dart';

class FromToWidget extends StatefulWidget {
  final SearchPlaceModel? fromAddress;
  final SearchPlaceModel? toAddress;
  final BookingTiming tripType;
  String distance;

  FromToWidget(
      {Key? key,
      this.toAddress,
      this.fromAddress,
      required this.distance,
      required this.tripType})
      : super(key: key);

  @override
  // TODO: implement createState
  State<StatefulWidget> createState() => _FromToWidgetPageState();
}

class _FromToWidgetPageState extends State<FromToWidget> {
  bool isButtonPressed = false;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
        margin: const EdgeInsets.only(left: 10, right: 10),
        child: Card(
            semanticContainer: true,
            clipBehavior: Clip.antiAliasWithSaveLayer,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            elevation: 5,
            child: Padding(
              padding: const EdgeInsets.all(5),
              child: Stack(alignment: Alignment.centerRight, children: <Widget>[

                const Align(
                  alignment: Alignment.center,
                  child: SizedBox(
                    height: 1,
                    child: Divider(
                      color: AppColor.darkgrey,
                      height: 1,
                    ),
                  ),
                ),
                widget.distance != null && widget.distance.isNotEmpty
                    ? Container(
                        width: 70,
                        alignment: Alignment.centerRight,
                        decoration: BoxDecoration(
                          color: AppColor.lightwhite,
                          border: Border.all(
                              color: AppColor.grey, // Set border color
                              width: 1.0), // Set border width
                          borderRadius: const BorderRadius.all(Radius.circular(
                              5.0)), // Set rounded corner radius
                        ),
                        child:Padding(padding: const EdgeInsets.all(8),
                        child:  Align(alignment: Alignment.centerRight,
                        child: robotoTextWidget(
                          textval: '${widget.distance}',
                          colorval: AppColor.black,
                          sizeval: 12,
                          fontWeight: FontWeight.w600,
                        ),),),
                      )
                    : Container(),
                Container(
                  margin: const EdgeInsets.only(right: 70),
                  child: Column(
                    children: [
                      GestureDetector(
                          onTap: () {
                            print("Tapped a Container");
                          },
                          child: Container(
                            margin: const EdgeInsets.all(5),
                            child: Row(
                              children: [
                                SvgPicture.asset(
                                  "assets/svg/from-location-img.svg",
                                  width: 20,
                                  height: 20,
                                ),
                                const SizedBox(
                                  width: 5,
                                ),
                                Flexible(
                                    child: Wrap(children: [
                                      InkWell(
                                        onTap: () {
                                        },
                                        child: Container(
                                          padding: const EdgeInsets.all(3),
                                          child: robotoTextWidget(
                                            textval: formatAddress(widget.fromAddress!.address),
                                            colorval: AppColor.black,
                                            sizeval: 13,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                    ])),
                              ],
                            ),
                          )),

                      GestureDetector(
                          onTap: () {
                            print("Tapped a Container");
                          },
                          child: Container(
                            margin: const EdgeInsets.all(5),
                            child: Row(
                              children: [
                                SvgPicture.asset(
                                  "assets/svg/to-location-img.svg",
                                  width: 20,
                                  height: 20,
                                ),
                                const SizedBox(
                                  width: 5,
                                ),
                                Flexible(
                                    child: Wrap(children: [
                                      InkWell(
                                        onTap: () {},
                                        child: Container(
                                          padding: const EdgeInsets.all(3),
                                          child: robotoTextWidget(
                                            textval: formatAddress(widget.toAddress!.address),
                                            colorval: AppColor.black,
                                            sizeval: 13,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                    ])),
                              ],
                            ),
                          ))
                    ],
                  ),
                ),
              ]),
            )));
  }
}
