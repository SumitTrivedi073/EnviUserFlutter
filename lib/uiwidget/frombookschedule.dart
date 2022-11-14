import 'package:envi/sidemenu/pickupDropAddressSelection/selectPickupDropAddress.dart';
import 'package:envi/theme/color.dart';
import 'package:envi/uiwidget/robotoTextWidget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../appConfig/appConfig.dart';
import '../enum/BookingTiming.dart';
import '../sidemenu/pickupDropAddressSelection/model/searchPlaceModel.dart';
import '../theme/string.dart';
import '../theme/theme.dart';
import '../utils/utility.dart';

class FromBookScheduleWidget extends StatefulWidget {
  final String address;

  final SearchPlaceModel? currentLocation;

  FromBookScheduleWidget({required this.address, this.currentLocation});

  @override
  // TODO: implement createState
  State<StatefulWidget> createState() => _FromBookScheduleWidgetPageState();
}

late BookingTiming _status;

class _FromBookScheduleWidgetPageState extends State<FromBookScheduleWidget> {
  bool isButtonPressed = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      height: 110,
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
            child: Column(
              children: [
                GestureDetector(
                    onTap: () {
                      print("Tapped a Container");
                    },
                    child: Container(
                      height: 40,
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
                            Container(
                              padding: const EdgeInsets.only(right: 8),
                              child: robotoTextWidget(
                                textval: widget.address,
                                colorval: AppColor.black,
                                sizeval: 14,
                                fontWeight: FontWeight.w600,
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
                Center(
                  child: SizedBox(
                    height: 40,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          width: 115,
                          child: TextButton(
                            style: ButtonStyle(
                                shape: MaterialStateProperty.all(
                                  RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.circular(5), // <-- Radius
                                  ),
                                ),
                                backgroundColor: MaterialStateProperty.all(
                                    AppColor.darkGreen)),
                            child: Padding(
                              padding: const EdgeInsets.all(5),
                              child: robotoTextWidget(
                                textval: BookNow,
                                colorval: AppColor.white,
                                sizeval: 15.0,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            onPressed: () {
                              _status = BookingTiming.now;
                              if (!mounted) return;
                              Navigator.of(context).pushAndRemoveUntil(
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          SelectPickupDropAddress(
                                            currentLocation:
                                                widget.currentLocation,
                                            title: dropLocation,
                                            tripType: _status,
                                          )),
                                  (route) => true);
                            },
                          ),
                        ),
                        AppConfig().getisScheduleFeatureEnabled()
                            ? TextButton(
                                style: ButtonStyle(
                                    shape: MaterialStateProperty.all(
                                      RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(
                                            5), // <-- Radius
                                      ),
                                    ),
                                    backgroundColor: MaterialStateProperty.all(
                                        AppColor.alfaorange)),
                                child: Padding(
                                  padding: const EdgeInsets.all(5),
                                  child: robotoTextWidget(
                                    textval: BookForLater,
                                    colorval: AppColor.black,
                                    sizeval: 15.0,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                                onPressed: () {
                                  if (AppConfig()
                                          .getisScheduleFeatureEnabled() ==
                                      true) {
                                    _status = BookingTiming.later;
                              if (!mounted) return;

                                    Navigator.of(context).pushAndRemoveUntil(
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                SelectPickupDropAddress(
                                                  currentLocation:
                                                      widget.currentLocation,
                                                  title: dropLocation,
                                                  tripType: _status,
                                                )),
                                        (route) => true);
                                  } else {
                                    showSnackbar(context, serviceNotAvailable);
                                  }
                                },
                              )
                            : Container()
                      ],
                    ),
                  ),
                )
              ],
            ),
          )),
    );
  }
}
