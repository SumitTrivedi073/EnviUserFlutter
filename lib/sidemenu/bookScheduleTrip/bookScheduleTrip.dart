import 'dart:convert';

import 'package:bottom_picker/bottom_picker.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:envi/enum/BookingTiming.dart';
import 'package:envi/sidemenu/pickupDropAddressSelection/model/searchPlaceModel.dart';
import 'package:envi/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';

import '../../appConfig/appConfig.dart';
import '../../theme/color.dart';
import '../../theme/string.dart';
import '../../uiwidget/appbarInside.dart';
import '../../uiwidget/carCategoriesWidget.dart';
import '../../uiwidget/fromtowidget.dart';
import '../../uiwidget/mapPageWidgets/mapDirectionWidget.dart';
import '../../uiwidget/robotoTextWidget.dart';
import '../../utils/utility.dart';
import '../../web_service/ApiCollection.dart';
import '../home/homePage.dart';
import 'model/vehiclePriceClasses.dart';

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
  String? isoId;
  bool isverify = false;
  vehiclePriceClassesModel? SelectedVehicle;
  late DateTime mindatime;
  late DateTime SelectedDate;
  String selectedTimetext ="";
  String selectedDatetext ="";

  void getSelectvehicle(vehiclePriceClassesModel object) {
    SelectedVehicle = object;
  }

  late String scheduledAt = "";
  late String distance = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    mindatime = DateTime.now()
        .add(Duration(minutes: AppConfig().getadvance_booking_time_limit()));
    SelectedDate = mindatime;
    var outputFormat = DateFormat("d MMM, yyyy");
    setState(() {
      selectedDatetext = outputFormat.format(SelectedDate);
    });
  }

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        body: Stack(children: [
      MapDirectionWidget(
        fromAddress: widget.fromAddress,
        toAddress: widget.toAddress,
      ),
      AppBarInsideWidget(
        pagetitle: FutureBookingTitle,
        isBackButtonNeeded: true,
      ),
      Positioned(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          // start at end/bottom of column
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            FromToWidget(
              fromAddress: widget.fromAddress,
              toAddress: widget.toAddress,
              distance: "$distance",
              tripType: BookingTiming.later,
            ),
            CarCategoriesWidget(
              fromAddress: widget.fromAddress,
              toAddress: widget.toAddress,
              callback: getSelectvehicle,
              callback2: retrieveDistance,
              scheduledAt: scheduledAt,
            ),
            Container(
              margin: EdgeInsets.only(top: 5,left: 10,right: 10),
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5.0),
                  side: const BorderSide(
                    color: AppColor.border,
                  ),
                ),
                child: Padding(padding: EdgeInsets.only(left: 5,right: 5,top: 20,bottom: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Expanded(
                      child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                  children: [  const Icon(
                    Icons.event,
                    color: AppColor.grey,
                  ),Column(children: [


                    robotoTextWidget(
                      textval: pickupdate,
                      colorval: AppColor.grey,
                      sizeval: 12,
                      fontWeight: FontWeight.normal,
                    ),
                    MaterialButton(

                      height: 20,
                      onPressed: () {
                        _openDatePicker(context);
                      },
                      child:  robotoTextWidget(
                        textval: selectedDatetext!,
                        colorval: AppColor.black,
                        sizeval: 14,
                        fontWeight: FontWeight.w700,
                      ),
                    ),

                  ],)],)

                    ),
                    const SizedBox(width: 10),
                    Container(
                      height: 55,
                      width: 1,
                      color: AppColor.border,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child:Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [  const Icon(
                        Icons.access_time,
                        color: AppColor.grey,
                      ),Column(children: [


                        robotoTextWidget(
                          textval: pickuptime,
                          colorval: AppColor.grey,
                          sizeval: 12,
                          fontWeight: FontWeight.normal,
                        ),
                        MaterialButton(

height: 20,
                        onPressed: () {
                          _openTimePicker(context);
                        },
                        child:  robotoTextWidget(
                          textval: selectedTimetext!,
                          colorval: AppColor.black,
                          sizeval: 14,
                          fontWeight: FontWeight.w700,
                        ),
                      ),

                      ],)],),
                    ),
                  ],
                ),),
              ),
            ),
            Container(
                margin: const EdgeInsets.only(top: 5,left: 10,right: 10,bottom: 10),
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    if (selectedTimetext.isNotEmpty) {
                      if (SelectedVehicle != null &&
                          SelectedVehicle!.type != "") {


                        if ((mindatime.difference(SelectedDate).inMinutes) <= 0) {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) =>
                                _buildPopupDialog(
                                    context,
                                    DateFormat('d MMM, yyyy HH:mm')
                                        .format(SelectedDate)),
                          );
                        } else {
                          int hours =
                              (AppConfig().getadvance_booking_time_limit() / 60).toInt();
                          int minutes =
                              (AppConfig().getadvance_booking_time_limit() % 60)
                                  .toInt();

                          var hourStr = hours >= 1 ? '${hours} hour(s)' : '';
                          var minStr = minutes >= 1 ? '${minutes} min(s)' : '';

                          String message =
                              "Please select a time slot, no earlier than ${hourStr} ${minStr}";

                          utility.showInSnackBar(
                              value: message,
                              context: context,
                              duration: const Duration(seconds: 3));
                        }
                      } else {
                        utility.showInSnackBar(
                            value: 'Please select Car',
                            context: context,
                            duration: const Duration(seconds: 3));
                      }
                    } else {
                      utility.showInSnackBar(
                          value: 'Please select your Date and Time',
                          context: context,
                          duration: const Duration(seconds: 3));
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    primary: AppColor.greyblack,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5), // <-- Radius
                    ),
                  ),
                  child: Padding(padding: EdgeInsets.all(15),
                  child: robotoTextWidget(
                    textval: bookingConfirmation.toUpperCase(),
                    colorval: AppColor.white,
                    sizeval: 14,
                    fontWeight: FontWeight.w600,
                  ),),
                )),
          ],
        ),
      ),
    ]));
  }

  Widget _buildPopupDialog(BuildContext context, String schedualTime) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5),
      ),
      content: Column(mainAxisSize: MainAxisSize.min, children: [
        const Padding(
          padding: EdgeInsets.only(top: 10),
          child: Text(
            "You are booking",
            style: TextStyle(
                color: AppColor.butgreen,
                fontFamily: 'Roboto',
                fontWeight: FontWeight.w600,
                fontSize: 14),
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(2.0),
            side: const BorderSide(
              color: AppColor.grey,
              width: 0.5
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.only(top: 5, bottom: 5),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    robotoTextWidget(
                        textval: SelectedVehicle!.type.toString().toTitleCase(),
                        colorval: AppColor.black,
                        sizeval: 14,
                        fontWeight: FontWeight.w200),
                  ],
                ),
                const SizedBox(
                  width: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
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
                                "${SelectedVehicle!.passengerCapacity} People",
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
                            textval: SelectedVehicle!.bootSpace.toString(),
                            colorval: AppColor.black,
                            sizeval: 14,
                            fontWeight: FontWeight.w200)
                      ],
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
        const SizedBox(height: 10),
        const Text(
          "Schedule At",
          style: TextStyle(
              color: AppColor.butgreen,
              fontFamily: 'Roboto',
              fontWeight: FontWeight.w600,
              fontSize: 14),
        ),
        const SizedBox(
          height: 5,
        ),
        Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(2.0),
            side: const BorderSide(
              color: AppColor.grey,
                width: 0.5),
          ),
          child: Container(
            width: MediaQuery.of(context).size.width,
            padding: const EdgeInsets.all(10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                robotoTextWidget(
                    textval: schedualTime.toString(),
                    colorval: AppColor.black,
                    sizeval: 12,
                    fontWeight: FontWeight.w200),
              ],
            ),
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        const Text(
          "Fare & Distance",
          style: TextStyle(
              color: AppColor.butgreen,
              fontFamily: 'Roboto',
              fontWeight: FontWeight.w600,
              fontSize: 14),
        ),
        const SizedBox(
          height: 5,
        ),
        Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(2.0),
            side: const BorderSide(
              color: AppColor.grey,
              width: 0.5,
            ),
          ),
          child: SizedBox(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Container(
                  margin: const EdgeInsets.only(left: 10),
                  padding: const EdgeInsets.only(top: 5, bottom: 5),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      robotoTextWidget(
                          textval:
                              "₹${SelectedVehicle!.total_fare.toStringAsFixed(0)}",
                          colorval: AppColor.black,
                          sizeval: 12,
                          fontWeight: FontWeight.w200),
                      robotoTextWidget(
                          textval: ApproxFare,
                          colorval: AppColor.black,
                          sizeval: 12,
                          fontWeight: FontWeight.w400),
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                Container(
                  height: 55,
                  color: AppColor.grey,
                    width: 0.5
                ),
                const SizedBox(width: 10),
                Container(
                    margin: const EdgeInsets.only(right: 10),
                    padding: const EdgeInsets.only(top: 5, bottom: 5),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        robotoTextWidget(
                            textval:
                                '${SelectedVehicle!.distance.toStringAsFixed(0)} KM',
                            colorval: AppColor.black,
                            sizeval: 12,
                            fontWeight: FontWeight.w200),
                        const robotoTextWidget(
                            textval: "Distance",
                            colorval: AppColor.black,
                            sizeval: 12,
                            fontWeight: FontWeight.w400),
                      ],
                    )),
              ],
            ),
          ),
        ),
        const SizedBox(height: 10),
        Text(
          Fromaddress,
          style: const TextStyle(
              color: AppColor.butgreen,
              fontFamily: 'Roboto',
              fontWeight: FontWeight.w600,
              fontSize: 14),
        ),
        const SizedBox(
          height: 5,
        ),
        Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(2.0),
            side: const BorderSide(
              color: AppColor.grey,
                width: 0.5
            ),
          ),
          child: Container(
            width: MediaQuery.of(context).size.width,
            padding: const EdgeInsets.all(10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                robotoTextWidget(
                    textval: widget.fromAddress!.address.toString(),
                    colorval: AppColor.black,
                    sizeval: 12,
                    fontWeight: FontWeight.w200),
              ],
            ),
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        Text(
          Toaddress,
          style: const TextStyle(
              color: AppColor.butgreen,
              fontFamily: 'Roboto',
              fontWeight: FontWeight.w600,
              fontSize: 14),
        ),
        const SizedBox(
          height: 5,
        ),
        Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(2.0),
            side: const BorderSide(
              color: AppColor.grey,
                width: 0.5
            ),
          ),
          child: Container(
            width: MediaQuery.of(context).size.width,
            padding: const EdgeInsets.all(10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                robotoTextWidget(
                    textval: widget.toAddress!.address.toString(),
                    colorval: AppColor.black,
                    sizeval: 12,
                    fontWeight: FontWeight.w200),
              ],
            ),
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              style: ElevatedButton.styleFrom(
                primary: AppColor.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5), // <-- Radius
                ),
              ),
              child: Padding(padding: EdgeInsets.all(10),
              child: robotoTextWidget(
                textval: cancel,
                colorval: AppColor.greyblack,
                sizeval: 14,
                fontWeight: FontWeight.w600,
              ),),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                confirmBooking();
              },
              style: ElevatedButton.styleFrom(
                primary: AppColor.greyblack,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5), // <-- Radius
                ),
              ),
              child:  Padding(padding: EdgeInsets.all(10),
    child:robotoTextWidget(
                textval: confirm,
                colorval: AppColor.white,
                sizeval: 14,
                fontWeight: FontWeight.w600,
              )),
            ),
          ],
        )
      ]),
    );
  }

  Future<void> updatedtime() async {
    // <-- dd/MM 24H format
    var outputFormat = DateFormat("yyyy-MM-ddTHH:mm:ss");
    setState(() {
      scheduledAt = outputFormat.format(SelectedDate);
    });
  }

  Future<void> confirmBooking() async {
   // <-- dd/MM 24H format
    var outputFormat = DateFormat("yyyy-MM-ddTHH:mm:ss");
    var outputDate = outputFormat.format(SelectedDate);
    print(outputDate);
    final response = await ApiCollection.AddnewSchedualeTrip(
        widget.fromAddress,
        widget.toAddress,
        outputDate,
        SelectedVehicle!.total_fare,
        SelectedVehicle!.distance,
        SelectedVehicle!.sku_id);

    if (response != null) {
      if (response.statusCode == 200) {
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
                builder: (BuildContext context) => const HomePage(
                      title: "",
                    )),
            (Route<dynamic> route) => true);
      }
      showSnackbar(context, (jsonDecode(response.body)['msg'].toString()));
    }
  }
  void _openDatePicker(BuildContext context) {
    BottomPicker.date(
      title: pickupdate,
      titleStyle: const TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 15,
        color: Colors.white,
      ),
      onSubmit: (index) {
        print(index);
       // SelectedDate = index;
        var inputFormat = DateFormat('yyyy-MM-dd HH:mm');
        SelectedDate = inputFormat.parse(
            "${DateFormat('yyyy-MM-dd').format(index)} ${DateFormat('HH:mm').format(SelectedDate)}");
        var outputFormat = DateFormat("d MMM, yyyy");
        setState(() {
          selectedDatetext = outputFormat.format(SelectedDate);
        });
        updatedtime();
      },
      onClose: () {
        print('Picker closed');
      },
      buttonText:  'Confirm',
      buttonTextStyle:  const  TextStyle(
          color:  Colors.white
      ),
      pickerTextStyle:  const TextStyle(
        color:  Colors.white,
        fontSize:  14,
        fontWeight:  FontWeight.bold,
      ),
      closeIconColor: AppColor.white,
      buttonSingleColor:  Colors.black,
      backgroundColor: AppColor.greyblack.withOpacity(0.9),
      initialDateTime: SelectedDate,
      minDateTime: mindatime,
      //bottomPickerTheme: BottomPickerTheme.orange,

    ).show(context);
  }
  void _openTimePicker(BuildContext context) {
    BottomPicker.time(
      title: pickuptime,
      titleStyle: const TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 15,
        color: Colors.white,
      ),
      onSubmit: (index) {
        print(index);
        SelectedDate = index;

        var outputFormat = DateFormat("HH:mm aa");
        setState(() {
          selectedTimetext = outputFormat.format(SelectedDate);
        });
        updatedtime();
      },
      onClose: () {
        print('Picker closed');
      },
      buttonText:  'Confirm',
      buttonTextStyle:  const  TextStyle(
          color:  Colors.white
      ),
      pickerTextStyle:  const TextStyle(
        color:  Colors.white,
        fontSize:  14,
        fontWeight:  FontWeight.bold,
      ),
      closeIconColor: AppColor.white,
      buttonSingleColor:  Colors.black,
      backgroundColor: AppColor.greyblack.withOpacity(0.9),
      initialDateTime: SelectedDate,
      minDateTime: mindatime,
      //gradientColors: [Color(0xfffdcbf1), Color(0xffe6dee9)],
      use24hFormat: false,
    ).show(context);
  }
  retrieveDistance(String distanceInKm) {
    setState(() {
      distance = distanceInKm;
    });
  }
}
