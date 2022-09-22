import 'dart:async';
import 'dart:convert';

import 'package:envi/sidemenu/pickupDropAddressSelection/confirmDropLocation.dart';
import 'package:envi/sidemenu/pickupDropAddressSelection/model/searchPlaceModel.dart';
import 'package:envi/sidemenu/searchDriver/searchDriver.dart';
import 'package:envi/theme/images.dart';
import 'package:envi/theme/string.dart';
import 'package:envi/web_service/APIDirectory.dart';
import 'package:envi/web_service/HTTP.dart' as HTTP;
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_place/google_place.dart';
//import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

import '../../theme/color.dart';
import '../../uiwidget/appbarInside.dart';
import '../../uiwidget/robotoTextWidget.dart';
import '../../web_service/Constant.dart';

class SelectPickupDropAddress extends StatefulWidget {
  const SelectPickupDropAddress(
      {Key? key, required this.title, this.currentLocation})
      : super(key: key);
  final String title;
  final SearchPlaceModel? currentLocation;

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

  Timer? _debounce;
  List<AutocompletePrediction> predictions = [];
  bool useGoogleApi = true;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    FromLocationText.text = widget.currentLocation!.title;
    _sessionToken = uuid.v4();
    startFocusNode = FocusNode();
    endFocusNode = FocusNode();
    endFocusNode.requestFocus();
    googlePlace = GooglePlace(GoogleApiKey);
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
    Map data;

    data = {
      "search": value,
    };

