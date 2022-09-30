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
import 'package:floor/floor.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_place/google_place.dart';
import 'package:shared_preferences/shared_preferences.dart';
//import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

import '../../database/database.dart';
import '../../database/favoritesData.dart';
import '../../database/favoritesDataDao.dart';
import '../../theme/color.dart';
import '../../uiwidget/appbarInside.dart';
import '../../uiwidget/robotoTextWidget.dart';
import '../../utils/utility.dart';
import '../../web_service/ApiCollection.dart';
import '../../web_service/Constant.dart';
import '../../web_service/paytm_config.dart';
import 'package:http/http.dart' as http;
import 'package:paytm_allinonesdk/paytm_allinonesdk.dart';

class SelectPickupDropAddress extends StatefulWidget {
  const SelectPickupDropAddress(
      {Key? key, required this.title,required this.tripType, this.currentLocation})
      : super(key: key);
  final String title;
  final SearchPlaceModel? currentLocation;
final BookingTiming tripType;
  @override
  State<SelectPickupDropAddress> createState() =>
      _SelectPickupDropAddressState();
}

class _SelectPickupDropAddressState extends State<SelectPickupDropAddress> {
  List<SearchPlaceModel> searchPlaceList = [];
  SearchPlaceModel? startingAddress;
  SearchPlaceModel? endAddress;
  List<dynamic> _placeList = [];
  bool showTripDetail = false;
  bool isFrom = false;
  // late SharedPreferences sharedPreferences;
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
  List<FavoritesData> arraddress = [];

  Timer? _debounce;
  List<AutocompletePrediction> predictions = [];
  bool useGoogleApi = false;
  late SharedPreferences sharedPreferences;

