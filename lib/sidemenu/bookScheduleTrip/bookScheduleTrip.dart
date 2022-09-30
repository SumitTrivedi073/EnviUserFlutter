import 'dart:async';

import 'package:date_time_picker/date_time_picker.dart';
import 'package:envi/enum/BookingTiming.dart';
import 'package:envi/sidemenu/pickupDropAddressSelection/model/searchPlaceModel.dart';
import 'package:envi/theme/mapStyle.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../theme/color.dart';
import '../../theme/string.dart';
import '../../uiwidget/appbarInside.dart';
import '../../uiwidget/carCategoriesWidget.dart';
import '../../uiwidget/fromtowidget.dart';
import '../../uiwidget/mapDirectionWidget.dart';
import '../../uiwidget/robotoTextWidget.dart';

class BookScheduleTrip extends StatefulWidget {
  final SearchPlaceModel? fromAddress;
  final SearchPlaceModel? toAddress;
  const BookScheduleTrip({Key? key, this.toAddress, this.fromAddress})
      : super(key: key);

  @override
  State<BookScheduleTrip> createState() => BookScheduleTripState();
}

class BookScheduleTripState extends State<BookScheduleTrip> {
  LatLng? latlong = null;
  CameraPosition? _cameraPosition;
  GoogleMapController? _controller;
  String placeName = '';
  String? isoId;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _cameraPosition = const CameraPosition(target: LatLng(0, 0), zoom: 10.0);
  }

  final TextEditingController _controller1 =
      TextEditingController(text: DateTime.now().toString());
  final TextEditingController _controller2 = TextEditingController(text: '');
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        body: Stack(alignment: Alignment.centerRight, children: <Widget>[
      MapDirectionWidget(
        fromAddress: widget.fromAddress,
        toAddress: widget.toAddress,
      ),
      SingleChildScrollView(
        child: Column(children: [
          AppBarInsideWidget(title: FutureBookingTitel),
          const SizedBox(height: 5),
          Container(
            alignment: Alignment.bottomCenter,
            child: Column(
              children: [
                FromToWidget(
                  fromAddress: widget.fromAddress,
                  toAddress: widget.toAddress,
                  tripType: BookingTiming.later,
                ),
                CarCategoriesWidget(
                  fromAddress: widget.fromAddress,
                  toAddress: widget.toAddress,
                ),
              ],
            ),
          ),
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(2.0),
              side: const BorderSide(
                color: AppColor.border,
              ),
            ),
            child: SizedBox(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Expanded(
                    child: Container(
                      child: DateTimePicker(
                        type: DateTimePickerType.date,
                        dateMask: 'd MMM, yyyy',
                        controller: _controller1,
                        //initialValue: _initialValue,
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2100),
                        icon: Icon(Icons.event),
                        dateLabelText: pickupdate,
                        // timeLabelText: "Hour",
                        //use24HourFormat: false,
                        //locale: Locale('pt', 'BR'),
                        selectableDayPredicate: (date) {
                          if (date.weekday == 6 || date.weekday == 7) {
                            return false;
                          }
                          return true;
                        },
                        
                        //  onChanged: (val) => setState(() => _valueChanged1 = val),
                        // validator: (val) {
                        //   setState(() => _valueToValidate1 = val ?? '');
                        //   return null;
                        // },
                        //   onSaved: (val) => setState(() => _valueSaved1 = val ?? ''),
                      ),
                    ),
                  ),

                  // Container(
                  //   margin: const EdgeInsets.only(left: 10),
                  //   padding: const EdgeInsets.only(top: 5,bottom: 5),
                  //   child: Column(
                  //     mainAxisAlignment: MainAxisAlignment.center,
                  //     children:  [
                  //       robotoTextWidget(
                  //           textval:"₹",
                  //           colorval: AppColor.black,
                  //           sizeval: 16,
                  //           fontWeight: FontWeight.w800),

                  //        robotoTextWidget(
                  //           textval: pickupdate,
                  //           colorval: AppColor.lightText,
                  //           sizeval: 16,
                  //           fontWeight: FontWeight.w400),
                  //     ],
                  //   ),
                  // ),

                  const SizedBox(width: 10),
                  Container(
                    height: 55,
                    width: 1,
                    color: AppColor.border,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Container(
                      child: DateTimePicker(
                        type: DateTimePickerType.time,
                        //  dateMask: 'd MMM, yyyy',
                        controller: _controller2,
                        //initialValue: _initialValue,
                        // firstDate: DateTime(2000),
                        // lastDate: DateTime(2100),
                        icon: Icon(Icons.event),
                        //dateLabelText: pickuptime,
                        timeLabelText: pickuptime,
                        //use24HourFormat: false,
                        //locale: Locale('pt', 'BR'),
                        // selectableDayPredicate: (date) {
                        //   if (date.weekday == 6 || date.weekday == 7) {
                        //     return false;
                        //   }
                        //   return true;
                        // },
                        //  onChanged: (val) => setState(() => _valueChanged1 = val),
                        // validator: (val) {
                        //   setState(() => _valueToValidate1 = val ?? '');
                        //   return null;
                        // },
                        //   onSaved: (val) => setState(() => _valueSaved1 = val ?? ''),
                      ),
                    ),
                  ),
                  // Container(
                  //     margin: const EdgeInsets.only(right: 10),
                  //     padding: const EdgeInsets.only(top: 5, bottom: 5),
                  //     child: Column(
                  //       mainAxisAlignment: MainAxisAlignment.center,
                  //       children: [
                  //         robotoTextWidget(
                  //             textval: ' Mins',
                  //             colorval: AppColor.black,
                  //             sizeval: 16,
                  //             fontWeight: FontWeight.w800),
                  //         robotoTextWidget(
                  //             textval: pickuptime,
                  //             colorval: AppColor.lightText,
                  //             sizeval: 16,
                  //             fontWeight: FontWeight.w400),
                  //       ],
                  //     )),
                ],
              ),
            ),
          ),
          const SizedBox(height: 230),
        ]),
      ),
      Align(
        alignment: Alignment.bottomCenter,
        child: Container(
            height: 40,
            margin: const EdgeInsets.all(5),
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                primary: AppColor.greyblack,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12), // <-- Radius
                ),
              ),
              child: robotoTextWidget(
                textval: bookingConfirmation,
                colorval: AppColor.white,
                sizeval: 14,
                fontWeight: FontWeight.w600,
              ),
            )),
      ),
    ]));
  }
}
//https://rrtutors.com/tutorials/Show-Current-Location-On-Maps-Flutter-Fetch-Current-Location-Address
//https://stackoverflow.com/questions/52591556/custom-markers-with-flutter-google-maps-plugin
