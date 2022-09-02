import 'package:envi/sidemenu/searchDriver/searchDriver.dart';
import 'package:envi/theme/color.dart';
import 'package:envi/theme/mapStyle.dart';
import 'package:envi/uiwidget/appbarInside.dart';
import 'package:envi/uiwidget/robotoTextWidget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../theme/string.dart';

class ConfirmDropLocation extends StatefulWidget {
  final String title;

  const ConfirmDropLocation({Key? key, required this.title}) : super(key: key);

  @override
  State createState() {
    // TODO: implement createState
    return ConfirmDropLocationState(title);
  }
}

class ConfirmDropLocationState extends State {
  LatLng? latlong = null;
  CameraPosition? _cameraPosition;
  GoogleMapController? _controller;
  String Address = PickUp;
  String title;

  ConfirmDropLocationState(this.title);

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
    return SafeArea(
        child: Stack(children: [
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
              zoomGesturesEnabled: true,
              rotateGesturesEnabled: true,
              zoomControlsEnabled: false,
              onCameraIdle: () {
                GetAddressFromLatLong(latlong!);
              },
              onCameraMove: (CameraPosition position) {
                latlong =
                    LatLng(position.target.latitude, position.target.longitude);
              },
            )
          : Container(),
      Center(
          child: SvgPicture.asset(
        "assets/svg/from-location-img.svg",
        width: 20,
        height: 20,
      )),
      Align(
        alignment: Alignment.bottomRight,
        child: Container(
          margin: const EdgeInsets.only(bottom: 40),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: FloatingActionButton(
              // isExtended: true,
              child: const Icon(Icons.my_location_outlined),
              backgroundColor: Colors.green,
              onPressed: () {
                setState(() {
                  getCurrentLocation();
                });
              },
            ),
          ),
        ),
      ),
      Column(
        children: [
          AppBarInsideWidget(
            title: title,
          ),
          Card(
            margin: EdgeInsets.only(left: 10, right: 10, top: 5),
            color: Colors.white,
            elevation: 4,
            child: Container(
                padding: const EdgeInsets.all(10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SvgPicture.asset(
                      "assets/svg/to-location-img.svg",
                      width: 20,
                      height: 20,
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    Flexible(
                        child: Wrap(children: [
                      Container(
                        padding: const EdgeInsets.all(5),
                        child: robotoTextWidget(
                          textval: Address,
                          colorval: AppColor.black,
                          sizeval: 18,
                          fontWeight: FontWeight.w200,
                        ),
                      ),
                    ])),
                    const SizedBox(
                      width: 5,
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: SvgPicture.asset(
                        "assets/svg/to-location-img.svg",
                        width: 40,
                        height: 30,
                      ),
                    )
                  ],
                )),
          ),
          robotoTextWidget(
            textval: Address,
            colorval: AppColor.black,
            sizeval: 18,
            fontWeight: FontWeight.w200,
          ),
        ],
      ),
      Align(
        alignment: Alignment.bottomCenter,
        child: Container(
            height: 40,
            margin: const EdgeInsets.all(5),
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(
                        builder: (BuildContext context) =>
                         SearchDriver()),
                        (Route<dynamic> route) => true);

              },
              style: ElevatedButton.styleFrom(
                primary: AppColor.greyblack,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12), // <-- Radius
                ),
              ),
              child: const robotoTextWidget(
                textval: 'CONTINUE',
                colorval: AppColor.white,
                sizeval: 14,
                fontWeight: FontWeight.w600,
              ),
            )),
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
      if (_controller != null) {
        _controller
            ?.animateCamera(CameraUpdate.newCameraPosition(_cameraPosition!));
      }
    });
  }

  Future<void> GetAddressFromLatLong(LatLng position) async {
    List<Placemark> placemarks =
        await placemarkFromCoordinates(position.latitude, position.longitude);
    print(placemarks);
    Placemark place = placemarks[0];
    setState(() {
      Address =
          '${place.street}, ${place.subLocality}, ${place.locality}, ${place.postalCode}, ${place.country}';
    });
  }
}