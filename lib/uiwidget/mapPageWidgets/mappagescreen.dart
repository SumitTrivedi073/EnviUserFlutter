import 'dart:async';
import 'dart:io' show Platform;

import 'package:envi/sidemenu/pickupDropAddressSelection/model/searchPlaceModel.dart';
import 'package:envi/theme/mapStyle.dart';
import 'package:envi/utils/utility.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:google_maps_flutter_android/google_maps_flutter_android.dart';
import 'package:google_maps_flutter_platform_interface/google_maps_flutter_platform_interface.dart';
import '../../theme/string.dart';
import '../frombookschedule.dart';

void main() {
  runApp(MaterialApp(home: MyHomePage()));
}

class MyHomePage extends StatefulWidget {
  @override
  State createState() {
    return MyHomePageState();
  }
}

class MyHomePageState extends State {
  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MyMap(),
    );
  }
}

class MyMap extends StatefulWidget {
  @override
  State createState() {
    return MyMapState();
  }
}

class MyMapState extends State {
  LatLng? latlong = null;
  CameraPosition? _cameraPosition;
  GoogleMapController? _controller;
  String Address = PickUp;
  String placeName = '';
  String? isoId;

  @override
  void initState() {
    super.initState();
    final GoogleMapsFlutterPlatform mapsImplementation =
        GoogleMapsFlutterPlatform.instance;
    if (mapsImplementation is GoogleMapsFlutterAndroid) {
      mapsImplementation.useAndroidViewSurface = true;
    }
    getCurrentLocation();
  }

  @override
  Widget build(BuildContext context) {
    return (latlong != null)
        ? SafeArea(
            child: Stack(
            children: [
              GoogleMap(
                //    mapType: MapType.normal,
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
                onCameraIdle: () async {
                  Timer(const Duration(seconds: 1), () async {
                   await GetAddressFromLatLong(latlong!);
                  });
                },
                onCameraMove: (CameraPosition position) {
                  latlong = LatLng(
                      position.target.latitude, position.target.longitude);
                },
              ),
              Center(
                  child: SvgPicture.asset(
                "assets/svg/from-location-img.svg",
                width: 20,
                height: 20,
              )),
              Align(
                alignment: Alignment.bottomRight,
                child: Container(
                  margin: EdgeInsets.only(bottom: 140),
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
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  child: (Address == PickUp)
                      ? Container()
                      : FromBookScheduleWidget(
                          address: Address,
                          currentLocation: SearchPlaceModel(
                              address: Address,
                              id: isoId ?? '',
                              title: placeName,
                              latLng: latlong!,
                              isFavourite: 'N'),
                        ),
                ),
              )
            ],
          ))
        : Container();
  }

  Future getCurrentLocation() async {
    if (Platform.isAndroid) {
      var permission = Permission.locationWhenInUse.status;
      if (permission != PermissionStatus.granted) {
        final status = await Permission.location.request();
        if (status != PermissionStatus.granted) {
          showToast("You need location permission for use this App");
          return;
        }
      }
    }

    if (Platform.isIOS) {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission != PermissionStatus.granted) {
        LocationPermission permission = await Geolocator.requestPermission();
        if (permission != PermissionStatus.granted) getLocation();
        return;
      }
    }
    getLocation();
  }

  getLocation() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    if(mounted) {
      setState(() {
        latlong = LatLng(position.latitude, position.longitude);
        _cameraPosition = CameraPosition(
          bearing: 0,
          target: LatLng(position.latitude, position.longitude),
          zoom: 15.0,
        );
        if (_controller != null) {
          _controller
              ?.animateCamera(CameraUpdate.newCameraPosition(_cameraPosition!));
        }
        GetAddressFromLatLong(latlong!);
      });
    }
  }

  Future<void> GetAddressFromLatLong(LatLng position) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
          position.latitude, position.longitude,
          localeIdentifier: 'en');
      Placemark place = placemarks[0];
      placeName = (place.subLocality != '')
          ? place.subLocality!
          : place.subAdministrativeArea!;
      isoId = place.isoCountryCode;
      if(mounted) {
        setState(() {
          Address = '${place.street}, ${place.subLocality}, ${place.locality}';
          Address = formatAddress(Address);
        });
      }
      print(
          "RAGHUVTPLACE ${place.postalCode} ${place.name} ${place.administrativeArea}");
    } catch (e) {
      print("Exception==========>${e.toString()}");
   //   showToast('Unable to retrieve location , please try later');

      //showToast(e.toString());
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    if (_controller != null) {
      _controller!.dispose();
    }
    super.dispose();
  }
}
//https://rrtutors.com/tutorials/Show-Current-Location-On-Maps-Flutter-Fetch-Current-Location-Address
//https://stackoverflow.com/questions/52591556/custom-markers-with-flutter-google-maps-plugin
