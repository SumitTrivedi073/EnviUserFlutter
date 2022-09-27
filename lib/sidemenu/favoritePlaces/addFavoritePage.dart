import 'dart:convert';

import 'package:envi/database/favoritesData.dart';
import 'package:envi/database/favoritesDataDao.dart';
import 'package:envi/sidemenu/favoritePlaces/searchFavoriateLocation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../database/database.dart';
import '../../theme/color.dart';
import '../../theme/mapStyle.dart';
import '../../theme/string.dart';
import '../../uiwidget/appbarInside.dart';
import '../../uiwidget/robotoTextWidget.dart';
import '../../utils/utility.dart';
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
  TextEditingController titlecontroller = new TextEditingController();
  TextEditingController addresscontroller = new TextEditingController();
  CameraPosition? _cameraPosition;
  String address = "";
  GoogleMapController? _controller;
  late LatLng latlong;
  late SharedPreferences sharedPreferences;
  @override
  void initState() {
    super.initState();
    loadData();

if(widget.isforedit == "0"){
  titlecontroller.text = widget.data!.title;
  address = widget.data!.address;
  latlong = LatLng(double.parse(widget.data!.latitude), double.parse(widget.data!.longitude));
  _cameraPosition =  CameraPosition(target: LatLng(double.parse(widget.data!.latitude), double.parse(widget.data!.longitude)), zoom: 10.0);
}else{
  getCurrentLocation();
  _cameraPosition =  CameraPosition(target: LatLng(0.0, 0.0), zoom: 10.0);
}
    // _controller = new ScrollController()..addListener(_loadMore);
  }
