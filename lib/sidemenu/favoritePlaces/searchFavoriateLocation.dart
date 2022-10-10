import 'dart:async';
import 'dart:convert';

import 'package:envi/theme/string.dart';
import 'package:envi/web_service/APIDirectory.dart';
import 'package:envi/web_service/HTTP.dart' as HTTP;
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_place/google_place.dart';

//import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

import '../../theme/color.dart';
import '../../uiwidget/appbarInside.dart';
import '../../uiwidget/robotoTextWidget.dart';
import '../../web_service/Constant.dart';
import 'confirmFavoriteLocation.dart';
import 'model/searchLocationModel.dart';

class SearchFavoriateLocation extends StatefulWidget {
  final void Function(String, double, double) onCriteriaChanged;

  const SearchFavoriateLocation(
      {Key? key, required this.title, required this.onCriteriaChanged})
      : super(key: key);
  final String title;

  @override
  State<SearchFavoriateLocation> createState() =>
      _SearchFavoriateLocationState();
}

class _SearchFavoriateLocationState extends State<SearchFavoriateLocation> {
  List<SearchLocationModel> searchPlaceList = [];
  List<dynamic> _placeList = [];
  bool showTripDetail = false;
  bool isFrom = false;

  // late SharedPreferences sharedPreferences;
  String SearchFromLocation = "";
  TextEditingController FromLocationText = TextEditingController();
  late String _sessionToken;
  var uuid = const Uuid();
  bool _isVisible = false;
  DetailsResult? startPosition;

  late FocusNode startFocusNode;

  late GooglePlace googlePlace;

  Timer? _debounce;
  List<AutocompletePrediction> predictions = [];
  int searctType = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _sessionToken = uuid.v4();

    startFocusNode = FocusNode();

    googlePlace = GooglePlace(GoogleApiKey);
  }

  @override
  void dispose() {
    super.dispose();
    startFocusNode.dispose();
  }

  void FromConfirmLocation(String fulladdress, double lat, double long) {
    print(fulladdress);
    widget.onCriteriaChanged(fulladdress, lat, long);
    Navigator.pop(context);
  }

  _firstLoad(String value) async {
    Map data;

    data = {
      "search": value,
    };
    searctType = 0;
    searchPlaceList = [];
    dynamic res = await HTTP.post(searchPlace(), data);
    if (res != null && res.statusCode != null) {
      if (res.statusCode == 200) {
        if ((jsonDecode(res.body)['content'] as List).isNotEmpty) {
          print(jsonDecode(res.body)['content']);
          List<dynamic> tem = jsonDecode(res.body)['content'] as List;
          setState(() {
            for (var i = 0; i < tem.length; i++) {
              searchPlaceList.add(SearchLocationModel(
                  id: tem[i]['_id'],
                  address: tem[i]['address'],
                  lng: tem[i]["location"]['coordinates'][0],
                  lat: tem[i]["location"]['coordinates'][1],
                  title: tem[i]['title']));
            }
          });
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
    searctType = 1;
    getSuggestion(value);
  }

  void getSuggestion(String input) async {
    searchPlaceList = [];
    String type = '(regions)';
    String baseURL =
        'https://maps.googleapis.com/maps/api/place/autocomplete/json';
    String request =
        '$baseURL?input=$input&key=$GoogleApiKey&sessiontoken=$_sessionToken';
    var url = Uri.parse(request);
    dynamic response = await HTTP.get(url);
    if (response != null && response != null) {
      if (response.statusCode == 200) {
        setState(() {
          // print(json.decode(response.body));
          // print(json.decode(response.body)['predictions']);
          _placeList = json.decode(response.body)['predictions'];
          for (var i = 0; i < _placeList.length; i++) {
            print(_placeList[i]);
            searchPlaceList.add(SearchLocationModel(
                id: _placeList[i]["place_id"],
                address: _placeList[i]["description"],
                title: _placeList[i]["description"],
                lng: 0.0,
                lat: 0.0));
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
                return InkWell(
                  onTap: () async {
                    String selecteAddress = "";
                    double latitude = 0.0;
                    double longitude = 0.0;
                    if (searctType == 0) {
                      selecteAddress = searchPlaceList[index].address;
                      latitude = searchPlaceList[index].lat;
                      longitude = searchPlaceList[index].lng;
                    } else if (searctType == 1) {
                      final placeId = searchPlaceList[index].id;
                      final details = await googlePlace.details.get(placeId,
                          sessionToken: _sessionToken,
                          fields: 'geometry,formatted_address,name');
                      if (details != null &&
                          details.result != null &&
                          mounted) {
                        selecteAddress = details.result!.name!;
                        latitude = details.result!.geometry!.location!.lat!;
                        longitude = details.result!.geometry!.location!.lng!;
                      }
                    }
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ConfirmFavoriteLocation(
                                  onCriteriaChanged: FromConfirmLocation,
                                  fromLocation: selecteAddress,
                                  lat: latitude,
                                  lng: longitude,
                                )));
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
                          "assets/svg/to-location-img.svg",
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
              itemCount:
                  searchPlaceList.length < 10 ? searchPlaceList.length : 10,
              padding: const EdgeInsets.all(8),
            )),
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
                  onTap: () {
                    print("Tapped a Container");
                  },
                  child: Container(
                    height: 50,
                    margin: const EdgeInsets.only(left: 10),
                    child: Row(
                      children: [
                        SvgPicture.asset(
                          "assets/svg/from-location-img.svg",
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
            ],
          ),
        ));
  }

  TextField FromTextWidget() {
    return TextField(
      focusNode: startFocusNode,
      onChanged: (value) {
        if (_debounce?.isActive ?? false) _debounce!.cancel();
        _debounce = Timer(const Duration(milliseconds: 1000), () {
          if (value.isNotEmpty) {
            //places api
            _firstLoad(value);
            setState(() {
              searchPlaceList = [];
              startPosition = null;
            });
            // googleAPI(value);
          } else {
            setState(() {
              searchPlaceList = [];
              startPosition = null;
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
}
