import 'package:envi/uiwidget/robotoTextWidget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

import '../provider/firestoreLiveTripDataNotifier.dart';
import '../theme/color.dart';
import '../theme/images.dart';
import '../utils/utility.dart';

class DriverDetailWidget extends StatefulWidget {
  String duration;

  DriverDetailWidget({
    Key? key,
    required this.duration,
  }) : super(key: key);

  @override
  // TODO: implement createState
  State<StatefulWidget> createState() => _DriverDetailWidgetState();
}

class _DriverDetailWidgetState extends State<DriverDetailWidget> {
  bool isButtonPressed = false;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Consumer<firestoreLiveTripDataNotifier>(
      builder: (context, value, child) {
        if (value.liveTripData == null) {
          return const CircularProgressIndicator();
        } else {
          return Container(
              margin: const EdgeInsets.only(left: 10, right: 10, bottom: 5),
              child: Card(
                semanticContainer: true,
                clipBehavior: Clip.antiAliasWithSaveLayer,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                elevation: 5,
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Stack(alignment: Alignment.centerRight, children: <
                      Widget>[
                    Container(
                      height: 50,
                      width: 50,
                      decoration: BoxDecoration(
                        color: AppColor.lightwhite,
                        border: Border.all(
                            color: AppColor.grey, // Set border color
                            width: 1.0), // Set border width
                        borderRadius: const BorderRadius.all(
                            Radius.circular(5.0)), // Set rounded corner radius
                      ),
                      child: Center(
                        child: IconButton(
                          icon: const Icon(
                            Icons.call,
                            color: Colors.green,
                          ),
                          onPressed: () {
                            makingPhoneCall(value
                                        .liveTripData!.driverInfo!.phone
                                        .toString() !=
                                    null
                                ? value.liveTripData!.driverInfo!.phone
                                    .toString()
                                : '');
                          },
                        ),
                      ),
                    ),
                    Container(
                        margin: const EdgeInsets.only(right: 53),
                        child: Column(
                          children: [
                            Container(
                              margin: const EdgeInsets.only(left: 10),
                              child: Row(
                                children: [
                                  ClipRRect(
                                      borderRadius: BorderRadius.circular(50.0),
                                      child: Image.network(
                                        encodeImgURLString(value.liveTripData!
                                            .driverInfo!.driverImgUrl),
                                        errorBuilder:
                                            (context, error, stackTrace) {
                                          return Image.asset(
                                            Images.personPlaceHolderImage,
                                            height: 50,
                                            width: 50,
                                          );
                                        },
                                        fit: BoxFit.fill,
                                        height: 50,
                                        width: 50,
                                      )),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        robotoTextWidget(
                                          textval: value.liveTripData!
                                                      .driverInfo!.name
                                                      .toString() !=
                                                  null
                                              ? value.liveTripData!.driverInfo!
                                                  .name
                                                  .toString()
                                              : '',
                                          colorval: AppColor.grey,
                                          sizeval: 16,
                                          fontWeight: FontWeight.w600,
                                        ),
                                        robotoTextWidget(
                                          textval: "${widget.duration} Away",
                                          colorval: AppColor.black,
                                          sizeval: 18,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ])
                                ],
                              ),
                            ),
                            Container(
                              height: 2,
                              margin: const EdgeInsets.only(top: 5, bottom: 5),
                              child: const Divider(
                                color: AppColor.darkgrey,
                                height: 2,
                              ),
                            ),
                            Row(
                              children: [
                                SvgPicture.asset(
                                  "assets/svg/car-type-sedan.svg",
                                  width: 40,
                                  height: 30,
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      robotoTextWidget(
                                        textval:
                                            '${value.liveTripData!.tripInfo!.priceClass!.type.toString().toTitleCase()} - ${value.liveTripData!.tripInfo!.priceClass!.passengerCapacity.toString()} People',
                                        colorval: AppColor.grey,
                                        sizeval: 16,
                                        fontWeight: FontWeight.w600,
                                      ),
                                      robotoTextWidget(
                                        textval: value.liveTripData!.driverInfo!
                                                    .vehicleNumber
                                                    .toString() !=
                                                null
                                            ? value.liveTripData!.driverInfo!
                                                .vehicleNumber
                                                .toUpperCase()
                                            : '',
                                        colorval: AppColor.black,
                                        sizeval: 18,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ])
                              ],
                            )
                          ],
                        )),
                  ]),
                ),
              ));
        }
      },
    );
  }
}
