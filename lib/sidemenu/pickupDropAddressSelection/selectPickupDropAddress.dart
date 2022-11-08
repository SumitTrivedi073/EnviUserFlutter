import 'dart:async';
import 'dart:convert';

import 'package:envi/sidemenu/pickupDropAddressSelection/confirmDropLocation.dart';
import 'package:envi/sidemenu/pickupDropAddressSelection/model/searchPlaceModel.dart';
import 'package:envi/theme/images.dart';
import 'package:envi/theme/string.dart';
import 'package:envi/web_service/APIDirectory.dart';
import 'package:envi/web_service/HTTP.dart' as HTTP;
import 'package:envi/web_service/autoCompleteService.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_place/google_place.dart';

//import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

import '../../database/database.dart';
import '../../database/favoritesDataDao.dart';
import '../../enum/BookingTiming.dart';
import '../../theme/color.dart';
import '../../uiwidget/appbarInside.dart';
import '../../uiwidget/robotoTextWidget.dart';
import '../../utils/utility.dart';
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
  List<SearchPlaceModel>? searchPlaceList = [];
  SearchPlaceModel? startingAddress;
  SearchPlaceModel? endAddress;
  List<dynamic> _placeList = [];
  bool showTripDetail = false;
  bool isFrom = false;
  TextEditingController FromLocationText = TextEditingController();
  TextEditingController ToLocationText = TextEditingController();
  late String _sessionToken;
  var uuid = const Uuid();

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

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  Future<void> getLocalSuggestions(String val) async {
    isLocalDbsuggestion = true;
    searchPlaceList = await AutocompleteService().getdata(val);
    setState(() {});
  }

  bool isLocalDbsuggestion = true;

  @override
  void initState() {
    super.initState();
    FromLocationText.text = formatAddress(widget.currentLocation!.address);
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
    FromLocationText.dispose();
    ToLocationText.dispose();
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
            isLocalDbsuggestion = false;
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
    useGoogleApi = true;
    getSuggestion(value);
  }

