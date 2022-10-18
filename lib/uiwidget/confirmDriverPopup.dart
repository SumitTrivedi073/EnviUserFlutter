import 'package:envi/sidemenu/searchDriver/model/driverListModel.dart' as DriverListModel;
import 'package:envi/sidemenu/searchDriver/model/userTripModel.dart';
import 'package:envi/sidemenu/waitingForDriverScreen/waitingForDriverScreen.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../../web_service/HTTP.dart' as HTTP;
import '../../appConfig/Profiledata.dart';
import '../../theme/color.dart';
import '../../theme/mapStyle.dart';
import '../../theme/string.dart';
import '../../uiwidget/appbarInside.dart';
import '../../uiwidget/robotoTextWidget.dart';
import '../../web_service/APIDirectory.dart';
import '../sidemenu/home/homePage.dart';
import '../sidemenu/pickupDropAddressSelection/model/searchPlaceModel.dart';

class ConfirmDriverPopup extends StatefulWidget {
  final SearchPlaceModel? fromAddress;
  final SearchPlaceModel? toAddress;

  final DriverListModel.Content? driverDetail;
  final DriverListModel.VehiclePriceClass? priceDetail;

  const ConfirmDriverPopup(
      {Key? key,
        this.driverDetail,
        this.priceDetail,
        this.toAddress,
        this.fromAddress})
      : super(key: key);


  @override
  State<StatefulWidget> createState() => _AppBarPageState();
}

class _AppBarPageState extends State<ConfirmDriverPopup> {
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return  Container(
        height: 350,
        margin: const EdgeInsets.only(left: 20,right: 20),
        child: Card(
          elevation: 5,
          color: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(children: [
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
                  color: AppColor.border,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.only(top: 5, bottom: 5),
                child: Column(
                  children: [
                    robotoTextWidget(
                        textval:
                        widget.driverDetail!.priceClass!.type.toString(),
                        colorval: AppColor.black,
                        sizeval: 14,
                        fontWeight: FontWeight.w200),
                    const SizedBox(
                      height: 10,
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
                                "${widget.driverDetail!.priceClass!.passengerCapacity} People",
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
                                textval: widget
                                    .driverDetail!.priceClass!.bootSpace
                                    .toString(),
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
            const SizedBox(
              height: 10,
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
                    Container(
                      margin: const EdgeInsets.only(left: 10),
                      padding: const EdgeInsets.only(top: 5, bottom: 5),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          robotoTextWidget(
                              textval:
                              "₹${widget.priceDetail!.priceClass.totalFare!.toStringAsFixed(0)}",
                              colorval: AppColor.black,
                              sizeval: 16,
                              fontWeight: FontWeight.w800),
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
                      width: 1,
                      color: AppColor.border,
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
                                '${widget.driverDetail!.durationToPickUpLocation} Mins',
                                colorval: AppColor.black,
                                sizeval: 16,
                                fontWeight: FontWeight.w800),
                            const robotoTextWidget(
                                textval: "Pickup Time",
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
            const Text(
              "To address",
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
                  color: AppColor.border,
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
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                    height: 40,
                    width: 120,
                    margin: const EdgeInsets.all(5),
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(
                                builder: (BuildContext context) =>
                                const HomePage(title: "title")),
                                (Route<dynamic> route) => false);
                      },
                      style: ElevatedButton.styleFrom(
                        primary: AppColor.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12), // <-- Radius
                        ),
                      ),
                      child: robotoTextWidget(
                        textval: cancel,
                        colorval: AppColor.greyblack,
                        sizeval: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    )),
                const SizedBox(
                  width: 10,
                ),
                Container(
                  height: 40,
                  width: 120,
                  margin: const EdgeInsets.all(5),
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: AppColor.greyblack,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12), // <-- Radius
                        ),
                      ),
                    onPressed: () async {
                      setState(() {
                        isLoading = true;
                        confirmBooking();
                      });

                    },
                    child: isLoading
                        ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 1.5,
                        ))
                        :   robotoTextWidget(
                      textval: confirm,
                      colorval: AppColor.white,
                      sizeval: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),),
              ],
            )
          ]),
        ));
  }


  Future<void> confirmBooking() async {
    Map data;
    data = {
      "driverTripMasterId": widget.driverDetail!.driverTripMasterId,
      "userId": Profiledata().getusreid(),
      "vehicleId": widget.driverDetail!.vehicleId.toString(),
      "driverId": widget.driverDetail!.driverId,
      "location": {
        "latitude": widget.fromAddress!.latLng.latitude.toDouble(),
        "longitude": widget.fromAddress!.latLng.longitude.toDouble(),
        "address": widget.fromAddress!.address
      },
      "toLocation": {
        "latitude": widget.toAddress!.latLng.latitude.toDouble(),
        "longitude": widget.toAddress!.latLng.longitude.toDouble(),
        "address": widget.toAddress!.address
      },
      "paymentMode": "null",
      "driverName": widget.driverDetail!.driverName,
      "driverRating": widget.driverDetail!.driverRating!.toDouble(),
      "driverPhoto": widget.driverDetail!.driverPhoto!.toString(),
      "initialPrice": widget.priceDetail!.priceClass.totalFare!.toDouble(),
      "initialDistance": widget.priceDetail!.priceClass.distance!.toDouble()
    };
    print("data=======>$data");
    setState(() {
      isLoading = true;
    });
    dynamic res = await HTTP.post(startTrip(), data);
    if (res != null && res.statusCode != null && res.statusCode == 200) {
      setState(() {
        isLoading = false;

      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
              builder: (BuildContext context) => WaitingForDriverScreen()),
              (Route<dynamic> route) => false);
      });
    } else {
      throw "Driver Not Booked";
    }
  }
}
