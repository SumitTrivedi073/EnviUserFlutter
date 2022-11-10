import 'dart:async';
import 'dart:convert';

import 'package:envi/database/favoritesData.dart';
import 'package:envi/database/favoritesDataDao.dart';
import 'package:envi/sidemenu/favoritePlaces/searchFavoriateLocation.dart';
import 'package:envi/utils/utility.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../appConfig/Profiledata.dart';
import '../../database/database.dart';
import '../../theme/color.dart';
import '../../theme/mapStyle.dart';
import '../../theme/string.dart';
import '../../theme/theme.dart';
import '../../uiwidget/appbarInside.dart';
import '../../uiwidget/robotoTextWidget.dart';
import '../../web_service/ApiCollection.dart';
import '../../web_service/Constant.dart';

class AddEditFavoritePlacesPage extends StatefulWidget {
  final FavoritesData? data;

  // final void Function(String) onCriteriaChanged;

  const AddEditFavoritePlacesPage(
      {Key? key,
      required this.isforedit,
      required this.data,
      required this.titleEditable})
      : super(key: key);
  final String isforedit;
  final String titleEditable;

  @override
  State<AddEditFavoritePlacesPage> createState() =>
      _AddEditFavoritePlacesPageState();
}

class _AddEditFavoritePlacesPageState extends State<AddEditFavoritePlacesPage> {
  final _formKey = GlobalKey<FormState>();
  late final FavoritesDataDao dao;
  TextEditingController titlecontroller = TextEditingController();
  TextEditingController addresscontroller = TextEditingController();
  CameraPosition? _cameraPosition;
  String address = "", editidentifire = "";
  GoogleMapController? _controller;
  late LatLng latlong;
  int? editid;

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  void initState() {
    super.initState();
    loadData();

    if (widget.isforedit == "0") {
      titlecontroller.text = widget.data!.title;
      address = formatAddress(widget.data!.address);
      latlong = LatLng(double.parse(widget.data!.latitude),
          double.parse(widget.data!.longitude));
      _cameraPosition = CameraPosition(
          target: LatLng(double.parse(widget.data!.latitude),
              double.parse(widget.data!.longitude)),
          zoom: 18.0);
      editidentifire = widget.data!.identifier;

      editid = widget.data!.id;
    } else {
      getCurrentLocation();
      _cameraPosition =
          const CameraPosition(target: LatLng(0.0, 0.0), zoom: 18.0);
    }
  }

  void FromLocationSearch(String fulladdress, double lat, double long) {
    setState(() {
      print(fulladdress);
      address = formatAddress(fulladdress);
      _cameraPosition = CameraPosition(target: LatLng(lat, long), zoom: 18.0);
      latlong = LatLng(lat, long);
      if (_controller != null) {
        _controller
            ?.animateCamera(CameraUpdate.newCameraPosition(_cameraPosition!));
      }
    });
  }

  Future<void> loadData() async {
    final database =
        await $FloorFlutterDatabase.databaseBuilder('envi_user.db').build();
    dao = database.taskDao;
  }

