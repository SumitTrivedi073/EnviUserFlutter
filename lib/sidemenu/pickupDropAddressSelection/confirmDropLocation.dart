import 'package:envi/sidemenu/pickupDropAddressSelection/model/searchPlaceModel.dart';
import 'package:envi/sidemenu/searchDriver/searchDriver.dart';
import 'package:envi/theme/color.dart';
import 'package:envi/theme/images.dart';
import 'package:envi/theme/mapStyle.dart';
import 'package:envi/theme/styles.dart';
import 'package:envi/uiwidget/appbarInside.dart';
import 'package:envi/uiwidget/robotoTextWidget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_place/google_place.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../theme/string.dart';

class ConfirmDropLocation extends StatefulWidget {
  final String title;
  final SearchPlaceModel? location;

  const ConfirmDropLocation({Key? key, required this.title, this.location})
      : super(key: key);

  @override
  State<ConfirmDropLocation> createState() => _ConfirmDropLocationState();
}

class _ConfirmDropLocationState extends State<ConfirmDropLocation> {
  String? toAddressName;
  late LatLng latlong;
  CameraPosition? _cameraPosition;
  GoogleMapController? _controller;
  String Address = PickUp;
  LatLng initialLatLng = LatLng(0, 0);
  bool isFromVerified = false;
  bool isToVerified = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initialLatLng = LatLng(
        widget.location!.latLng!.latitude, widget.location!.latLng!.longitude);
    _cameraPosition = CameraPosition(target: initialLatLng, zoom: 10.0);
    // getCurrentLocation();
    getLocation(initialLatLng);
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
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
          GetAddressFromLatLong(latlong);
        },
        onCameraMove: (CameraPosition position) {
          latlong = LatLng(position.target.latitude, position.target.longitude);
        },
      ),
      Center(
        child: Image.asset(
          Images.destinationMarkerImage,
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
            title: widget.title,
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
                      Images.destinationMarkerImage,
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
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Text(
              moveAroundText,
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
                Navigator.pop(
                    context,
                    SearchPlaceModel(
                        id: '',
                        address: Address,
                        title: toAddressName!,
                        latLng: latlong));
                // Navigator.of(context).pushAndRemoveUntil(
                //     MaterialPageRoute(
                //         builder: (BuildContext context) => SearchDriver(
                //             fromAddress: widget.fromLocation,
                //             toAddress: SearchPlaceModel(
                //               id: '',
                //               title: toAddressName!,
                //               address: Address,
                //               latLng: latlong,
                //             )

                //             // ToAddressLatLong(
                //             //   address: Address,
                //             //   position: latlong,
                //             // ),
                //             )),
                //     (Route<dynamic> route) => true);
              },
              style: ElevatedButton.styleFrom(
                primary: AppColor.greyblack,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12), // <-- Radius
                ),
              ),
              child: robotoTextWidget(
                textval: confirmText,
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
      if (permission != PermissionStatus.granted) getLocation(initialLatLng);
      return;
    }
    getLocation(initialLatLng);
  }

  getLocation(LatLng position) async {
    // Position position = await Geolocator.getCurrentPosition(
    //     desiredAccuracy: LocationAccuracy.high);
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
    toAddressName = place.subLocality?? place.subAdministrativeArea;
    setState(() {
      Address =
          '${place.street}, ${place.subLocality}, ${place.locality}, ${place.postalCode}, ${place.country}';
    });
  }
}
