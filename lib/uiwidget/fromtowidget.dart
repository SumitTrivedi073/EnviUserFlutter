import 'package:envi/theme/color.dart';
import 'package:envi/uiwidget/robotoTextWidget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../sidemenu/pickupDropAddressSelection/selectPickupDropAddress.dart';
import '../theme/string.dart';

class FromToWidget extends StatefulWidget {
  @override
  // TODO: implement createState
  State<StatefulWidget> createState() => _FromToWidgetPageState();
}

class _FromToWidgetPageState extends State<FromToWidget> {
  bool isButtonPressed = false;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Card(
          semanticContainer: true,
          clipBehavior: Clip.antiAliasWithSaveLayer,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          elevation: 5,
          child: Padding(
            padding: const EdgeInsets.all(5),
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
                                Navigator.of(context).pushAndRemoveUntil(
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            SelectPickupDropAddress(
                                                title: pickUpLocation)),
                                    (route) => true);
                              },
                              child: Container(
                                padding: const EdgeInsets.all(5),
                                child: robotoTextWidget(
                                  textval: FromLocationHint,
                                  colorval: AppColor.black,
                                  sizeval: 16,
                                  fontWeight: FontWeight.w200,
                                ),
                              ),
                            ),
                          ])),
                        ],
                      ),
                    )),
                Stack(alignment: Alignment.centerRight, children: <Widget>[
                  const SizedBox(
                    height: 1,
                    child: Divider(
                      color: AppColor.grey,
                      height: 1,
                    ),
                  ),
                  Container(
                    height: 40,
                    width: 70,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: AppColor.lightwhite,
                      border: Border.all(
                          color: AppColor.grey, // Set border color
                          width: 1.0), // Set border width
                      borderRadius: const BorderRadius.all(
                          Radius.circular(10.0)), // Set rounded corner radius
                    ),
                    child: robotoTextWidget(
                      textval: kmHint,
                      colorval: AppColor.black,
                      sizeval: 14,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ]),
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
                              onTap: () {
                                Navigator.of(context).pushAndRemoveUntil(
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            SelectPickupDropAddress(
                                                title: dropLocation)),
                                    (route) => true);
                              },
                              child: Container(
                                padding: const EdgeInsets.all(5),
                                child: robotoTextWidget(
                                  textval: ToLocationHint,
                                  colorval: AppColor.black,
                                  sizeval: 16,
                                  fontWeight: FontWeight.w200,
                                ),
                              ),
                            ),
                          ])),
                        ],
                      ),
                    ))
              ],
            ),
          ));

  }
}