  @override
  void dispose() {
    // _controller.removeListener(_loadMore);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      height: double.infinity,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(PageBackgroundImage),
          fit: BoxFit.cover,
        ),
      ),
      child: SingleChildScrollView(
        child: Column(
          children: [
            AppBarInsideWidget(
              pagetitle: TitelEditFavoritePlace,
              isBackButtonNeeded: true,
            ),
            Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 22,
                    ),
                    Container(
                        color: AppColor.white.withOpacity(0.1),
                        padding: const EdgeInsets.only(left: 20, right: 20),
                        child: Column(
                          children: [
                            Align(
                              alignment: Alignment.centerLeft,
                              child: robotoTextWidget(
                                textval: PlaceTitle,
                                colorval: AppColor.darkgrey,
                                sizeval: 14.0,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Container(
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      color: Colors.grey, width: 0.5),
                                  color: Colors.white),
                              child: Padding(
                                padding: const EdgeInsets.only(left: 5),
                                child: TextFormField(
                                  controller: titlecontroller,
                                  readOnly: widget.titleEditable == "0"
                                      ? false
                                      : true,
                                  style: const TextStyle(
                                      color: AppColor.black,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600),
                                  decoration: const InputDecoration(
                                    hintText: "Please enter Title!",
                                    hintStyle: TextStyle(color: Colors.black45),
                                  ),
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return 'Please enter Title!';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Align(
                                alignment: Alignment.centerLeft,
                                child: robotoTextWidget(
                                  textval: Address,
                                  colorval: AppColor.darkgrey,
                                  sizeval: 14.0,
                                  fontWeight: FontWeight.w400,
                                )),
                            const SizedBox(
                              height: 5,
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.of(context).pushAndRemoveUntil(
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            SearchFavoriateLocation(
                                                title: selectlocation,
                                                onCriteriaChanged:
                                                    FromLocationSearch)),
                                    (route) => true);
                              },
                              child: Container(
                                width: double.infinity,
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color: Colors.grey, width: 0.5),
                                    color: Colors.white),
                                child: Padding(
                                  padding: const EdgeInsets.all(15),
                                  child: Align(
                                      alignment: Alignment.centerLeft,
                                      child: Padding(
                                        padding: const EdgeInsets.only(left: 5),
                                        child: robotoTextWidget(
                                          textval: formatAddress(address),
                                          colorval: AppColor.black,
                                          sizeval: 14.0,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      )),
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 22,
                            ),
                            Container(
                                height: 300,
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color: Colors.grey, width: 0.5)),
                                child: Stack(children: [
                                  GoogleMap(
                                    mapType: MapType.normal,
                                    initialCameraPosition: _cameraPosition!,
                                    onMapCreated:
                                        (GoogleMapController controller) {
                                      controller
                                          .setMapStyle(MapStyle.mapStyles);
                                      _controller = (controller);

                                      _controller?.animateCamera(
                                          CameraUpdate.newCameraPosition(
                                              _cameraPosition!));
                                    },
                                    myLocationEnabled: false,
                                    myLocationButtonEnabled: false,
                                    mapToolbarEnabled: false,
                                    zoomGesturesEnabled: false,
                                    scrollGesturesEnabled: false,
                                    tiltGesturesEnabled: false,
                                    rotateGesturesEnabled: false,
                                    zoomControlsEnabled: false,
                                  ),
                                  Center(
                                    child: SvgPicture.asset(
                                      "assets/svg/from-location-img.svg",
                                      width: 20,
                                      height: 20,
                                    ),
                                  ),
                                ])),
                            const SizedBox(
                              height: 22,
                            ),
                            if (widget.isforedit == "0")
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(children: [
                                    MaterialButton(
                                      height: 40,
                                      onPressed: () {
                                        ApiCall_Delete_Favorite(widget.data!.id,
                                            widget.data!.identifier, context);
                                      },
                                      child: Row(children: [
                                        SvgPicture.asset(
                                          "assets/svg/place-delete.svg",
                                          width: 22,
                                          height: 24,
                                          color: AppColor.red,
                                        ),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        robotoTextWidget(
                                            textval: widget.titleEditable == "0"
                                                ? Deletelocation
                                                : Clearlocation,
                                            colorval: AppColor.red,
                                            sizeval: 16.0,
                                            fontWeight: FontWeight.w600),
                                      ]),
                                    )
                                  ]),
                                ],
                              ),
                          ],
                        )),
                  ],
                )),
            const SizedBox(
              height: 30,
            ),
            Container(
              margin: const EdgeInsets.only(left: 20, right: 20),
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  if (mounted) {
                    final isValid = _formKey.currentState!.validate();
                    if (!isValid) {
                      return;
                    }
                    _formKey.currentState!.save();

                    if (widget.titleEditable == "0") {
                      if (titlecontroller.text == "Home" ||
                          titlecontroller.text == "Work") {
                        return;
                      }
                    }
                    if (widget.isforedit != "0") {
                      var detail = await dao.findDataByaddressg(address);

                      if (detail == null) {
                        ApiCall_Add_Favorite();
                      } else {
                        ApiCall_update_Favorite(detail.id, detail.identifier);
                      }
                    } else {
                      if (editidentifire == "0") {
                        ApiCall_Add_Favorite();
                      } else {
                        ApiCall_update_Favorite(editid, editidentifire);
                      }
                    }
                  }
                },
                style: ElevatedButton.styleFrom(
                  primary: AppColor.greyblack,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5), // <-- Radius
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(15),
                  child: robotoTextWidget(
                    textval: savetext.toUpperCase(),
                    colorval: AppColor.white,
                    sizeval: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 5,
            ),
          ],
        ),
      ),
    ));
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
        zoom: 18.0,
      );
      if (_controller != null) {
        _controller
            ?.animateCamera(CameraUpdate.newCameraPosition(_cameraPosition!));
      }
    });
    GetAddressFromLatLong(latlong);
  }

  Future<void> GetAddressFromLatLong(LatLng position) async {
    List<Placemark> placemarks =
        await placemarkFromCoordinates(position.latitude, position.longitude);
    print(placemarks);
    Placemark place = placemarks[0];
    setState(() {
      address = formatAddress(
          '${place.street}, ${place.subLocality}, ${place.locality}');
    });
  }

  Future<void> ApiCall_Add_Favorite() async {
    dynamic userid = Profiledata().getusreid();
    final response = await ApiCollection.FavoriateDataAdd(
        userid,
        titlecontroller.text.toString(),
        address,
        latlong.latitude,
        latlong.longitude,
        "Y");
    print(response.body);

    if (response != null) {
      if (response.statusCode == 200) {
        String addressId = jsonDecode(response.body)['content']['addressId'];
        print(jsonDecode(response.body)['content']);

        final task = FavoritesData.optional(
            identifier: addressId,
            address: address,
            isFavourite: 'Y',
            latitude: latlong.latitude.toString(),
            longitude: latlong.longitude.toString(),
            title: titlecontroller.text.toString());
        print(task);
        await dao.insertTask(task);
        Navigator.pop(context, {"isbact": true});
      }
      if (!mounted) return;
      showSnackbar(context, (jsonDecode(response.body)['message'].toString()));
    }
  }

  Future<void> ApiCall_update_Favorite(int? id, String idetifire) async {
    dynamic userid = Profiledata().getusreid();
    final response = await ApiCollection.FavoriateDataUpdate(
        userid,
        titlecontroller.text.toString(),
        address,
        latlong.latitude,
        latlong.longitude,
        "Y",
        idetifire);
    print(response.body);

    if (response != null) {
      if (response.statusCode == 200) {
        String addressId = jsonDecode(response.body)['content']['addressId'];
        print(jsonDecode(response.body)['content']);

        final task = FavoritesData.optional(
            id: id,
            identifier: idetifire,
            address: address,
            isFavourite: 'Y',
            latitude: latlong.latitude.toString(),
            longitude: latlong.longitude.toString(),
            title: titlecontroller.text.toString());
        print(task);
        await dao.updateTask(task);

        Navigator.pop(context, {"isbact": true});
      }
      if (!mounted) return;

      showSnackbar(context, (jsonDecode(response.body)['message'].toString()));
    }
  }

  Future<void> ApiCall_Delete_Favorite(
      int? id, String identifire, context) async {
    dynamic userid = Profiledata().getusreid();
    final response =
        await ApiCollection.FavoriateDataDelete(userid, identifire);
    print(response.body);

    if (response != null) {
      if (response.statusCode == 200) {
        //print("ff${jsonDecode(response.body)['content']}");
        //String addressId = jsonDecode(response.body)['content']['addressId'];

        final task = FavoritesData.optional(
            id: id,
            identifier: identifire,
            address: address,
            isFavourite: 'Y',
            latitude: latlong.latitude.toString(),
            longitude: latlong.longitude.toString(),
            title: titlecontroller.text.toString());
        print(task);
        await dao.deleteTask(task);
        Navigator.pop(context, {"isbact": true});
      }
      if (!mounted) return;
      showSnackbar(context, (jsonDecode(response.body)['message'].toString()));
    }
  }
}
