// ignore_for_file: unnecessary_new

import 'dart:async';
import 'dart:convert';

import 'package:envi/appConfig/appConfig.dart';
import 'package:envi/sidemenu/pickupDropAddressSelection/model/searchPlaceModel.dart';
import 'package:envi/sidemenu/searchDriver/searchDriver.dart';
import 'package:envi/theme/color.dart';
import 'package:envi/theme/images.dart';
import 'package:envi/theme/mapStyle.dart';
import 'package:envi/theme/theme.dart';
import 'package:envi/uiwidget/appbarInside.dart';
import 'package:envi/uiwidget/robotoTextWidget.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../appConfig/Profiledata.dart';
import '../../database/database.dart';
import '../../database/favoritesData.dart';
import '../../database/favoritesDataDao.dart';
import '../../enum/BookingTiming.dart';
import '../../theme/string.dart';
import '../../utils/utility.dart';
import '../../web_service/ApiCollection.dart';
import '../bookScheduleTrip/bookScheduleTrip.dart';

class ConfirmDropLocation extends StatefulWidget {
  final String title;
  final SearchPlaceModel? endLocation;
  final SearchPlaceModel? startLocation;
  final AddressConfirmation status;
  final String isFavourite;
  final BookingTiming tripType;

  const ConfirmDropLocation(
      {Key? key,
      required this.title,
      required this.isFavourite,
      required this.endLocation,
      required this.status,
      required this.startLocation,
      required this.tripType})
      : super(key: key);

  @override
  State<ConfirmDropLocation> createState() => _ConfirmDropLocationState();
}

class _ConfirmDropLocationState extends State<ConfirmDropLocation> {
  late final SearchPlaceModel? locationToSearch;
  late final FavoritesDataDao? dao;
  final GlobalKey<ScaffoldState> _confirmDropScaffoldKey =
      new GlobalKey<ScaffoldState>();
  String? toAddressName;
  late LatLng latlong;
  CameraPosition? _cameraPosition;
  GoogleMapController? _controller;
  String Address = 'Select Location';
  LatLng initialLatLng = const LatLng(0, 0);
  bool moveMarkerAnimate = true;

  late String isFavourite;

  void checkAddressStatus() {
    if (widget.status == AddressConfirmation.fromAddressConfirmed) {
      locationToSearch = widget.endLocation;
    } else if (widget.status == AddressConfirmation.toAddressConfirmed) {
      locationToSearch = widget.startLocation;
    } else {
      (widget.startLocation == null)
          ? locationToSearch = widget.endLocation
          : locationToSearch = widget.startLocation;
    }
  }

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  Future<void> apiCallAddFavorite(SearchPlaceModel? addressToAdd) async {
    dynamic userid = Profiledata().getusreid();

    final response = await ApiCollection.FavoriateDataAdd(
        userid,
        addressToAdd!.title,
        addressToAdd.address,
        addressToAdd.latLng.latitude,
        addressToAdd.latLng.longitude,
        addressToAdd.isFavourite);

    if (response != null) {
      if (response.statusCode == 200) {
        String addressId = jsonDecode(response.body)['content']['addressId'];
        print(jsonDecode(response.body)['content']);

        final task = FavoritesData.optional(
            identifier: addressId,
            address: addressToAdd.address,
            isFavourite: addressToAdd.isFavourite,
            latitude: addressToAdd.latLng.latitude.toString(),
            longitude: addressToAdd.latLng.longitude.toString(),
            title: addressToAdd.title);
        await dao!.insertTask(task);
      }
      // showToast((jsonDecode(response.body)['message'].toString()));
    }
  }