  Future<void> getdata() async {
    List<FavoritesData> temparr = await dao.getFavoriate();
    setState(() {
      arraddress = temparr;
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

  Future<void> apiCallAddFavorite(SearchPlaceModel? addressToAdd) async {
    sharedPreferences = await SharedPreferences.getInstance();
    dynamic userid = sharedPreferences.getString(LoginID);
    final response = await ApiCollection.FavoriateDataAdd(
        userid,
        FromLocationText.text.toString(),
        addressToAdd!.address,
        addressToAdd.latLng!.latitude,
        addressToAdd.latLng!.longitude,
        "Y");
    print(response.body);

    if (response != null) {
      if (response.statusCode == 200) {
        String addressId = jsonDecode(response.body)['content']['addressId'];
        print(jsonDecode(response.body)['content']);

        final task = FavoritesData.optional(
            identifier: addressId,
            address: addressToAdd.address,
            isFavourite: 'Y',
            latitude: addressToAdd.latLng!.latitude.toString(),
            longitude: addressToAdd.latLng!.longitude.toString(),
            title: addressToAdd.title);
        print(task);
        await dao.insertTask(task);
        //Navigator.pop(context, {"isbact": true});
      }
      showToast((jsonDecode(response.body)['message'].toString()));
    }
  }

  Future<void> apiCallUpdateFavorite(
      {String? id, SearchPlaceModel? addressToUpdate}) async {
    sharedPreferences = await SharedPreferences.getInstance();
    dynamic userid = sharedPreferences.getString(LoginID);
    final response = await ApiCollection.FavoriateDataUpdate(
        userid,
        FromLocationText.text.toString(),
        addressToUpdate!.address,
        addressToUpdate.latLng!.latitude,
        addressToUpdate.latLng!.longitude,
        "Y",
        id);
    print(response.body);

    if (response != null) {
      if (response.statusCode == 200) {
        String addressId = jsonDecode(response.body)['content']['addressId'];
        print(jsonDecode(response.body)['content']);

        final task = FavoritesData.optional(
            identifier: addressId,
            address: startingAddress!.address,
            isFavourite: 'Y',
            latitude: startingAddress!.latLng!.latitude.toString(),
            longitude: startingAddress!.latLng!.longitude.toString(),
            title: startingAddress!.title);
        print(task);
        await dao.updateTask(task);
        //Navigator.pop(context, {"isbact": true});
      }
      showToast((jsonDecode(response.body)['message'].toString()));
    }
  }

  Future<dynamic> createOrder() async {
    var headers = {
      'x-access-token':
          'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6IjNkYjljNDk2LTBmZTItNDc5Mi1hODdlLWI5ZWZhZWUzZmQ1YiIsInR5cGVpZCI6MywicGhvbmVOdW1iZXIiOiI5NDI0ODgwNTgyIiwiaWF0IjoxNjYzODE5NjE3fQ.uLjsbCFkQR9I4WNz5nkzBCCRRCDaASHYP5EJ0W0_kDM',
      'Content-Type': 'application/json'
    };
    var request = http.Request('POST',
        Uri.parse('https://qausernew.azurewebsites.net/order/createOrder'));
    request.body = json.encode(
        {"passengerTripMasterId": "9b20343d-b725-4fc4-80cf-d0c68c4ae860"});
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();
    var result;
    if (response.statusCode == 200) {
      //print(await response.stream.bytesToString());
      result = await response.stream.bytesToString();
      var jres = json.decode(result);
      print(jres['MID']);
      await initiateTransaction(jres['ORDER_ID'], jres['amount'].toDouble(),
          jres['txnToken'], jres['CALLBACK_URL'], jres['MID']);
    } else {
      print(response.reasonPhrase);
    }
  }

  Future<void> initiateTransaction(String orderId, double amount,
      String txnToken, String callBackUrl, String miid) async {
    String result = '';
    try {
      var response = AllInOneSdk.startTransaction(
        miid,
        orderId,
        amount.toString(),
        txnToken,
        callBackUrl,
        false,
        true,
      );
      response.then((value) {
        // Transaction successfull
        setState(() {
          result = value.toString();
        });
      }).catchError((onError) {
        if (onError is PlatformException) {
          result = onError.message! + " \n  " + onError.details.toString();
          setState(() {
            result = onError.message.toString() +
                " \n  " +
                onError.details.toString();
          });
        } else {
          result = onError.toString();
          print(result);
        }
      });
    } catch (err) {
      // Transaction failed
      result = err.toString();
      print(result);
    }
  }

  Future<void> getLocalSuggestions(String val) async {
// var x =await AutocompleteService().getSuggestions(pattern);
//  searchPlaceList = x
    searchPlaceList = await AutocompleteService().getdata(val);
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

  final List<String> _suggestions = [
    'Alligator',
    'Buffalo',
    'Chicken',
    'Dog',
    'Eagle',
    'Frog'
  ];

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
                title: _placeList[i]["description"]));
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
                                title: details.result!.name!);

                            // _isVisible = false;
                            searchPlaceList = [];
                          });
                          startingAddress = await Navigator.of(context)
                              .pushAndRemoveUntil(
                                  MaterialPageRoute(
                                      builder: (BuildContext context) =>
                                          ConfirmDropLocation(
                                            location: startingAddress,
                                            title: confirmLocationText,
                                          )),
                                  (Route<dynamic> route) => true);
                          setState(() {
                            FromLocationText.text = startingAddress!.address;

                            // _isVisible = false;
                            // searchPlaceList = [];
                          });
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
                                title: details.result!.name!);
                            searchPlaceList = [];

                            //
                            // _isVisible = false;
                          });

                          endAddress = await Navigator.of(context)
                              .pushAndRemoveUntil(
                                  MaterialPageRoute(
                                      builder: (BuildContext context) =>
                                          ConfirmDropLocation(
                                            location: endAddress,
                                            title: confirmLocationText,
                                          )),
                                  (Route<dynamic> route) => true);
                          setState(() {
                            ToLocationText.text = endAddress!.address;
                            // _isVisible = false;
                            // searchPlaceList = [];
                          });

                          // searchPlaceList = [];
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
                            // _isVisible = false;
                          });

                          startingAddress = await Navigator.of(context)
                              .pushAndRemoveUntil(
                                  MaterialPageRoute(
                                      builder: (BuildContext context) =>
                                          ConfirmDropLocation(
                                            location: startingAddress,
                                            title: confirmLocationText,
                                          )),
                                  (Route<dynamic> route) => true);
                          setState(() {
                            FromLocationText.text = startingAddress!.address;
                            // _isVisible = false;
                            // searchPlaceList = [];
                          });

                          //

                          //startFocusNode.unfocus();

                        } else {
                          setState(() {
                            ToLocationText.text =
                                searchPlaceList[index].address;
                            endAddress = searchPlaceList[index];
                            searchPlaceList = [];

                            //   _isVisible = false;
                          });

                          endAddress = await Navigator.of(context)
                              .pushAndRemoveUntil(
                                  MaterialPageRoute(
                                      builder: (BuildContext context) =>
                                          ConfirmDropLocation(
                                            location: endAddress,
                                            title: confirmLocationText,
                                          )),
                                  (Route<dynamic> route) => true);
                          setState(() {
                            ToLocationText.text = endAddress!.address;
                            // searchPlaceList = [];
                            // _isVisible = false;
                          });

                          // endFocusNode.unfocus();

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
                        // onTap: () async {

                        // },
                      ),
                    ),
                  ),
                );
              },
              itemCount: searchPlaceList.length,
              padding: const EdgeInsets.all(8),
            )),
            (searchPlaceList.isEmpty) ? const Spacer() : const SizedBox(),
            (startingAddress != null &&
                    endAddress != null &&
                    FromLocationText.text != '' &&
                    ToLocationText.text != '')
                ? Container(
                    height: 40,
                    margin: const EdgeInsets.all(5),
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () async {
                        searchPlaceList = [];
                        // PaytmConfig paytmConfig = PaytmConfig();
                        // paytmConfig.createOrder();
                        var detail =
                            await dao.findDataByaddressg(FromLocationText.text);
                        if (detail == null) {
                          //print("======api");
                          apiCallAddFavorite(startingAddress);
                        } else {
                          //print("=====${detail}");
                          apiCallUpdateFavorite(
                              id: detail.identifier,
                              addressToUpdate: startingAddress);
                        }
                        var toDetail =
                            await dao.findDataByaddressg(ToLocationText.text);
                        if (toDetail == null) {
                          //print("======api");
                          apiCallAddFavorite(endAddress);
                        } else {
                          //print("=====${detail}");
                          apiCallUpdateFavorite(
                              id: toDetail.identifier,
                              addressToUpdate: endAddress);
                        }
                        //createOrder();
                        Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(
                                builder: (BuildContext context) => SearchDriver(
                                      fromAddress: startingAddress ??
                                          widget.currentLocation,
                                      toAddress: endAddress,
                                    )),
                            (Route<dynamic> route) => true);
                      },
                      style: ElevatedButton.styleFrom(
                        primary: AppColor.greyblack,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12), // <-- Radius
                        ),
                      ),
                      child: robotoTextWidget(
                        textval: continuebut,
                        colorval: AppColor.white,
                        sizeval: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ))
                : const SizedBox(
                    height: 20,
                  )
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
            setState(() {
              searchPlaceList = [];
              //startPosition = null;
              startingAddress = null;
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
                    });
                  },
                )
              : null),
    );
  }

  // Widget ToTextWidget() {
  //   return TypeAheadField(
  //     textFieldConfiguration: TextFieldConfiguration(
  //       focusNode: endFocusNode,
  //       onChanged: (value) {
  //         if (useGoogleApi) {
  //           if (_debounce?.isActive ?? false) _debounce!.cancel();
  //           _debounce = Timer(const Duration(milliseconds: 1000), () {
  //             if (value.isNotEmpty) {
  //               //places api
  //               _firstLoad(value);
  //               // googleAPI(value);
  //             } else {
  //               setState(() {
  //                 searchPlaceList = [];
  //                 //endPosition = null;
  //                 endAddress = null;
  //               });
  //             }
  //           });
  //         }

  //         if (value.isNotEmpty) {
  //           _firstLoad(value);
  //         } else {
  //           setState(() {
  //             searchPlaceList = [];

  //             endAddress = null;
  //           });
  //         }
  //       },
  //  searchplacelist     controller: ToLocationText,
  //       autofocus: true,
  //       decoration: InputDecoration(
  //           hintText: ToLocationHint,
  //           border: InputBorder.none,
  //           focusColor: Colors.white,
  //           floatingLabelBehavior: FloatingLabelBehavior.never,
  //           suffixIcon: ToLocationText.text.isNotEmpty
  //               ? IconButton(
  //                   icon: const Icon(Icons.cancel),
  //                   onPressed: () {
  //                     setState(() {
  //                       ToLocationText.clear();
  //                       searchPlaceList = [];
  //                     });
  //                   },
  //                 )
  //               : null),
  //     ),
  //     // suggestionsCallback: (pattern) async {
  //     //  // return await BackendService.getSuggestions(pattern);
  //     // },
  //     hideOnEmpty: true,
  //     hideSuggestionsOnKeyboardHide: true,
  //     //  hideOnError: true,
  //     // errorBuilder: (context, error) {
  //     //   return const SizedBox();
  //     // },

  //     itemBuilder: (context, String suggestion) {
  //       return Container(
  //         width: double.infinity,
  //         child: ListTile(
  //           // leading: Icon(Icons.shopping_cart),
  //           title: Text(suggestion),
  //           // subtitle: Text('\$${suggestion['price']}'),
  //         ),
  //       );
  //     },
  //     onSuggestionSelected: (String suggestion) {
  //       // Navigator.of(context).push(MaterialPageRoute(
  //       //   builder: (context) => ProductPage(product: suggestion)
  //       // ));
  //       ToLocationText.text = suggestion.toString();
  //     },
  //     suggestionsCallback: (String pattern) async {
  //       var x = await AutocompleteService().getSuggestions(pattern);
  //       return x;
  //     },
  //   );
  // }
//}

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
                    });
                  },
                )
              : null),
    );
  }
}

//