void FromLocationSearch(String fulladdress,double lat,double long){
setState(() {
  print(fulladdress);
  address = fulladdress;
  _cameraPosition =  CameraPosition(target: LatLng(lat, long), zoom: 10.0);
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
    //List<FavoritesData>  temparr =  await dao.getFavoriate() ;
    // setState(() {
    //
    // });
    //findTaskByidentifier("5bf57942-b1be-4df2-a9a9-1e588bf8e1dd");
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
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(PageBackgroundImage),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          children: [
            AppBarInsideWidget(
              title: TitelEditFavoritePlace,
            ),
            Form(
                key: _formKey,
                child: Container(
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
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(children: [
                                    robotoTextWidget(
                                      textval: PlaceTitle,
                                      colorval: AppColor.grey,
                                      sizeval: 14.0,
                                      fontWeight: FontWeight.normal,
                                    ),
                                  ]),
                                ],
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              Card(
                                child: TextFormField(
                                  controller: titlecontroller,
                                  readOnly: widget.titleEditable == "0"
                                      ? false
                                      : true,
                                  keyboardType: TextInputType.phone,
                                  style: const TextStyle(color: AppColor.black),
                                  decoration: const InputDecoration(
                                    hintText: "Please enter Title!",
                                    hintStyle: TextStyle(color: Colors.black45),
                                  ),
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return 'Please enter valid OTP!';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(children: [
                                    robotoTextWidget(
                                      textval: Address,
                                      colorval: AppColor.grey,
                                      sizeval: 14.0,
                                      fontWeight: FontWeight.normal,
                                    ),
                                  ]),
                                ],
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.of(context).pushAndRemoveUntil(
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  SearchFavoriateLocation(
                                                      title: pickUpLocation,onCriteriaChanged: FromLocationSearch)),
                                              (route) => true);
                                      print("Tapped a Container");
                                    },
                                    child: Card(

                                        child: Container( width:
                                        MediaQuery.of(context).size.width -50,
                                          height: 50,
                                          child: robotoTextWidget(
                                            textval: address,
                                            colorval: AppColor.black,
                                            sizeval: 16.0,
                                            fontWeight: FontWeight.normal,
                                          ),)),
                                  ),
                                ],
                              ),

                              const SizedBox(
                                height: 22,
                              ),
                              Container(
                                height: 300,
                                child: Stack(children: [ GoogleMap(
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
                                   // GetAddressFromLatLong(latlong);
                                  },
                                  onCameraMove: (CameraPosition position) {
                                   // latlong = LatLng(position.target.latitude, position.target.longitude);
                                  },
                                ),
                                  Center(
                                    child: Image.asset(
                                      "assets/images/destination-marker.png",
                                      scale: 2,
                                    ),
                                  ),
                              ])),
                              const SizedBox(
                                height: 22,
                              ),

                              if(widget.isforedit == "0")
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(children: [
                                    MaterialButton(
                                      height: 40,
                                      onPressed: () {
                                        ApiCall_Delete_Favorite(widget.data!.id,widget.data!.identifier);
                                      },
                                      child: Row(children: [
                                        SvgPicture.asset(
                                          "assets/svg/place-delete.svg",
                                          width: 22,
                                          height: 24,
                                          color: AppColor.red,
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        robotoTextWidget(
                                            textval: widget.titleEditable == "0"
                                                ? Deletelocation
                                                : Clearlocation,
                                            colorval: AppColor.red,
                                            sizeval: 16.0,
                                            fontWeight: FontWeight.normal),
                                      ]),
                                    )
                                  ]),
                                ],
                              ),
                            ],
                          )),
                    ],
                  ),
                )),
            Container(
              color: AppColor.alfaorange,

              //padding: const EdgeInsets.all(20),
              margin: const EdgeInsets.only(bottom: 50),
              child: MaterialButton(
                color: AppColor.darkgrey,
                height: 40,
                onPressed: () async {
                  final isValid = _formKey.currentState!.validate();
                  if (!isValid) {
                    return;
                  }
                  _formKey.currentState!.save();

                  if(widget.titleEditable =="0"){
                    if(titlecontroller.text=="Home"|| titlecontroller.text == "Work"){
                      return ;
                    }

                  }
                  print("======");

                  var detail = await dao.findDataByaddressg(address) ;

                  if(detail == null){
                    print("======api");
                    ApiCall_Add_Favorite();
                  }
                  else{
                    print("=====${detail}");
                    ApiCall_update_Favorite(detail.identifier);
                  }
                },
                child: robotoTextWidget(
                    textval: savetext,
                    colorval: AppColor.white,
                    sizeval: 16.0,
                    fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(
              height: 5,
            ),
          ],
        ),
      ),
    );
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
    GetAddressFromLatLong(latlong);
  }
  Future<void> GetAddressFromLatLong(LatLng position) async {
    List<Placemark> placemarks =
    await placemarkFromCoordinates(position.latitude, position.longitude);
    print(placemarks);
    Placemark place = placemarks[0];
    setState(() {
      address =
      '${place.street}, ${place.subLocality}, ${place.locality}, ${place.postalCode}, ${place.country}';
    });
  }
  Future<void> ApiCall_Add_Favorite()   async {
    sharedPreferences = await SharedPreferences.getInstance();
    dynamic userid = sharedPreferences.getString(LoginID);
    final response =
    await ApiCollection.FavoriateDataAdd(userid, titlecontroller.text.toString(), address,latlong.latitude,latlong.longitude,"Y");
    print(response.body);

    if (response != null) {
      if (response.statusCode == 200) {
        String addressId = jsonDecode(response.body)['content']['addressId'];
        print(jsonDecode(response.body)['content']);

        final task = FavoritesData.optional(identifier: addressId,
            address: address,
            isFavourite: 'Y',
            latitude: latlong.latitude.toString(),
            longitude: latlong.longitude.toString(),
            title: titlecontroller.text.toString());
        print(task);
        await dao.insertTask(task);
        Navigator.pop(context,{"isbact": true});
      }
      showToast((jsonDecode(response.body)['message'].toString()));
    }
  }

  Future<void> ApiCall_update_Favorite(String id)   async {
    sharedPreferences = await SharedPreferences.getInstance();
    dynamic userid = sharedPreferences.getString(LoginID);
    final response =
    await ApiCollection.FavoriateDataUpdate(userid, titlecontroller.text.toString(), address,latlong.latitude,latlong.longitude,"Y",id);
    print(response.body);

    if (response != null) {
      if (response.statusCode == 200) {
        String addressId = jsonDecode(response.body)['content']['addressId'];
        print(jsonDecode(response.body)['content']);

        final task = FavoritesData.optional(identifier: addressId,
            address: address,
            isFavourite: 'Y',
            latitude: latlong.latitude.toString(),
            longitude: latlong.longitude.toString(),
            title: titlecontroller.text.toString());
        print(task);
        await dao.updateTask(task);
        Navigator.pop(context,{"isbact": true});
      }
      showToast((jsonDecode(response.body)['message'].toString()));
    }
  }
  Future<void> ApiCall_Delete_Favorite(int? id,String identifire)   async {
    sharedPreferences = await SharedPreferences.getInstance();
    dynamic userid = sharedPreferences.getString(LoginID);
    final response =
    await ApiCollection.FavoriateDataDelete(userid, identifire);
    print(response.body);

    if (response != null) {
      if (response.statusCode == 200) {
        //print("ff${jsonDecode(response.body)['content']}");
        //String addressId = jsonDecode(response.body)['content']['addressId'];


        final task = FavoritesData.optional(id: id,identifier: identifire,
            address: address,
            isFavourite: 'Y',
            latitude: latlong.latitude.toString(),
            longitude: latlong.longitude.toString(),
            title: titlecontroller.text.toString());
        print(task);
        await dao.deleteTask(task);
        Navigator.pop(context,{"isbact": true});
      }
      showToast((jsonDecode(response.body)['message'].toString()));
    }
  }
}
