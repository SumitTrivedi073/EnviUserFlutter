import 'dart:async';
import 'dart:convert';

import 'package:envi/sidemenu/bookScheduleTrip/bookScheduleTrip.dart';
import 'package:envi/sidemenu/pickupDropAddressSelection/confirmDropLocation.dart';
import 'package:envi/sidemenu/pickupDropAddressSelection/model/searchPlaceModel.dart';
import 'package:envi/sidemenu/searchDriver/searchDriver.dart';
import 'package:envi/theme/images.dart';
import 'package:envi/theme/string.dart';
import 'package:envi/web_service/APIDirectory.dart';
import 'package:envi/web_service/HTTP.dart' as HTTP;
import 'package:envi/web_service/autoCompleteService.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_place/google_place.dart';

//import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

import '../../appConfig/Profiledata.dart';
import '../../database/database.dart';
import '../../database/favoritesData.dart';
import '../../database/favoritesDataDao.dart';
import '../../enum/BookingTiming.dart';
import '../../theme/color.dart';
import '../../uiwidget/appbarInside.dart';
import '../../uiwidget/robotoTextWidget.dart';
import '../../utils/utility.dart';
import '../../web_service/ApiCollection.dart';
import '../../web_service/Constant.dart';

class SelectPickupDropAddress extends StatefulWidget {
  const SelectPickupDropAddress(
      {Key? key,
      required this.title,
      required this.tripType,
      this.currentLocation})
      : super(key: key);
  final String title;
  final SearchPlaceModel? currentLocation;

  final BookingTiming tripType;

  @override
  State<SelectPickupDropAddress> createState() =>
      _SelectPickupDropAddressState();
}

class _SelectPickupDropAddressState extends State<SelectPickupDropAddress> {
  bool areBothAddressConfirmed = false;
  List<SearchPlaceModel> searchPlaceList = [];
  SearchPlaceModel? startingAddress;
  SearchPlaceModel? endAddress;
  List<dynamic> _placeList = [];
  bool showTripDetail = false;
  bool isFrom = false;
  String SearchFromLocation = "", SearchToLocation = "";
  TextEditingController FromLocationText = TextEditingController();
  TextEditingController ToLocationText = TextEditingController();
  late String _sessionToken;
  var uuid = const Uuid();
  bool _isVisible = false;
  DetailsResult? startPosition;
  DetailsResult? endPosition;
  late FocusNode startFocusNode;
  late FocusNode endFocusNode;
  late GooglePlace googlePlace;
  late final FavoritesDataDao dao;

  Timer? _debounce;

  bool useGoogleApi = false;

  Future<void> loadData() async {
    final database =
        await $FloorFlutterDatabase.databaseBuilder('envi_user.db').build();
    dao = database.taskDao;
  }

  Future<void> apiCallAddFavorite(SearchPlaceModel? addressToAdd) async {

    dynamic userid = Profiledata().getusreid();
    final response = await ApiCollection.FavoriateDataAdd(
        userid,
        FromLocationText.text.toString(),
        addressToAdd!.address,
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
        await dao.insertTask(task);
      }
      //showToast((jsonDecode(response.body)['message'].toString()));
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
        await dao.updateTask(task);
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
        ToLocationText.text.toString(),
        addressToAdd!.address,
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
        await dao.insertTask(task);
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
        await dao.updateTask(task);
      }
     // showToast((jsonDecode(response.body)['message'].toString()));
    }
  }

  Future<void> getLocalSuggestions(String val) async {
    searchPlaceList = await AutocompleteService().getdata(val);
    print("localSearch" + searchPlaceList.toString());
    setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    FromLocationText.text = widget.currentLocation!.address;
    _sessionToken = uuid.v4();
    startFocusNode = FocusNode();
    endFocusNode = FocusNode();
    endFocusNode.requestFocus();
    googlePlace = GooglePlace(GoogleApiKey);
    loadData();
    getLocalSuggestions('');
    startingAddress = widget.currentLocation;
  }

  @override
  void dispose() {
    super.dispose();
    startFocusNode.dispose();
    endFocusNode.dispose();
  }

  _firstLoad(String value) async {
    var data;

    data = {
      "search": value,
    };

    dynamic res = await HTTP.post(searchPlace(), data);
    if (res != null && res.statusCode != null) {
      if (res.statusCode == 200) {
        setState(() {
          if ((jsonDecode(res.body)['content'] as List).isNotEmpty) {
            searchPlaceList = (jsonDecode(res.body)['content'] as List)
                .map((i) => SearchPlaceModel.fromJson(i))
                .toList();
            useGoogleApi = false;

            _isVisible = true;
          } else {
            googleAPI(value);
          }
        });
      } else {
        googleAPI(value);
      }
    } else {
      googleAPI(value);
    }
  }

  void googleAPI(String value) {
    _isVisible = true;
    useGoogleApi = true;
    getSuggestion(value);
  }

