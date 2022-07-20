import 'package:envi/theme/color.dart';
import 'package:envi/uiwidget/robotoTextWidget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../theme/string.dart';
import '../web_service/Constant.dart';

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
    return Container(
      height: 180,
      child: Card(
          semanticContainer: true,
          clipBehavior: Clip.antiAliasWithSaveLayer,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          elevation: 5,
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              children: [
                GestureDetector(
                    onTap: () {
                      print("Tapped a Container");
                    },
                    child: Container(
                      height: 50,
                      margin: const EdgeInsets.only(left: 10),
                      child: Row(
                        children: [
                          SvgPicture.asset(
                            "assets/svg/from-location-img.svg",
                            width: 20,
                            height: 20,
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          robotoTextWidget(
                            textval: FromLocationHint,
                            colorval: AppColor.black,
                            sizeval: 18,
                            fontWeight: FontWeight.w200,
                          ),
                        ],
                      ),
                    )),
                Stack(alignment: Alignment.centerRight, children: <Widget>[
                  const SizedBox(
                    height: 2,
                    child: Divider(
                      color: AppColor.grey,
                      height: 2,
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
                      height: 50,
                      margin: const EdgeInsets.only(left: 10),
                      child: Row(
                        children: [
                          SvgPicture.asset(
                            "assets/svg/to-location-img.svg",
                            width: 20,
                            height: 20,
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          robotoTextWidget(
                            textval: ToLocationHint,
                            colorval: AppColor.black,
                            sizeval: 18,
                            fontWeight: FontWeight.w200,
                          ),
                        ],
                      ),
                    ))
              ],
            ),
          )),
    );
  }
}