  Future<void> apiCallUpdateFavorite(
      int? Id,
      String titel,
      SearchPlaceModel? addressToUpdate,
      String identifire,
      String favoriate) async {
    dynamic userid = Profiledata().getusreid();

    final response = await ApiCollection.FavoriateDataUpdate(
        userid,
        titel,
        addressToUpdate!.address,
        addressToUpdate.latLng.latitude,
        addressToUpdate.latLng.longitude,
        favoriate,
        identifire);
    print("update" + response.body);

    if (response != null) {
      if (response.statusCode == 200) {
        String addressId = jsonDecode(response.body)['content']['addressId'];
        print(jsonDecode(response.body)['content']);

        final task = FavoritesData.optional(
            id: Id,
            identifier: identifire,
            address: addressToUpdate.address,
            isFavourite: favoriate,
            latitude: addressToUpdate.latLng.latitude.toString(),
            longitude: addressToUpdate.latLng.longitude.toString(),
            title: titel);
        print(task);
        await dao!.updateTask(task);
        //Navigator.pop(context, {"isbact": true});
      }
      // showToast((jsonDecode(response.body)['message'].toString()));
    }
  }

  Future<void> apiCallAddFavoritetoaddress(
      SearchPlaceModel? addressToAdd) async {
    dynamic userid = Profiledata().getusreid();

    final response = await ApiCollection.FavoriateDataAdd(
        userid,
        addressToAdd!.title,
        addressToAdd.address,
        addressToAdd.latLng.latitude,
        addressToAdd.latLng.longitude,
        addressToAdd.isFavourite);

    if (response != null) {
      if (response.statusCode == 200) {
        String addressId = jsonDecode(response.body)['content']['addressId'];
        print(jsonDecode(response.body)['content']);

        final task = FavoritesData.optional(
            identifier: addressId,
            address: addressToAdd.address,
            isFavourite: addressToAdd.isFavourite,
            latitude: addressToAdd.latLng.latitude.toString(),
            longitude: addressToAdd.latLng.longitude.toString(),
            title: addressToAdd.title);
        print(task);
        await dao!.insertTask(task);
        //Navigator.pop(context, {"isbact": true});
      }
      //showToast((jsonDecode(response.body)['message'].toString()));
    }
  }

  Future<void> apiCallUpdateFavoritetoaddress(
      int? Id,
      String titel,
      SearchPlaceModel? addressToUpdate,
      String identifire,
      String favoriate) async {
    dynamic userid = Profiledata().getusreid();

    final response = await ApiCollection.FavoriateDataUpdate(
        userid,
        titel,
        addressToUpdate!.address,
        addressToUpdate.latLng.latitude,
        addressToUpdate.latLng.longitude,
        favoriate,
        identifire);
    print("update" + response.body);

    if (response != null) {
      if (response.statusCode == 200) {
        String addressId = jsonDecode(response.body)['content']['addressId'];
        print(jsonDecode(response.body)['content']);

        final task = FavoritesData.optional(
            id: Id,
            identifier: identifire,
            address: addressToUpdate.address,
            isFavourite: favoriate,
            latitude: addressToUpdate.latLng.latitude.toString(),
            longitude: addressToUpdate.latLng.longitude.toString(),
            title: titel);
        print(task);
        await dao!.updateTask(task);
      }
      // showToast((jsonDecode(response.body)['message'].toString()));
    }
  }

  void localDbModifications(
      SearchPlaceModel startLocation, SearchPlaceModel endLocation) async {
    var detail = await dao?.findDataByaddressg(startLocation.address);
    if (detail == null) {
      apiCallAddFavorite(startLocation);
    } else {
      apiCallUpdateFavorite(detail.id, detail.title, startLocation,
          detail.identifier, detail.isFavourite);
    }
    var toDetail = await dao?.findDataByaddressg(endLocation.address);
    if (startLocation.address != endLocation.address) {
      if (toDetail == null) {
        apiCallAddFavoritetoaddress(endLocation);
      } else {
        apiCallUpdateFavoritetoaddress(toDetail.id, toDetail.title,
            widget.endLocation, toDetail.identifier, toDetail.isFavourite);
      }
    }
  }

