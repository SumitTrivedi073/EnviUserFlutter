import 'dart:convert';

import 'package:envi/sidemenu/pickupDropAddressSelection/confirmDropLocation.dart';
import 'package:envi/sidemenu/pickupDropAddressSelection/model/searchPlaceModel.dart';
import 'package:envi/sidemenu/searchDriver/searchDriver.dart';
import 'package:envi/theme/string.dart';
import 'package:envi/web_service/APIDirectory.dart';
import 'package:envi/web_service/HTTP.dart' as HTTP;
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

import '../../theme/color.dart';
import '../../uiwidget/appbarInside.dart';
import '../../uiwidget/robotoTextWidget.dart';
import '../../web_service/Constant.dart';

class SelectPickupDropAddress extends StatefulWidget {
  const SelectPickupDropAddress({Key? key, required this.title})
      : super(key: key);
  final String title;

  @override
  State<SelectPickupDropAddress> createState() =>
      _SelectPickupDropAddressState();
}

class _SelectPickupDropAddressState extends State<SelectPickupDropAddress> {
  List<SearchPlaceModel> searchPlaceList = [];
  List<dynamic> _placeList = [];
  bool showTripDetail = false;
  bool isFrom = false;
  late SharedPreferences sharedPreferences;
  String SearchFromLocation = "", SearchToLocation = "";
  TextEditingController FromLocationText = TextEditingController();
  TextEditingController ToLocationText = TextEditingController();
  late String _sessionToken;
  var uuid = const Uuid();
  bool _isVisible = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      _sessionToken = uuid.v4();
    });
    FromLocationText.addListener(() {
      isFrom = true;
      _firstLoad();
    });

    ToLocationText.addListener(() {
      isFrom = false;
      _firstLoad();
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  _firstLoad() async {
    Map data;
    setState(() {
      _isVisible = true;
    });
    if (isFrom) {
      data = {
        "search": FromLocationText.text,
      };
    } else {
      data = {
        "search": ToLocationText.text,
      };
    }
    dynamic res = await HTTP.post(searchPlace(), data);
    if (res != null && res.statusCode != null) {
      if (res.statusCode == 200) {
        setState(() {
          if ((jsonDecode(res.body)['content'] as List).isNotEmpty) {
            searchPlaceList = (jsonDecode(res.body)['content'] as List)
                .map((i) => SearchPlaceModel.fromJson(i))
                .toList();
          } else {
            googleAPI();
          }
        });
      } else {
        googleAPI();
      }
    } else {
      googleAPI();
    }
  }

  void googleAPI() {
    if (isFrom) {
      getSuggestion(FromLocationText.text);
    } else {
      getSuggestion(ToLocationText.text);
    }
  }

  void getSuggestion(String input) async {
    String kPLACES_API_KEY = "AIzaSyAMnSO4iTYphqjRAnu80OG0FNLt1mvQe3c";
    String type = '(regions)';
    String baseURL =
        'https://maps.googleapis.com/maps/api/place/autocomplete/json';
    String request =
        '$baseURL?input=$input&key=$kPLACES_API_KEY&sessiontoken=$_sessionToken';
    var url = Uri.parse(request);
    dynamic response = await HTTP.get(url);
    if (response != null && response != null) {
      if (response.statusCode == 200) {
        setState(() {
          print(json.decode(response.body));
          print(json.decode(response.body)['predictions']);
          _placeList = json.decode(response.body)['predictions'];
          for (var i = 0; i < _placeList.length; i++) {
            searchPlaceList.add(SearchPlaceModel(
                id: _placeList[i]["description"],
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
                    GestureDetector(
                        onTap: () {
                          Navigator.of(context).pushAndRemoveUntil(
                              MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      const ConfirmDropLocation(
                                        title: 'Confirm Drop Location',
                                      )),
                              (Route<dynamic> route) => true);
                        },
                        child: Container(
                          margin: const EdgeInsets.all(10),
                          child: Row(
                            children: [
                              SvgPicture.asset(
                                "assets/svg/location-pin-menu.svg",
                                width: 20,
                                height: 20,
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                              const robotoTextWidget(
                                  textval: 'Pick on map',
                                  colorval: AppColor.blue,
                                  sizeval: 14,
                                  fontWeight: FontWeight.w200)
                            ],
                          ),
                        )),
                  ],
                )),
            Expanded(
                child: Visibility(
                    visible: _isVisible,
                    child: ListView.builder(
                      physics: const AlwaysScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        return Card(
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
                              onTap: () {
                                setState(() {
                                  if (isFrom) {
                                    FromLocationText.text =
                                        searchPlaceList[index].address;
                                  } else {
                                    ToLocationText.text =
                                        searchPlaceList[index].address;
                                  }
                                  _isVisible = false;
                                });
                              },
                            ),
                          ),
                        );
                      },
                      itemCount: searchPlaceList.length,
                      padding: const EdgeInsets.all(8),
                    ))),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                  height: 40,
                  margin: const EdgeInsets.all(5),
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(
                              builder: (BuildContext context) =>
                              SearchDriver()),
                              (Route<dynamic> route) => true);

                    },
                    style: ElevatedButton.styleFrom(
                      primary: AppColor.greyblack,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12), // <-- Radius
                      ),
                    ),
                    child: const robotoTextWidget(
                      textval: 'CONTINUE',
                      colorval: AppColor.white,
                      sizeval: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  )),
            ),
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
                          "assets/svg/to-location-img.svg",
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
      controller: FromLocationText,
      decoration: InputDecoration(
        hintText: FromLocationHint,
        border: InputBorder.none,
        focusColor: Colors.white,
        floatingLabelBehavior: FloatingLabelBehavior.never,
        suffixIcon: IconButton(
          icon: const Icon(Icons.cancel),
          onPressed: () {
            FromLocationText.clear();
          },
        ),
      ),
    );
  }

  TextField ToTextWidget() {
    return TextField(
      controller: ToLocationText,
      decoration: InputDecoration(
        hintText: ToLocationHint,
        border: InputBorder.none,
        focusColor: Colors.white,
        floatingLabelBehavior: FloatingLabelBehavior.never,
        suffixIcon: IconButton(
          icon: const Icon(Icons.cancel),
          onPressed: () {
            ToLocationText.clear();
          },
        ),
      ),
    );
  }
}
