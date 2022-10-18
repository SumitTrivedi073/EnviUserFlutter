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
import '../../uiwidget/confirmDriverPopup.dart';
import '../../uiwidget/robotoTextWidget.dart';
import '../../web_service/APIDirectory.dart';
import '../home/homePage.dart';
import '../pickupDropAddressSelection/model/searchPlaceModel.dart';
import 'model/driverListModel.dart' as DriverListModel;

class ConfirmDriver extends StatefulWidget {
  final SearchPlaceModel? fromAddress;
  final SearchPlaceModel? toAddress;

  final DriverListModel.Content? driverDetail;
  final DriverListModel.VehiclePriceClass? priceDetail;

  const ConfirmDriver(
      {Key? key,
      this.driverDetail,
      this.priceDetail,
      this.toAddress,
      this.fromAddress})
      : super(key: key);

  @override
  // TODO: implement createState
  State<StatefulWidget> createState() => _ConfirmDriverPageState();
}

class _ConfirmDriverPageState extends State<ConfirmDriver> {
  LatLng? latlong = null;
  CameraPosition? _cameraPosition;
  GoogleMapController? _controller;
  late UserTripModel userTripModel;


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
              rotateGesturesEnabled: false,
              zoomControlsEnabled: false,
            )
          : Container(),

      Column(children: const [
        AppBarInsideWidget(
          title: "Booking Confirmation",
          isBackButtonNeeded: true,
        ),
        SizedBox(height: 5),
      ]),
          Container(
            color: Color(0xFFB0000000),
          ),
          Align(
              alignment: Alignment.center,
              child:SizedBox(
                child: ConfirmDriverPopup(
                  driverDetail: widget.driverDetail,
                  priceDetail: widget.priceDetail,
                  fromAddress: widget.fromAddress,
                  toAddress: widget.toAddress,

                ),
              )
          ),
    ]));
  }


  Future getCurrentLocation() async {
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

  }

}
