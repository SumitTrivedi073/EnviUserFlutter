import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../web_service/HTTP.dart' as HTTP;
import '../../theme/color.dart';
import '../../theme/mapStyle.dart';
import '../../theme/string.dart';
import '../../uiwidget/appbarInside.dart';
import '../../uiwidget/robotoTextWidget.dart';
import '../../web_service/APIDirectory.dart';
import '../home/homePage.dart';
import '../pickupDropAddressSelection/model/searchPlaceModel.dart';
import 'model/driverListModel.dart';

class ConfirmDriver extends StatefulWidget {
  final SearchPlaceModel? fromAddress;
  final SearchPlaceModel? toAddress;

  final Content? driverDetail;
  final VehiclePriceClass? priceDetail;

  const ConfirmDriver({Key? key, this.driverDetail, this.priceDetail,this.toAddress, this.fromAddress})
      : super(key: key);

  @override
  // TODO: implement createState
  State<StatefulWidget> createState() => _ConfirmDriverPageState();
}

class _ConfirmDriverPageState extends State<ConfirmDriver> {
  LatLng? latlong = null;
  CameraPosition? _cameraPosition;
  GoogleMapController? _controller;
  late SharedPreferences sharedPreferences;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _cameraPosition = const CameraPosition(target: LatLng(0, 0), zoom: 10.0);
    getCurrentLocation();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        body: Stack(alignment: Alignment.centerRight, children: <Widget>[
      (latlong != null)
          ? GoogleMap(
              mapType: MapType.normal,
              initialCameraPosition: _cameraPosition!,
              onMapCreated: (GoogleMapController controller) {
                controller.setMapStyle(MapStyle.mapStyles);
                _controller = (controller);

                _controller?.animateCamera(
                    CameraUpdate.newCameraPosition(_cameraPosition!));
              },
              myLocationEnabled: true,
              myLocationButtonEnabled: false,
              mapToolbarEnabled: false,
              zoomGesturesEnabled: false,
              rotateGesturesEnabled: true,
              zoomControlsEnabled: false,
            )
          : Container(),
      Column(children: const [
        AppBarInsideWidget(title: "Booking Confirmation"),
        SizedBox(height: 5),
      ])
    ]));
  }

  Widget _buildPopupDialog(BuildContext context) {
    return AlertDialog(
      content: Container(
          height: 340,
          child: Column(children: [
            const Padding(
              padding: EdgeInsets.only(top: 5),
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
              child: Padding(padding: const EdgeInsets.only(top: 5,bottom: 5),
                child: Column(
                  children: [
                     robotoTextWidget(
                        textval: widget.driverDetail!.priceClass!.type.toString(),
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
                                textval: "${widget.driverDetail!.priceClass!.passengerCapacity} People",
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
                                textval:widget.driverDetail!.priceClass!.bootSpace.toString(),
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
                      padding: const EdgeInsets.only(top: 5,bottom: 5),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children:  [
                          robotoTextWidget(
                              textval:"₹${widget.priceDetail!.priceClass.totalFare.toString()}",
                              colorval: AppColor.black,
                              sizeval: 16,
                              fontWeight: FontWeight.w800),

                          const robotoTextWidget(
                              textval: "Approx. Fare",
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

                  padding: const EdgeInsets.only(top: 5,bottom: 5),
                child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children:  [
                        robotoTextWidget(
                            textval: '${widget.driverDetail!.durationToPickUpLocation} Mins',
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
            const SizedBox(
                height: 10
            ),
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
              padding: const EdgeInsets.all(10) ,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const robotoTextWidget(
                        textval: "Place Name",
                        colorval: AppColor.black,
                        sizeval: 14,
                        fontWeight: FontWeight.w200),
                    const SizedBox(
                      height: 5,
                    ),
                    robotoTextWidget(
                        textval:  widget.toAddress!.address.toString(),
                        colorval: AppColor.black,
                        sizeval: 12,
                        fontWeight: FontWeight.w200),
                  ],
                ),
            ),),
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
                        Navigator.of(context).pop();
                        Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(
                                builder: (BuildContext context) => const HomePage(title: "title")),
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
                Container(
                  height: 40,
                    width: 120,
                    margin: const EdgeInsets.all(5),
                    child: ElevatedButton(
                      onPressed: () {
                        /*Navigator.of(context).pop();
                        Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(
                                builder: (BuildContext context) => const HomePage(title: "title")),
                                (Route<dynamic> route) => false);*/
                        confirmBooking();
                      },
                      style: ElevatedButton.styleFrom(
                        primary: AppColor.greyblack,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12), // <-- Radius
                        ),
                      ),
                      child: robotoTextWidget(
                        textval: confirm,
                        colorval: AppColor.white,
                        sizeval: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    )),
              ],
            )
          ])),

    );
  }

  Future getCurrentLocation() async {
    sharedPreferences = await SharedPreferences.getInstance();
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission != PermissionStatus.granted) {
      LocationPermission permission = await Geolocator.requestPermission();
      if (permission != PermissionStatus.granted) getLocation();
      return;
    }
    getLocation();
  }

  getLocation() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    setState(() {
      latlong = LatLng(position.latitude, position.longitude);
      _cameraPosition = CameraPosition(
        bearing: 0,
        target: LatLng(position.latitude, position.longitude),
        zoom: 14.0,
      );
    });
    showDialog(
      context: context,
      builder: (BuildContext context) => _buildPopupDialog(context),
    );
  }

  Future<void> confirmBooking() async {
    Map data;
    data = {
      "driverId": widget.driverDetail!.driverId,
      "fromLat": widget.fromAddress!.latLng!.latitude,
      "fromLng": widget.fromAddress!.latLng!.longitude,
      "toLat": widget.toAddress!.latLng!.latitude,
      "toLng": widget.fromAddress!.latLng!.longitude,
      "fromAddress": widget.fromAddress!.address,
      "toAddress": widget.toAddress!.address,
      "initialDistance": widget.priceDetail!.priceClass.distance,
      "initialPrice": widget.priceDetail!.priceClass.totalFare,
    };

    print("data=======>$data");
    dynamic res = await HTTP.post(startTrip(), data);
    if (res != null && res.statusCode != null && res.statusCode == 200) {

      setState(() {

      });
      print("res==============>${res.body}");
    } else {
      throw "Can't get DriverList.";
    }
  }
}
