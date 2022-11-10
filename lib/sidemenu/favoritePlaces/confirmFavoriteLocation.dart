import 'package:envi/theme/color.dart';
import 'package:envi/theme/mapStyle.dart';
import 'package:envi/theme/styles.dart';
import 'package:envi/uiwidget/appbarInside.dart';
import 'package:envi/uiwidget/robotoTextWidget.dart';
import 'package:envi/utils/utility.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../theme/string.dart';
import '../pickupDropAddressSelection/model/toAddressModel.dart';

class ConfirmFavoriteLocation extends StatefulWidget {
  final String fromLocation;
  final void Function(String, double, double) onCriteriaChanged;
  final double lat, lng;
  const ConfirmFavoriteLocation(
      {Key? key,
      required this.fromLocation,
      required this.lat,
      required this.lng,
      required this.onCriteriaChanged})
      : super(key: key);

  @override
  State<ConfirmFavoriteLocation> createState() =>
      _ConfirmFavoriteLocationState();
}

class _ConfirmFavoriteLocationState extends State<ConfirmFavoriteLocation> {
  LatLng? latlong = const LatLng(0, 0);
  CameraPosition? _cameraPosition;
  GoogleMapController? _controller;
  String Address = PickUp;
  ToAddressLatLong? toAddress;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 1), LoadMap);
    print("========${widget.lat}${widget.lng}");
    _cameraPosition =
        CameraPosition(target: LatLng(widget.lat, widget.lng), zoom: 10.0);
    // getCurrentLocation();
  }

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  void LoadMap() async {
    print("========${widget.lat},${widget.lng}");
    setState(() {
      _cameraPosition = CameraPosition(
        bearing: 0,
        target: LatLng(widget.lat, widget.lng),
        zoom: 14.0,
      );
      // _cameraPosition =  CameraPosition(target: LatLng(double.parse(widget.lat),double.parse( widget.lng)), zoom: 10.0);
      if (_controller != null) {
        _controller
            ?.animateCamera(CameraUpdate.newCameraPosition(_cameraPosition!));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Stack(children: [
      GoogleMap(
        mapType: MapType.normal,
        initialCameraPosition: _cameraPosition!,
        onMapCreated: (GoogleMapController controller) {
          controller.setMapStyle(MapStyle.mapStyles);
          _controller = (controller);

          _controller
              ?.animateCamera(CameraUpdate.newCameraPosition(_cameraPosition!));
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
          latlong = LatLng(position.target.latitude, position.target.longitude);
        },
      ),
      Center(
        child: Image.asset(
          "assets/images/destination-marker.png",
          scale: 2,
        ),
      ),
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
            pagetitle: ConfirmLocation,
            isBackButtonNeeded: true,
          ),
          Card(
            margin: EdgeInsets.only(left: 10, right: 10, top: 5),
            color: Colors.white,
            elevation: 4,
            child: Container(
                padding: const EdgeInsets.all(5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Image.asset(
                      "assets/images/destination-marker.png",
                      scale: 2,
                      fit: BoxFit.none,
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
                          sizeval: 14,
                          fontWeight: FontWeight.w200,
                        ),
                      ),
                    ])),
                    const SizedBox(
                      width: 5,
                    ),
                    Align(
                        alignment: Alignment.centerRight,
                        child: Container(
                          padding: const EdgeInsets.all(5),
                          color: AppColor.white,
                          child: const Icon(
                            Icons.keyboard_alt_outlined,
                            color: AppColor.grey,
                            size: 20,
                          ),
                        ))
                  ],
                )),
          ),
          const SizedBox(
            height: 10,
          ),
          const Padding(
            padding: EdgeInsets.all(20.0),
            child: Text(
              'Move around',
              style: AppTextStyle.robotoRegular16,
              maxLines: 2,
              textAlign: TextAlign.center,
            ),
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
                widget.onCriteriaChanged(
                    Address, latlong!.latitude, latlong!.longitude);
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                primary: AppColor.greyblack,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12), // <-- Radius
                ),
              ),
              child: robotoTextWidget(
                textval: continue1,
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
    Placemark place = placemarks[0];
   if(mounted){
     setState(() {
       Address = formatAddress('${place.street}, ${place.subLocality}, ${place.locality}');
     });
   }
  }
}
