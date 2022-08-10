import 'dart:convert';
import 'package:envi/sidemenu/pickupDropAddressSelection/model/searchPlaceModel.dart';
import 'package:envi/web_service/APIDirectory.dart';
import 'package:envi/web_service/HTTP.dart' as HTTP;
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  bool showTripDetail = false;
  bool _isFirstLoadRunning = false;
  bool isFrom = false;
  bool _isVisible = false;
  late SharedPreferences sharedPreferences;
  String SearchFromLocation = "",SearchToLocation = "";
  TextEditingController FromLocationText = TextEditingController();
  TextEditingController ToLocationText = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _firstLoad() async {
    setState(() {
      _isFirstLoadRunning = true;
    });
    Map data;
    if(isFrom) {
      data = {
        "search": SearchFromLocation.toString(),
      };
    }else {
      data = {
        "search": SearchToLocation.toString(),
      };
    }
    dynamic res = await HTTP.post(searchPlace(), data);
    if (res != null && res.statusCode != null) {
      if (res.statusCode == 200) {
        setState(() {
          searchPlaceList = (jsonDecode(res.body)['content'] as List)
              .map((i) => SearchPlaceModel.fromJson(i))
              .toList();
        });
      } else {
        setState(() {
          _isFirstLoadRunning = false;
        });
        throw "Can't get places List";
      }
    } else {
      setState(() {
        _isFirstLoadRunning = false;
      });
      throw "Can't get places List";
    }
    setState(() {
      _isFirstLoadRunning = false;
    });
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
                margin: const EdgeInsets.only(right: 10.0),
                child: Row(
                  children: [
                    Expanded(
                        child: Container(
                          margin: const EdgeInsets.only(left: 5, right: 5),
                          child: EditFromToWidget(),
                        )),
                  ],
                )),
            Expanded(
                child: _isFirstLoadRunning
                    ? const Center(
                  child: CircularProgressIndicator(),
                )
                    : Container(
                    margin: const EdgeInsets.only(right: 10.0),
                    child: _buildPosts(context))),
          ],
        ),
      ),
    );
  }

  Visibility _buildPosts(BuildContext context) {
    return
      Visibility (
        visible: _isVisible,
        child:
        ListView.builder(
      itemBuilder: (context, index) {
        return  Card(
            elevation: 4,
            child: Padding(padding: EdgeInsets.all(10),
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
                  if(isFrom){
                    FromLocationText.text =  searchPlaceList[index].address;
                  }else{
                    ToLocationText.text =  searchPlaceList[index].address;
                  }
                  _isVisible = !_isVisible;
                });

              },
            ),),
          );

      },
      itemCount: searchPlaceList.length,
      padding: const EdgeInsets.all(8),
    ));
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

  TextFormField FromTextWidget() {
    return TextFormField(
        controller: FromLocationText,
        decoration: const InputDecoration(
            border: InputBorder.none,
            focusedBorder: InputBorder.none,
             hintText: 'Select From Location'),
        style: const TextStyle(
            color: AppColor.black, fontSize: 18, fontWeight: FontWeight.w200),
        onChanged: (String? str) {
          setState(() {
            SearchFromLocation = str!;
          });
          isFrom = true;
         _firstLoad();
          _isVisible = !_isVisible;
        });
  }

  TextFormField ToTextWidget() {
    return TextFormField(
        controller: ToLocationText,
        decoration: const InputDecoration(
            border: InputBorder.none,
            focusedBorder: InputBorder.none,
            hintText: 'Select To Location'),
        style: const TextStyle(
            color: AppColor.black, fontSize: 18, fontWeight: FontWeight.w200),
        onChanged: (String? str) {
          setState(() {
            SearchToLocation = str!;
          });
          isFrom = false;
        _firstLoad();
          _isVisible = !_isVisible;
        });
  }
}
