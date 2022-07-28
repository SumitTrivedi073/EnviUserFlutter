import 'package:envi/theme/color.dart';
import 'package:envi/uiwidget/robotoTextWidget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../theme/string.dart';

class FromBookScheduleWidget extends StatefulWidget {
  final String  address;

  FromBookScheduleWidget({required this.address});

  @override
  // TODO: implement createState
  State<StatefulWidget> createState() => _FromBookScheduleWidgetPageState();
}

class _FromBookScheduleWidgetPageState extends State<FromBookScheduleWidget> {
  bool isButtonPressed = false;
  String Address = PickUp;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      height: 140,
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
                            width: 5,
                          ),
                          Flexible(
                              child: Wrap(children: [
                            InkWell(
                              onTap: (){

                              },
                              child: Container(
                                padding: const EdgeInsets.only(right: 8),
                                child: robotoTextWidget(
                                  textval: widget.address,
                                  colorval: AppColor.black,
                                  sizeval: 18,
                                  fontWeight: FontWeight.w200,
                                ),
                              ),
                            ),
                          ]))
                        ],
                      ),
                    )),
                Container(
                  margin: const EdgeInsets.only(
                      top: 5, left: 10, right: 10, bottom: 5),
                  height: 1,
                  width: MediaQuery.of(context).size.width,
                  child: const Divider(
                    color: Colors.grey,
                    height: 1,
                  ),
                ),
                SizedBox(
                  height: 50,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton(
                        child:  robotoTextWidget(
                          textval: BookNow,
                          colorval: AppColor.black,
                          sizeval: 18.0,
                          fontWeight: FontWeight.w800,
                        ),
                        onPressed: () {},
                      ),
                      ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          primary: AppColor.yellow,
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(12), // <-- Radius
                          ),
                        ),
                        child: robotoTextWidget(
                          textval: BookForLater,
                          colorval: AppColor.white,
                          sizeval: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          )),
    );
  }


}