//GetAllFavouriteAddress();
  void getSuggestion(String input) async {
    String type = '(regions)';
    String baseURL =
        'https://maps.googleapis.com/maps/api/place/autocomplete/json';
    print('Im gettin called');
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
            searchPlaceList!.add(SearchPlaceModel(
              id: _placeList[i]["place_id"],
              address: _placeList[i]["description"],
              title: _placeList[i]["description"],
              isFavourite: 'N',
              latLng: const LatLng(0.0, 0.0),
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
              pagetitle: widget.title,
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
              child: (searchPlaceList != null && searchPlaceList!.isNotEmpty)
                  ? ListView.builder(
                      shrinkWrap: true,
                      physics: const AlwaysScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () async {
                            String isFavourite =
                                searchPlaceList![index].isFavourite;
                            if (useGoogleApi) {
                              final placeId = searchPlaceList![index].id;
                              final details = await googlePlace.details.get(
                                  placeId,
                                  sessionToken: _sessionToken,
                                  fields: 'geometry,formatted_address,name');
                              if (details != null &&
                                  details.result != null &&
                                  mounted) {
                                if (startFocusNode.hasFocus) {
                                  setState(() {
                                    // startPosition = details.result;
                                    FromLocationText.text = formatAddress(
                                        details.result!.formattedAddress!);
                                    startingAddress = SearchPlaceModel(
                                        id: searchPlaceList![index].id,
                                        address:
                                            details.result!.formattedAddress!,
                                        latLng: LatLng(
                                            details.result!.geometry!.location!
                                                .lat!,
                                            details.result!.geometry!.location!
                                                .lng!),
                                        title: details.result!.name!,
                                        isFavourite: 'N');

                                    // _isVisible = false;
                                    searchPlaceList = [];
                                  });
                                  if (endAddress == null) {
                                    var result;
                                    result = await Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (BuildContext context) =>
                                                ConfirmDropLocation(
                                                  tripType: widget.tripType,
                                                  startLocation:
                                                      startingAddress,
                                                  title: confirmLocationText,
                                                  endLocation: endAddress,
                                                  status: AddressConfirmation
                                                      .bothUnconfirmed,
                                                  isFavourite:
                                                      isFavourite.toString(),
                                                )));

                                    if (result != null) {
                                      if (result.length == 2) {
                                        startingAddress = result[0];
                                        endAddress = result[1];
                                      } else {
                                        startingAddress = result[0];
                                      }
                                    }

                                    setState(() {
                                      FromLocationText.text = formatAddress(
                                          startingAddress!.address);
                                    });
                                    endFocusNode.requestFocus();
                                    getLocalSuggestions('');
                                  } else {
                                    var result;
                                    result = await Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (BuildContext context) =>
                                                ConfirmDropLocation(
                                                  tripType: widget.tripType,
                                                  startLocation:
                                                      startingAddress,
                                                  title: confirmLocationText,
                                                  endLocation: endAddress,
                                                  status: AddressConfirmation
                                                      .toAddressConfirmed,
                                                  isFavourite:
                                                      isFavourite.toString(),
                                                )));

                                    if (result != null) {
                                      if (result.length == 2) {
                                        startingAddress = result[0];
                                        endAddress = result[1];
                                      } else {
                                        startingAddress = result[0];
                                      }
                                    }

                                    setState(() {
                                      FromLocationText.text = formatAddress(
                                          startingAddress!.address);
                                    });
                                  }
                                } else {
                                  setState(() {
                                    // endPosition = details.result;
                                    ToLocationText.text = formatAddress(
                                        details.result!.formattedAddress!);
                                    endAddress = SearchPlaceModel(
                                        id: searchPlaceList![index].id,
                                        address:
                                            details.result!.formattedAddress!,
                                        latLng: LatLng(
                                            details.result!.geometry!.location!
                                                .lat!,
                                            details.result!.geometry!.location!
                                                .lng!),
                                        title: details.result!.name!,
                                        isFavourite: 'N');
                                    searchPlaceList = [];
                                  });
                                  if (startingAddress == null) {
                                    var result;
                                    result = await Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (BuildContext context) =>
                                                ConfirmDropLocation(
                                                  tripType: widget.tripType,
                                                  startLocation:
                                                      startingAddress,
                                                  status: AddressConfirmation
                                                      .bothUnconfirmed,
                                                  endLocation: endAddress,
                                                  title: confirmLocationText,
                                                  isFavourite:
                                                      isFavourite.toString(),
                                                )));

                                    if (result != null) {
                                      if (result.length == 2) {
                                        startingAddress = result[0];
                                        endAddress = result[1];
                                      } else {
                                        endAddress = result[0];
                                      }
                                    }

                                    setState(() {
                                      ToLocationText.text =
                                          formatAddress(endAddress!.address);
                                    });
                                    startFocusNode.requestFocus();
                                    getLocalSuggestions('');
                                  } else {
                                    var result;
                                    result = await Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (BuildContext context) =>
                                                ConfirmDropLocation(
                                                  tripType: widget.tripType,
                                                  startLocation:
                                                      startingAddress,
                                                  status: AddressConfirmation
                                                      .fromAddressConfirmed,
                                                  endLocation: endAddress,
                                                  title: confirmLocationText,
                                                  isFavourite:
                                                      isFavourite.toString(),
                                                )));

                                    if (result != null) {
                                      if (result.length == 2) {
                                        startingAddress = result[0];
                                        endAddress = result[1];
                                      } else {
                                        endAddress = result[0];
                                      }
                                    }

                                    setState(() {
                                      ToLocationText.text =
                                          formatAddress(endAddress!.address);
                                    });
                                  }
                                }
                              }
                            } else {
                              if (mounted) {
                                if (startFocusNode.hasFocus) {
                                  setState(() {
                                    FromLocationText.text = formatAddress(
                                        searchPlaceList![index].address);
                                    startingAddress = searchPlaceList![index];
                                    searchPlaceList = [];
                                  });
                                  if (endAddress == null) {
                                    var result;
                                    result = await Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (BuildContext context) =>
                                                ConfirmDropLocation(
                                                  tripType: widget.tripType,
                                                  startLocation:
                                                      startingAddress,
                                                  title: confirmLocationText,
                                                  endLocation: endAddress,
                                                  status: AddressConfirmation
                                                      .bothUnconfirmed,
                                                  isFavourite:
                                                      isFavourite.toString(),
                                                )));

                                    if (result != null) {
                                      if (result.length == 2) {
                                        startingAddress = result[0];
                                        endAddress = result[1];
                                      } else {
                                        startingAddress = result[0];
                                      }
                                    }

                                    setState(() {
                                      FromLocationText.text = formatAddress(
                                          startingAddress!.address);
                                      getLocalSuggestions('');
                                    });
                                    endFocusNode.requestFocus();
                                  } else {
                                    var result;
                                    result = await Navigator.of(context)
                                        .pushAndRemoveUntil(
                                            MaterialPageRoute(
                                                builder: (BuildContext
                                                        context) =>
                                                    ConfirmDropLocation(
                                                      tripType: widget.tripType,
                                                      startLocation:
                                                          startingAddress,
                                                      title:
                                                          confirmLocationText,
                                                      endLocation: endAddress,
                                                      status: AddressConfirmation
                                                          .toAddressConfirmed,
                                                      isFavourite: isFavourite
                                                          .toString(),
                                                    )),
                                            (Route<dynamic> route) => true);
                                    if (result != null) {
                                      if (result.length == 2) {
                                        startingAddress = result[0];
                                        endAddress = result[1];
                                      } else {
                                        startingAddress = result[0];
                                      }
                                    }

                                    setState(() {
                                      FromLocationText.text = formatAddress(
                                          startingAddress!.address);
                                    });
                                  }
                                } else {
                                  setState(() {
                                    ToLocationText.text = formatAddress(
                                        searchPlaceList![index].address);
                                    endAddress = searchPlaceList![index];
                                    searchPlaceList = [];
                                  });
                                  if (startingAddress == null) {
                                    var result;

                                    result = await Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (BuildContext context) =>
                                                ConfirmDropLocation(
                                                  tripType: widget.tripType,
                                                  startLocation:
                                                      startingAddress,
                                                  status: AddressConfirmation
                                                      .bothUnconfirmed,
                                                  endLocation: endAddress,
                                                  title: confirmLocationText,
                                                  isFavourite:
                                                      isFavourite.toString(),
                                                )));

                                    if (result != null) {
                                      if (result.length == 2) {
                                        startingAddress = result[0];
                                        endAddress = result[1];
                                      } else {
                                        endAddress = result[0];
                                      }
                                    }

                                    setState(() {
                                      ToLocationText.text =
                                          formatAddress(endAddress!.address);
                                    });
                                    startFocusNode.requestFocus();
                                    getLocalSuggestions('');
                                  } else {
                                    var result;
                                    result = await Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (BuildContext context) =>
                                                ConfirmDropLocation(
                                                  tripType: widget.tripType,
                                                  startLocation:
                                                      startingAddress,
                                                  status: AddressConfirmation
                                                      .fromAddressConfirmed,
                                                  endLocation: endAddress,
                                                  title: confirmLocationText,
                                                  isFavourite:
                                                      isFavourite.toString(),
                                                )));

                                    if (result != null) {
                                      if (result.length == 2) {
                                        startingAddress = result[0];
                                        endAddress = result[1];
                                      } else {
                                        endAddress = result[0];
                                      }
                                    }

                                    setState(() {
                                      ToLocationText.text =
                                          formatAddress(endAddress!.address);
                                    });
                                  }
                                }
                              }
                            }
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(5),
                            child: ListTile(
                              dense: true,
                              contentPadding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              minLeadingWidth: 30,
                              horizontalTitleGap: 0.0,
                              title: robotoTextWidget(
                                textval: formatAddress(
                                    searchPlaceList![index].title),
                                colorval: AppColor.greyblack,
                                sizeval: 14.0,
                                fontWeight: FontWeight.w600,
                              ),
                              subtitle: robotoTextWidget(
                                textval: formatAddress(
                                    searchPlaceList![index].address),
                                colorval: AppColor.darkgrey,
                                sizeval: 12.0,
                                fontWeight: FontWeight.w400,
                              ),
                              leading: SvgPicture.asset(
                                (searchPlaceList![index].title == 'Work')
                                    ? "assets/svg/place-work.svg"
                                    : (isLocalDbsuggestion &&
                                            searchPlaceList![index].title !=
                                                'Home' &&
                                            searchPlaceList![index].title !=
                                                'Work')
                                        ? "assets/svg/ride-history.svg"
                                        : (searchPlaceList![index].title ==
                                                'Home')
                                            ? "assets/svg/place-home.svg"
                                            : Images.toLocationImage,
                                width: 18,
                                height: 18,
                                color: AppColor.grey,
                                theme: const SvgTheme(
                                    currentColor: AppColor.darkGreen),
                              ),
                            ),
                          ),
                        );
                      },
                      itemCount: searchPlaceList!.length,
                      padding: const EdgeInsets.all(8),
                    )
                  : const SizedBox(),
            ),
          ],
        ),
      ),
    );
  }

  Card EditFromToWidget() {
    return Card(
        clipBehavior: Clip.antiAliasWithSaveLayer,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        elevation: 5,
        child: Padding(
          padding: const EdgeInsets.all(5),
          child: Column(
            children: [
              GestureDetector(
                  onTap: () {},
                  child: Container(
                    height: 45,
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
                              // margin:
                              //     const EdgeInsets.only(left: 10, right: 10),
                              child: fromTextWidget(),
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
                    height: 45,
                    margin: const EdgeInsets.only(left: 10),
                    child: Row(
                      children: [
                        SvgPicture.asset(
                          Images.toLocationImage,
                          width: 20,
                          height: 20,
                        ),
                        const SizedBox(
                          width: 8,
                        ),
                        Flexible(
                            child: Wrap(children: [
                          InkWell(
                            onTap: () {},
                            child: Container(
                              // margin:
                              //     const EdgeInsets.only(left: 10, right: 10),
                              child: toTextWidget(),
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

  TextField fromTextWidget() {
    return TextField(
      style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
      autofocus: false,
      focusNode: startFocusNode,
      onSubmitted: (value) {
        startingAddress = null;
        startFocusNode.requestFocus();
      },
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
              startingAddress = null;
              getLocalSuggestions('');
            });
          }
        });
      },
      showCursor: true,
      controller: FromLocationText,
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(0, 12, 0, 12),
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
                      startingAddress = null;
                      getLocalSuggestions('');
                      startFocusNode.requestFocus();
                    });
                  },
                )
              : null),
    );
  }

  Widget toTextWidget() {
    return TextField(
      style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
      autofocus: false,
      focusNode: endFocusNode,
      showCursor: true,
      onSubmitted: (value) {
        endAddress = null;
        endFocusNode.requestFocus();
      },
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
                      endAddress = null;
                      getLocalSuggestions('');
                      endFocusNode.requestFocus();
                    });
                  },
                )
              : null),
    );
  }
}