//GetAllFavouriteAddress();
  void getSuggestion(String input) async {
    String type = '(regions)';
    String baseURL =
        'https://maps.googleapis.com/maps/api/place/autocomplete/json';
    String request =
        '$baseURL?input=$input&key=$GoogleApiKey&sessiontoken=$_sessionToken&components=country:in';
    var url = Uri.parse(request);
    dynamic response = await HTTP.get(url);
    if (response != null && response != null) {
      if (response.statusCode == 200) {
        setState(() {
          // print(json.decode(response.body));
          // print(json.decode(response.body)['predictions']);
          _placeList = json.decode(response.body)['predictions'];
          for (var i = 0; i < _placeList.length; i++) {
            searchPlaceList.add(SearchPlaceModel(
              id: _placeList[i]["place_id"],
              address: _placeList[i]["description"],
              title: _placeList[i]["description"],
              isFavourite: 'N',
              latLng: LatLng(0.0, 0.0),
            ));
          }
        });
      } else {
        throw Exception('Failed to load predictions');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(PageBackgroundImage),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          children: [
            AppBarInsideWidget(
              title: widget.title,
              isBackButtonNeeded: true,
            ),
            Container(
                margin: const EdgeInsets.only(left: 5, right: 5),
                child: Column(
                  children: [
                    EditFromToWidget(),
                  ],
                )),
            Expanded(
                child: ListView.builder(
              shrinkWrap: true,
              physics: const AlwaysScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () async {
                    print("serch index$index");
                    print("serch index${searchPlaceList[index].isFavourite}");
                    String isFavourite = searchPlaceList[index].isFavourite;
                    if (useGoogleApi) {
                      final placeId = searchPlaceList[index].id;
                      final details = await googlePlace.details.get(placeId,
                          sessionToken: _sessionToken,
                          fields: 'geometry,formatted_address,name');
                      if (details != null &&
                          details.result != null &&
                          mounted) {
                        if (startFocusNode.hasFocus) {
                          setState(() {
                            // startPosition = details.result;
                            FromLocationText.text =
                                details.result!.formattedAddress!;
                            startingAddress = SearchPlaceModel(
                                id: searchPlaceList[index].id,
                                address: details.result!.formattedAddress!,
                                latLng: LatLng(
                                    details.result!.geometry!.location!.lat!,
                                    details.result!.geometry!.location!.lng!),
                                title: details.result!.name!,
                                isFavourite: 'N');

                            // _isVisible = false;
                            searchPlaceList = [];
                          });
                          if (ToLocationText.text == '') {
                            var result;
                            result = await Navigator.of(context)
                                .pushAndRemoveUntil(
                                    MaterialPageRoute(
                                        builder: (BuildContext context) =>
                                            ConfirmDropLocation(
                                              tripType: widget.tripType,
                                              startLocation: startingAddress,
                                              title: confirmLocationText,
                                              endLocation: endAddress,
                                              status: AddressConfirmation
                                                  .bothUnconfirmed,
                                              isFavourite:
                                                  isFavourite.toString(),
                                            )),
                                    (Route<dynamic> route) => true);

                            if (result.length == 2) {
                              startingAddress = result[0];
                              endAddress = result[1];
                            } else {
                              startingAddress = result[0];
                            }

                            setState(() {
                              FromLocationText.text = startingAddress!.address;
                            });
                            endFocusNode.requestFocus();
                          } else {
                            var result;
                            result = await Navigator.of(context)
                                .pushAndRemoveUntil(
                                    MaterialPageRoute(
                                        builder: (BuildContext context) =>
                                            ConfirmDropLocation(
                                              tripType: widget.tripType,
                                              startLocation: startingAddress,
                                              title: confirmLocationText,
                                              endLocation: endAddress,
                                              status: AddressConfirmation
                                                  .toAddressConfirmed,
                                              isFavourite:
                                                  isFavourite.toString(),
                                            )),
                                    (Route<dynamic> route) => true);
                            if (result.length == 2) {
                              startingAddress = result[0];
                              endAddress = result[1];
                            } else {
                              startingAddress = result[0];
                            }

                            setState(() {
                              FromLocationText.text = startingAddress!.address;
                            });
                          }
                        } else {
                          setState(() {
                            // endPosition = details.result;
                            ToLocationText.text =
                                details.result!.formattedAddress!;
                            endAddress = SearchPlaceModel(
                                id: searchPlaceList[index].id,
                                address: details.result!.formattedAddress!,
                                latLng: LatLng(
                                    details.result!.geometry!.location!.lat!,
                                    details.result!.geometry!.location!.lng!),
                                title: details.result!.name!,
                                isFavourite: 'N');
                            searchPlaceList = [];
                          });
                          if (FromLocationText.text == '') {
                            var result;
                            result = await Navigator.of(context)
                                .pushAndRemoveUntil(
                                    MaterialPageRoute(
                                        builder: (BuildContext context) =>
                                            ConfirmDropLocation(
                                              tripType: widget.tripType,
                                              startLocation: startingAddress,
                                              status: AddressConfirmation
                                                  .bothUnconfirmed,
                                              endLocation: endAddress,
                                              title: confirmLocationText,
                                              isFavourite:
                                                  isFavourite.toString(),
                                            )),
                                    (Route<dynamic> route) => true);
                            if (result.length == 2) {
                              startingAddress = result[0];
                              endAddress = result[1];
                            } else {
                              endAddress = result[0];
                            }
                            setState(() {
                              ToLocationText.text = endAddress!.address;
                            });
                          } else {
                            var result;
                            result = await Navigator.of(context)
                                .pushAndRemoveUntil(
                                    MaterialPageRoute(
                                        builder: (BuildContext context) =>
                                            ConfirmDropLocation(
                                              tripType: widget.tripType,
                                              startLocation: startingAddress,
                                              status: AddressConfirmation
                                                  .fromAddressConfirmed,
                                              endLocation: endAddress,
                                              title: confirmLocationText,
                                              isFavourite:
                                                  isFavourite.toString(),
                                            )),
                                    (Route<dynamic> route) => true);
                            if (result.length == 2) {
                              startingAddress = result[0];
                              endAddress = result[1];
                            } else {
                              endAddress = result[0];
                            }
                            setState(() {
                              ToLocationText.text = endAddress!.address;
                            });
                          }
                          // endAddress = await Navigator.of(context)
                          //     .pushAndRemoveUntil(
                          //         MaterialPageRoute(
                          //             builder: (BuildContext context) =>
                          //                 ConfirmDropLocation(
                          //                   location: endAddress,
                          //                   title: confirmLocationText,
                          //                   isFavourite: isFavourite.toString(),
                          //                 )),
                          //         (Route<dynamic> route) => true);
                          // setState(() {
                          //   ToLocationText.text = endAddress!.address;
                          // });
                        }
                      }
                    } else {
                      if (mounted) {
                        if (startFocusNode.hasFocus) {
                          setState(() {
                            FromLocationText.text =
                                searchPlaceList[index].address;
                            startingAddress = searchPlaceList[index];
                            searchPlaceList = [];
                          });
                          if (ToLocationText.text == '') {
                            var result;
                            result = await Navigator.of(context)
                                .pushAndRemoveUntil(
                                    MaterialPageRoute(
                                        builder: (BuildContext context) =>
                                            ConfirmDropLocation(
                                              tripType: widget.tripType,
                                              startLocation: startingAddress,
                                              title: confirmLocationText,
                                              endLocation: endAddress,
                                              status: AddressConfirmation
                                                  .bothUnconfirmed,
                                              isFavourite:
                                                  isFavourite.toString(),
                                            )),
                                    (Route<dynamic> route) => true);
                            if (result.length == 2) {
                              startingAddress = result[0];
                              endAddress = result[1];
                            } else {
                              startingAddress = result[0];
                            }

                            setState(() {
                              FromLocationText.text = startingAddress!.address;
                            });
                            endFocusNode.requestFocus();
                            getLocalSuggestions('');
                          } else {
                            var result;
                            result = await Navigator.of(context)
                                .pushAndRemoveUntil(
                                    MaterialPageRoute(
                                        builder: (BuildContext context) =>
                                            ConfirmDropLocation(
                                              tripType: widget.tripType,
                                              startLocation: startingAddress,
                                              title: confirmLocationText,
                                              endLocation: endAddress,
                                              status: AddressConfirmation
                                                  .toAddressConfirmed,
                                              isFavourite:
                                                  isFavourite.toString(),
                                            )),
                                    (Route<dynamic> route) => true);
                            if (result.length == 2) {
                              startingAddress = result[0];
                              endAddress = result[1];
                            } else {
                              startingAddress = result[0];
                            }

                            setState(() {
                              FromLocationText.text = startingAddress!.address;
                            });
                          }
                        } else {
                          setState(() {
                            ToLocationText.text =
                                searchPlaceList[index].address;
                            endAddress = searchPlaceList[index];
                            searchPlaceList = [];
                          });
                          if (FromLocationText.text == '') {
                            var result;

                            result = await Navigator.of(context)
                                .pushAndRemoveUntil(
                                    MaterialPageRoute(
                                        builder: (BuildContext context) =>
                                            ConfirmDropLocation(
                                              tripType: widget.tripType,
                                              startLocation: startingAddress,
                                              status: AddressConfirmation
                                                  .bothUnconfirmed,
                                              endLocation: endAddress,
                                              title: confirmLocationText,
                                              isFavourite:
                                                  isFavourite.toString(),
                                            )),
                                    (Route<dynamic> route) => true);
                            if (result.length == 2) {
                              startingAddress = result[0];
                              endAddress = result[1];
                            } else {
                              endAddress = result[0];
                            }

                            setState(() {
                              ToLocationText.text = endAddress!.address;
                            });
                            
                          } else {
                            var result;
                            result = await Navigator.of(context)
                                .pushAndRemoveUntil(
                                    MaterialPageRoute(
                                        builder: (BuildContext context) =>
                                            ConfirmDropLocation(
                                              tripType: widget.tripType,
                                              startLocation: startingAddress,
                                              status: AddressConfirmation
                                                  .fromAddressConfirmed,
                                              endLocation: endAddress,
                                              title: confirmLocationText,
                                              isFavourite:
                                                  isFavourite.toString(),
                                            )),
                                    (Route<dynamic> route) => true);
                            if (result.length == 2) {
                              startingAddress = result[0];
                              endAddress = result[1];
                            } else {
                              endAddress = result[0];
                            }

                            setState(() {
                              ToLocationText.text = endAddress!.address;
                            });
                          }
                        }
                      }
                    }
                  },
                  child: Card(
                    elevation: 4,
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: ListTile(
                        title: robotoTextWidget(
                          textval: searchPlaceList[index].title,
                          colorval: AppColor.black,
                          sizeval: 14.0,
                          fontWeight: FontWeight.w800,
                        ),
                        subtitle: robotoTextWidget(
                          textval: searchPlaceList[index].address,
                          colorval: AppColor.black,
                          sizeval: 12.0,
                          fontWeight: FontWeight.w400,
                        ),
                        leading: SvgPicture.asset(
                          Images.toLocationImage,
                          width: 20,
                          height: 20,
                        ),
                      ),
                    ),
                  ),
                );
              },
              itemCount: searchPlaceList.length,
              padding: const EdgeInsets.all(8),
            )),
            (searchPlaceList.isEmpty) ? const Spacer() : const SizedBox(),
          ],
        ),
      ),
    );
  }

  Card EditFromToWidget() {
    return Card(
        semanticContainer: true,
        clipBehavior: Clip.antiAliasWithSaveLayer,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        elevation: 5,
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              GestureDetector(
                  onTap: () {},
                  child: Container(
                    height: 50,
                    margin: const EdgeInsets.only(left: 10),
                    child: Row(
                      children: [
                        SvgPicture.asset(
                          Images.fromLocationImage,
                          width: 20,
                          height: 20,
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        Flexible(
                            child: Wrap(children: [
                          InkWell(
                            onTap: () {},
                            child: Container(
                              padding: const EdgeInsets.only(right: 8),
                              margin:
                                  const EdgeInsets.only(left: 10, right: 10),
                              child: FromTextWidget(),
                            ),
                          ),
                        ])),
                      ],
                    ),
                  )),
              Container(
                margin: const EdgeInsets.only(left: 10, right: 10),
                height: 1,
                color: AppColor.grey,
              ),
              GestureDetector(
                  onTap: () {
                    //  print("Tapped a Container");
                  },
                  child: Container(
                    height: 50,
                    margin: const EdgeInsets.only(left: 10),
                    child: Row(
                      children: [
                        SvgPicture.asset(
                          Images.toLocationImage,
                          width: 20,
                          height: 20,
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        Flexible(
                            child: Wrap(children: [
                          InkWell(
                            onTap: () {},
                            child: Container(
                              padding: const EdgeInsets.only(right: 8),
                              margin:
                                  const EdgeInsets.only(left: 10, right: 10),
                              child: ToTextWidget(),
                            ),
                          ),
                        ])),
                      ],
                    ),
                  ))
            ],
          ),
        ));
  }

  TextField FromTextWidget() {
    return TextField(
      autofocus: false,
      focusNode: startFocusNode,
      onChanged: (value) {
        if (_debounce?.isActive ?? false) _debounce!.cancel();
        _debounce = Timer(const Duration(milliseconds: 1000), () {
          if (value.isNotEmpty) {
            (value.length < 5)
                ? getLocalSuggestions(value)
                :
                //places api
                _firstLoad(value);
            // googleAPI(value);
          } else {
            getLocalSuggestions('');
            setState(() {
              searchPlaceList = [];
              //startPosition = null;
              startingAddress = null;
              getLocalSuggestions('');
            });
          }
        });
      },
      showCursor: true,
      controller: FromLocationText,
      decoration: InputDecoration(
          hintText: FromLocationHint,
          border: InputBorder.none,
          focusColor: Colors.white,
          floatingLabelBehavior: FloatingLabelBehavior.never,
          suffixIcon: FromLocationText.text.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.cancel),
                  onPressed: () {
                    setState(() {
                      FromLocationText.clear();
                      searchPlaceList = [];
                      getLocalSuggestions('');
                    });
                  },
                )
              : null),
    );
  }

  Widget ToTextWidget() {
    return TextField(
      // onSubmitted: (val) {},
      autofocus: false,
      focusNode: endFocusNode,
      showCursor: true,
      onChanged: (value) {
        if (_debounce?.isActive ?? false) _debounce!.cancel();
        _debounce = Timer(const Duration(milliseconds: 1000), () {
          if (value.isNotEmpty) {
            //places api
            (value.length < 5)
                ? getLocalSuggestions(value)
                :
                //places api
                _firstLoad(value);
            // googleAPI(value);
          } else {
            setState(() {
              searchPlaceList = [];
              //endPosition = null;
              endAddress = null;
              getLocalSuggestions('');
            });
          }
        });
      },
      controller: ToLocationText,
      decoration: InputDecoration(
          hintText: ToLocationHint,
          border: InputBorder.none,
          focusColor: Colors.white,
          floatingLabelBehavior: FloatingLabelBehavior.never,
          suffixIcon: ToLocationText.text.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.cancel),
                  onPressed: () {
                    setState(() {
                      ToLocationText.clear();
                      searchPlaceList = [];
                      getLocalSuggestions('');
                    });
                  },
                )
              : null),
    );
  }
}