  void showInSnackBar(String value, context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(value),
        duration: const Duration(milliseconds: 3000),
      ),
    );
  }

  Future<void> loadData() async {
    final database =
        await $FloorFlutterDatabase.databaseBuilder('envi_user.db').build();
    dao = database.taskDao;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkAddressStatus();
    loadData();

    initialLatLng = LatLng(
        locationToSearch!.latLng.latitude, locationToSearch!.latLng.longitude);
    _cameraPosition = CameraPosition(target: initialLatLng, zoom: 10.0);
    // getCurrentLocation();
    isFavourite = widget.isFavourite;
    getLocation(initialLatLng);

    var counter = 10;
    Timer.periodic(const Duration(milliseconds: 500), (timer) {
      setState(() {
        moveMarkerAnimate = !moveMarkerAnimate;
      });

      counter--;
      if (counter == 0) {
        moveMarkerAnimate = false;
        timer.cancel();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return SafeArea(
        child: Scaffold(
      key: _confirmDropScaffoldKey,
      body: Stack(children: [
        GoogleMap(
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
            Timer(const Duration(seconds: 1), () {
              GetAddressFromLatLong(latlong, context);
            });
          },
          onCameraMove: (CameraPosition position) {
            latlong =
                LatLng(position.target.latitude, position.target.longitude);
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
                backgroundColor: Colors.green,
                onPressed: () {
                  setState(() {
                    getCurrentLocation();
                  });
                },
                // isExtended: true,
                child: const Icon(Icons.my_location_outlined),
              ),
            ),
          ),
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            AppBarInsideWidget(
              pagetitle: widget.title,
              isBackButtonNeeded: true,
              customMargin: const EdgeInsets.fromLTRB(10, 10, 10, 10),
            ),
            Card(
              margin: const EdgeInsets.only(left: 10, right: 10, top: 5),
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
                            fontWeight: FontWeight.w600,
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
            if (moveMarkerAnimate)
              Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Text(moveText,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        background: Paint()
                          ..color = Color.fromARGB(255, 163, 235, 211)
                          ..strokeWidth = 20
                          ..strokeJoin = StrokeJoin.round
                          ..strokeCap = StrokeCap.round
                          ..style = PaintingStyle.stroke,
                        color: Colors.black,
                      )))
          ],
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Row(
            children: [
              Expanded(
                child: Container(
                    margin: const EdgeInsets.all(5),
                    child: ElevatedButton(
                      onPressed: () {
                        confirmLocation();
                      },
                      style: ElevatedButton.styleFrom(
                        primary: AppColor.greyblack,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5), // <-- Radius
                        ),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(15),
                        child: robotoTextWidget(
                          textval: confirmText,
                          colorval: AppColor.white,
                          sizeval: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    )),
              ),
            ],
          ),
        ),
      ]),
    ));
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

  @override
  void dispose() {
    if (_controller != null) {
      _controller!.dispose();
    }
    super.dispose();
  }

  Future<void> GetAddressFromLatLong(LatLng position, context) async {
    List<Placemark>? placemarks;
    try {
      placemarks =
          await placemarkFromCoordinates(position.latitude, position.longitude);
    } catch (e) {
      await Future.delayed(const Duration(milliseconds: 300));
      try {
        placemarks = await placemarkFromCoordinates(
            position.latitude, position.longitude);
      } catch (e) {
        if (!mounted) return;
        showInSnackBar(
            'Unable to retrieve location , please try later', context);
        await Future.delayed(const Duration(seconds: 4), () {
          Navigator.of(context).pop();
        });
        // ignore: use_build_context_synchronously

      }
    }
    Placemark place;
    //print(placemarks);
    if (placemarks != null) {
      place = placemarks[0];
      setState(() {
        toAddressName = (place.subLocality != '')
            ? place.subLocality
            : place.subAdministrativeArea;
        Address = '${place.street}, ${place.subLocality}, ${place.locality}';
      });
    }
  }

  void confirmLocation() {
    if (Address != 'Select Location') {
      if (widget.status == AddressConfirmation.bothUnconfirmed) {
        List<SearchPlaceModel> att = [];
        att.add(SearchPlaceModel(
          id: '',
          address: Address,
          title: toAddressName ?? '',
          latLng: latlong,
          isFavourite: isFavourite,
        ));
        Navigator.pop(context, att);
      } else {
        if (widget.status == AddressConfirmation.fromAddressConfirmed) {
          if (widget.startLocation!.latLng.latitude != 0.0 &&
              widget.startLocation!.latLng.longitude != 0.0 &&
              widget.endLocation!.latLng.latitude != 0.0 &&
              widget.endLocation!.latLng.longitude != 0.0) {
            if (calculateDistance(
                    widget.startLocation!.latLng.latitude,
                    widget.startLocation!.latLng.longitude,
                    widget.endLocation!.latLng.latitude,
                    widget.endLocation!.latLng.longitude) <
                AppConfig.maxAllowedDistance) {
              localDbModifications(
                  widget.startLocation!,
                  SearchPlaceModel(
                    id: '',
                    title: toAddressName ?? '',
                    address: Address,
                    latLng: latlong,
                    isFavourite: widget.endLocation!.isFavourite,
                  ));
              if (widget.tripType == BookingTiming.now) {
                Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(
                        builder: (BuildContext context) => SearchDriver(
                            fromAddress: widget.startLocation,
                            toAddress: SearchPlaceModel(
                              id: '',
                              title: toAddressName ?? '',
                              address: Address,
                              latLng: latlong,
                              isFavourite: widget.endLocation!.isFavourite,
                            ))),
                    (Route<dynamic> route) => true);
              } else {
                Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(
                        builder: (BuildContext context) => BookScheduleTrip(
                              fromAddress: widget.startLocation,
                              toAddress: SearchPlaceModel(
                                id: '',
                                title: toAddressName ?? '',
                                address: Address,
                                latLng: latlong,
                                isFavourite: widget.endLocation!.isFavourite,
                              ),
                            )),
                    (Route<dynamic> route) => true);
              }
            } else {
              showSnackbar(context, notSearvingSelectedArea);
            }
          } else {
            showSnackbar(context, checkPickupDestinationCarefully);
          }
        } else {
          if (widget.startLocation!.latLng.latitude != 0.0 &&
              widget.startLocation!.latLng.longitude != 0.0 &&
              widget.endLocation!.latLng.latitude != 0.0 &&
              widget.endLocation!.latLng.longitude != 0.0) {
            if (calculateDistance(
                    widget.startLocation!.latLng.latitude,
                    widget.startLocation!.latLng.longitude,
                    widget.endLocation!.latLng.latitude,
                    widget.endLocation!.latLng.longitude) <
                AppConfig.maxAllowedDistance) {
              localDbModifications(
                  SearchPlaceModel(
                    id: '',
                    title: toAddressName ?? '',
                    address: Address,
                    latLng: latlong,
                    isFavourite: widget.startLocation!.isFavourite,
                  ),
                  widget.endLocation!);

              if (widget.tripType == BookingTiming.now) {
                Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(
                        builder: (BuildContext context) => SearchDriver(
                            toAddress: widget.endLocation,
                            fromAddress: SearchPlaceModel(
                              id: '',
                              title: toAddressName ?? '',
                              address: Address,
                              latLng: latlong,
                              isFavourite: widget.startLocation!.isFavourite,
                            ))),
                    (Route<dynamic> route) => true);
              } else {
                Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(
                        builder: (BuildContext context) => BookScheduleTrip(
                            toAddress: widget.endLocation,
                            fromAddress: SearchPlaceModel(
                              id: '',
                              title: toAddressName ?? '',
                              address: Address,
                              latLng: latlong,
                              isFavourite: widget.startLocation!.isFavourite,
                            ))),
                    (Route<dynamic> route) => true);
              }
            } else {
              showSnackbar(context, notSearvingSelectedArea);
            }
          } else {
            showSnackbar(context, checkPickupDestinationCarefully);
          }
        }
      }
    }
  }
}
