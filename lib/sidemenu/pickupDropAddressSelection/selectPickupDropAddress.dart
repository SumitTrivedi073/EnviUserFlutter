import 'dart:convert';

import 'package:envi/sidemenu/pickupDropAddressSelection/model/searchPlaceModel.dart';
import 'package:envi/web_service/APIDirectory.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:envi/web_service/HTTP.dart' as HTTP;
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
  late SharedPreferences sharedPreferences;
  String Searchtext = "";

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
    sharedPreferences = await SharedPreferences.getInstance();
    setState(() {
      _isFirstLoadRunning = true;
    });
    Map data = {
      "search": Searchtext.toString(),
    };
    dynamic res = await HTTP.post(searchPlace(),data);
    /*headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        }*/
    if(res!=null && res.statusCode!=null) {
      if (res.statusCode == 200) {
        setState(() {
          searchPlaceList = (jsonDecode(res.body)['content']  as List)
              .map((i) => SearchPlaceModel.fromJson(i))
              .toList();});
      } else {
        setState(() {
          _isFirstLoadRunning = false;
        });
        throw "Can't get places List";
      }
    }else {
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
                          child: driverSearchBox(),
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
          /*  Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(children: <Widget>[
                  Container(
                      margin: const EdgeInsets.only(right: 10.0),
                      child: Row(
                        children: [
                          Expanded(
                              child: Container(
                                margin: const EdgeInsets.only(left: 5, right: 5),
                                child: driverSearchBox(),
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
                        child: RefreshIndicator(
                            onRefresh: () {
                              return Future.delayed(const Duration(seconds: 1), () {
                                pullToRefresh();
                              });
                            },
                            child: _buildPosts(context))),
                  ),
                  // when the _loadMore function is running
                  // When nothing else to load
                  if (_hasNextPage == false)
                    Container(
                      padding: const EdgeInsets.only(top: 30, bottom: 40),
                      color: Colors.green,
                      child: const Center(
                        child: Text(
                          'You have fetched all of the content',
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                ]))*/
          ],
        ),
      ),
    );
  }

  ListView _buildPosts(BuildContext context) {
    return ListView.builder(
      itemBuilder: (context, index) {
        return Card(
          elevation: 4,
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
            leading:  Container(
              width: 20,
              height: 20,
              child:  SvgPicture.asset(
                "assets/svg/to-location-img.svg",
                width: 20,
                height: 20,
              ),
            ),
            onTap: () {},
          ),
        );
      },
      itemCount: searchPlaceList.length,
      padding: const EdgeInsets.all(8),
    );
  }

  TextField driverSearchBox() {
    return TextField(
      // controller: Tolocation,

      decoration: const InputDecoration(
        contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
        hintText: "Search",
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.grey,
          ),
        ),
        border: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.greenAccent)),
      ),
      onChanged: (String? str) {
        setState(() {
          Searchtext = str!;
        });
        _firstLoad();
      },
    );
  }

}