    dynamic res = await HTTP.post(searchPlace(), data);
    if (res != null && res.statusCode != null) {
      if (res.statusCode == 200) {
        if ((jsonDecode(res.body)['content'] as List).isNotEmpty) {
          searchPlaceList = (jsonDecode(res.body)['content'] as List)
              .map((i) => SearchPlaceModel.fromJson(i))
              .toList();
          useGoogleApi = false;
          _isVisible = true;
        } else {
          googleAPI(value);
        }
      } else {
        googleAPI(value);
      }
    } else {
      googleAPI(value);
    }
  }

  void googleAPI(String value) {
    _isVisible = true;
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
                    // GestureDetector(
                    //     onTap: () {
                    //       searchPlaceList = [];
                    //       // Navigator.of(context).pushAndRemoveUntil(
                    //       //     MaterialPageRoute(
                    //       //         builder: (BuildContext context) =>
                    //       //             ConfirmDropLocation(
                    //       //               fromLocation: startingAddress ??
                    //       //                   widget.currentLocation!,
                    //       //               title: confirmDropLocationText,
                    //       //             )),
                    //       //     (Route<dynamic> route) => true);
                    //     },
                    //     child: Container(
                    //       margin: const EdgeInsets.all(10),
                    //       child: Row(
                    //         children: [
                    //           SvgPicture.asset(
                    //             Images.locationPinImage,
                    //             width: 20,
                    //             height: 20,
                    //           ),
                    //           const SizedBox(
                    //             width: 5,
                    //           ),
                    //           robotoTextWidget(
                    //               textval: pickOnMapText,
                    //               colorval: AppColor.blue,
                    //               sizeval: 14,
                    //               fontWeight: FontWeight.w200)
                    //         ],
                    //       ),
                    //     )),
                  ],
                )),
            Expanded(
                child: Visibility(
              visible: _isVisible,
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
                              FromLocationText.text = details.result!.name!;
                              startingAddress = SearchPlaceModel(
                                  id: searchPlaceList[index].id,
                                  address: details.result!.formattedAddress!,
                                  latLng: LatLng(
                                      details.result!.geometry!.location!.lat!,
                                      details.result!.geometry!.location!.lng!),
                                  title: details.result!.name!);
                              //  searchPlaceList = [];
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
                              FromLocationText.text = startingAddress!.title;

                              _isVisible = false;
                            });
                          } else {
                            setState(() {
                              // endPosition = details.result;
                              ToLocationText.text = details.result!.name!;
                              endAddress = SearchPlaceModel(
                                  id: searchPlaceList[index].id,
                                  address: details.result!.formattedAddress!,
                                  latLng: LatLng(
                                      details.result!.geometry!.location!.lat!,
                                      details.result!.geometry!.location!.lng!),
                                  title: details.result!.name!);
                              //  searchPlaceList = [];
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
                              ToLocationText.text = endAddress!.title;
                              _isVisible = false;
                            });

                            // searchPlaceList = [];
                          }
                        }
                      } else {
                        if (mounted) {
                          if (startFocusNode.hasFocus) {
                            setState(() {
                              FromLocationText.text =
                                  searchPlaceList[index].title;
                              startingAddress = searchPlaceList[index];
                              //  searchPlaceList = [];
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
                              FromLocationText.text = startingAddress!.title;
                              _isVisible = false;
                            });

                            //   searchPlaceList = [];

                            //startFocusNode.unfocus();

                          } else {
                            setState(() {
                              ToLocationText.text =
                                  searchPlaceList[index].title;
                              endAddress = searchPlaceList[index];
                              //    searchPlaceList = [];
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
                              ToLocationText.text = endAddress!.title;
                              //  searchPlaceList = [];
                              _isVisible = false;
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
              ),
            )),
            (searchPlaceList.isEmpty) ? const Spacer() : const SizedBox(),
            Container(
                height: 40,
                margin: const EdgeInsets.all(5),
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    searchPlaceList = [];
                    Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(
                            builder: (BuildContext context) => SearchDriver(
                                  fromAddress:
                                      startingAddress ?? widget.currentLocation,
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
                )),
            const SizedBox(
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
      enableSuggestions: true,
      autofocus: false,
      focusNode: startFocusNode,
      autofillHints: const ['babar', ',haha', 'huhu'],
      onChanged: (value) {
        if (useGoogleApi) {
          if (_debounce?.isActive ?? false) _debounce!.cancel();
          _debounce = Timer(const Duration(milliseconds: 1000), () {
            if (value.isNotEmpty) {
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
        }

        if (value.isNotEmpty) {
          _firstLoad(value);
        } else {
          setState(() {
            searchPlaceList = [];
            //startPosition = null;
            startingAddress = null;
          });
        }
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

//   Widget ToTextWidget() {
//     return TypeAheadField(
//       textFieldConfiguration: TextFieldConfiguration(
//         focusNode: endFocusNode,
//         onChanged: (value) {
//           if (useGoogleApi) {
//             if (_debounce?.isActive ?? false) _debounce!.cancel();
//             _debounce = Timer(const Duration(milliseconds: 1000), () {
//               if (value.isNotEmpty) {
//                 //places api
//                 _firstLoad(value);
//                 // googleAPI(value);
//               } else {
//                 setState(() {
//                   searchPlaceList = [];
//                   //endPosition = null;
//                   endAddress = null;
//                 });
//               }
//             });
//           }

//           if (value.isNotEmpty) {
//             _firstLoad(value);
//           } else {
//             setState(() {
//               searchPlaceList = [];

//               endAddress = null;
//             });
//           }
//         },
//         controller: ToLocationText,
//         autofocus: true,
//         decoration: InputDecoration(
//             hintText: ToLocationHint,
//             border: InputBorder.none,
//             focusColor: Colors.white,
//             floatingLabelBehavior: FloatingLabelBehavior.never,
//             suffixIcon: ToLocationText.text.isNotEmpty
//                 ? IconButton(
//                     icon: const Icon(Icons.cancel),
//                     onPressed: () {
//                       setState(() {
//                         ToLocationText.clear();
//                         searchPlaceList = [];
//                       });
//                     },
//                   )
//                 : null),
//       ),
//       // suggestionsCallback: (pattern) async {
//       //  // return await BackendService.getSuggestions(pattern);
//       // },
//       hideOnEmpty: true,
//      hideSuggestionsOnKeyboardHide: false,
    
//       itemBuilder: (context, suggestion) {
//         return ListTile(
//           // leading: Icon(Icons.shopping_cart),
//           title: Text(_suggestions[0]),
//           // subtitle: Text('\$${suggestion['price']}'),
//         );
//       },
//       onSuggestionSelected: (suggestion) {
//         // Navigator.of(context).push(MaterialPageRoute(
//         //   builder: (context) => ProductPage(product: suggestion)
//         // ));
//         ToLocationText.text = suggestion!.toString();
//       },
//       suggestionsCallback: (String pattern) {
//         return _suggestions;
//       },
//     );
//   }
// }
  Widget ToTextWidget() {
    return Autocomplete(
      optionsBuilder: (TextEditingValue value) {
        if (value.text.isEmpty) {
          return _suggestions;
        }
        return _suggestions;
      },
      fieldViewBuilder:
          ((context, textEditingController, focusNode, onFieldSubmitted) {
        return TextFormField(
          // onSubmitted: (val) {},
          focusNode: endFocusNode,
          showCursor: true,
          onChanged: (value) {
            if (useGoogleApi) {
              if (_debounce?.isActive ?? false) _debounce!.cancel();
              _debounce = Timer(const Duration(milliseconds: 1000), () {
                if (value.isNotEmpty) {
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
            }

            if (value.isNotEmpty) {
              _firstLoad(value);
            } else {
              setState(() {
                searchPlaceList = [];

                endAddress = null;
              });
            }
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
      }),
    );
  }
}




//