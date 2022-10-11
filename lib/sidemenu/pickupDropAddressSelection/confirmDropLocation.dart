import 'dart:async';
import 'dart:convert';

import 'package:envi/sidemenu/pickupDropAddressSelection/model/searchPlaceModel.dart';
import 'package:envi/sidemenu/searchDriver/searchDriver.dart';
import 'package:envi/theme/color.dart';
import 'package:envi/theme/images.dart';
import 'package:envi/theme/mapStyle.dart';
import 'package:envi/theme/styles.dart';
import 'package:envi/uiwidget/appbarInside.dart';
import 'package:envi/uiwidget/robotoTextWidget.dart';
import 'package:envi/web_service/Constant.dart';

import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

  String? toAddressName;
  late LatLng latlong;
  CameraPosition? _cameraPosition;
  GoogleMapController? _controller;
  String Address = PickUp;
  LatLng initialLatLng = const LatLng(0, 0);
  // bool isFromVerified = false;
  // bool isToVerified = false;
  late String isFavourite;

  late SharedPreferences sharedPreferences;
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

  Future<void> apiCallAddFavorite(SearchPlaceModel? addressToAdd) async {
    sharedPreferences = await SharedPreferences.getInstance();
    dynamic userid = sharedPreferences.getString(LoginID);
    final response = await ApiCollection.FavoriateDataAdd(
        userid,
        addressToAdd!.address,
        addressToAdd.address,
        addressToAdd.latLng.latitude,
        addressToAdd.latLng.longitude,
        "N");

    if (response != null) {
      if (response.statusCode == 200) {
        String addressId = jsonDecode(response.body)['content']['addressId'];
        print(jsonDecode(response.body)['content']);

        final task = FavoritesData.optional(
            identifier: addressId,
            address: addressToAdd.address,
            isFavourite: 'N',
            latitude: addressToAdd.latLng.latitude.toString(),
            longitude: addressToAdd.latLng.longitude.toString(),
            title: addressToAdd.title);
        await dao!.insertTask(task);
      }
      showToast((jsonDecode(response.body)['message'].toString()));
    }
  }

  Future<void> apiCallUpdateFavorite(
      int? Id,
      String titel,
      SearchPlaceModel? addressToUpdate,
      String identifire,
      String favoriate) async {
    sharedPreferences = await SharedPreferences.getInstance();
    dynamic userid = sharedPreferences.getString(LoginID);
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
      showToast((jsonDecode(response.body)['message'].toString()));
    }
  }

  Future<void> apiCallAddFavoritetoaddress(
      SearchPlaceModel? addressToAdd) async {
    sharedPreferences = await SharedPreferences.getInstance();
    dynamic userid = sharedPreferences.getString(LoginID);
    final response = await ApiCollection.FavoriateDataAdd(
        userid,
        addressToAdd!.address,
        addressToAdd.address,
        addressToAdd.latLng.latitude,
        addressToAdd.latLng.longitude,
        "N");
    print(response.body);

    if (response != null) {
      if (response.statusCode == 200) {
        String addressId = jsonDecode(response.body)['content']['addressId'];
        print(jsonDecode(response.body)['content']);

        final task = FavoritesData.optional(
            identifier: addressId,
            address: addressToAdd.address,
            isFavourite: 'Y',
            latitude: addressToAdd.latLng.latitude.toString(),
            longitude: addressToAdd.latLng.longitude.toString(),
            title: addressToAdd.title);
        print(task);
        await dao!.insertTask(task);
        //Navigator.pop(context, {"isbact": true});
      }
      showToast((jsonDecode(response.body)['message'].toString()));
    }
  }

  Future<void> apiCallUpdateFavoritetoaddress(
      int? Id,
      String titel,
      SearchPlaceModel? addressToUpdate,
      String identifire,
      String favoriate) async {
    sharedPreferences = await SharedPreferences.getInstance();
    dynamic userid = sharedPreferences.getString(LoginID);
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
      showToast((jsonDecode(response.body)['message'].toString()));
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
    var toDetail = await dao!.findDataByaddressg(endLocation.address);
    if (toDetail == null) {
      apiCallAddFavoritetoaddress(endLocation);
    } else {
      apiCallUpdateFavoritetoaddress(toDetail.id, toDetail.title,
          widget.endLocation, toDetail.identifier, toDetail.isFavourite);
    }
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
          Timer(const Duration(seconds: 1), () {
            GetAddressFromLatLong(latlong);
          });
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
            isBackButtonNeeded: false,
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
                if (widget.status == AddressConfirmation.bothUnconfirmed) {
                  List<SearchPlaceModel> att = [];
                  att.add( SearchPlaceModel(
                      id: '',
                      address: Address,
                      title: toAddressName!,
                      latLng: latlong,
                      isFavourite: isFavourite,
                    ));
                  Navigator.pop(context, att);
                } else {
                  if (widget.status ==
                      AddressConfirmation.fromAddressConfirmed) {
                    localDbModifications(
                        widget.startLocation!,
                        SearchPlaceModel(
                          id: '',
                          title: toAddressName!,
                          address: Address,
                          latLng: latlong,
                          isFavourite: 'N',
                        ));
                    if (widget.tripType == BookingTiming.now) {
                      Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(
                              builder: (BuildContext context) => SearchDriver(
                                  fromAddress: widget.startLocation,
                                  toAddress: SearchPlaceModel(
                                    id: '',
                                    title: toAddressName!,
                                    address: Address,
                                    latLng: latlong,
                                    isFavourite: 'N',
                                  )

                                  // ToAddressLatLong(
                                  //   address: Address,
                                  //   position: latlong,
                                  // ),
                                  )),
                          (Route<dynamic> route) => true);
                    } else {
                      Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  BookScheduleTrip(
                                    fromAddress: widget.startLocation,
                                    toAddress: SearchPlaceModel(
                                      id: '',
                                      title: toAddressName!,
                                      address: Address,
                                      latLng: latlong,
                                      isFavourite: 'N',
                                    ),
                                  )),
                          (Route<dynamic> route) => true);
                    }
                  } else {
                    localDbModifications(
                        SearchPlaceModel(
                          id: '',
                          title: toAddressName!,
                          address: Address,
                          latLng: latlong,
                          isFavourite: 'N',
                        ),
                        widget.endLocation!);

                    if (widget.tripType == BookingTiming.now) {
                      Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(
                              builder: (BuildContext context) => SearchDriver(
                                  toAddress: widget.endLocation,
                                  fromAddress: SearchPlaceModel(
                                    id: '',
                                    title: toAddressName!,
                                    address: Address,
                                    latLng: latlong,
                                    isFavourite: 'N',
                                  )

                                  // ToAddressLatLong(
                                  //   address: Address,
                                  //   position: latlong,
                                  // ),
                                  )),
                          (Route<dynamic> route) => true);
                    } else {
                      Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  BookScheduleTrip(
                                      toAddress: widget.endLocation,
                                      fromAddress: SearchPlaceModel(
                                        id: '',
                                        title: toAddressName!,
                                        address: Address,
                                        latLng: latlong,
                                        isFavourite: 'N',
                                      ))),
                          (Route<dynamic> route) => true);
                    }
                  }
                }
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
    toAddressName = (place.subLocality != '')
        ? place.subLocality
        : place.subAdministrativeArea;
    setState(() {
      Address =
          '${place.street}, ${place.subLocality}, ${place.locality}, ${place.postalCode}, ${place.country}';
    });
  }
}
