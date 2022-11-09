import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import '../../provider/firestoreLiveTripDataNotifier.dart';
import '../../theme/mapStyle.dart';
import '../../uiwidget/appbarInside.dart';
import '../../uiwidget/confirmDriverPopup.dart';
import '../../web_service/Constant.dart';
import '../pickupDropAddressSelection/model/searchPlaceModel.dart';
import '../waitingForDriverScreen/waitingForDriverScreen.dart';
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



  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }


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
    return Consumer<firestoreLiveTripDataNotifier>(
        builder: (context, value, child)
    {
      //If this was not given, it was throwing error like setState is called during build . RAGHU VT
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted && value.liveTripData != null) {
          if (value.liveTripData!.tripInfo!.tripStatus == TripStatusRequest ||
              value.liveTripData!.tripInfo!.tripStatus == TripStatusAlloted ||
              value.liveTripData!.tripInfo!.tripStatus == TripStatusArrived) {
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(
                    builder: (BuildContext context) =>
                        WaitingForDriverScreen()),
                    (Route<dynamic> route) => false);
          }
        }
      });
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
              scrollGesturesEnabled: false,
              tiltGesturesEnabled: false,
              rotateGesturesEnabled: false,
              zoomControlsEnabled: false,
            )
                : Container(),

            Column(children: const [
              AppBarInsideWidget(
                pagetitle: "Booking Confirmation",
                isBackButtonNeeded: true,
              ),
              SizedBox(height: 5),
            ]),
            /*Container(
              color: Color(0xFFB0000000),
            ),
           */ Align(
                alignment: Alignment.center,
                child: SizedBox(
                  child: ConfirmDriverPopup(
                    driverDetail: widget.driverDetail,
                    priceDetail: widget.priceDetail,
                    fromAddress: widget.fromAddress,
                    toAddress: widget.toAddress,

                  ),
                )
            ),
          ]));
    });
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
