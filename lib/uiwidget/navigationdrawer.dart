import 'package:envi/UiWidget/pageRoutes.dart';
import 'package:envi/uiwidget/robotoTextWidget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../theme/color.dart';
import '../theme/string.dart';
import '../web_service/Constant.dart';

class NavigationDrawer extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _NavigationPageState();
}

class _NavigationPageState extends State<NavigationDrawer> {
  late SharedPreferences sharedPreferences;
  String? email;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    init();
  }

  init() async {
    sharedPreferences = await SharedPreferences.getInstance();
    setState(() {
      email = (sharedPreferences.getString(LoginEmail) ?? '');
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Drawer(
        child: Container(
      color: AppColor.c1,
      child: ListView(
        // Important: Remove any padding from the ListView.
        padding: EdgeInsets.zero,
        children: <Widget>[
          UserAccountsDrawerHeader(
            accountName:
                const Text("Admin", style: TextStyle(color: Colors.white)),
            accountEmail:
                Text(email ?? "", style: const TextStyle(color: Colors.white)),
            currentAccountPicture: const CircleAvatar(
              backgroundColor: Colors.white,
              child: Text(
                "A",
                style: TextStyle(fontSize: 40.0, color: Colors.green),
              ),
            ),
          ),
          ListTile(
            leading: SvgPicture.asset(
              "assets/svg/book-ride.svg",
              width: 22,
              height: 24,
            ),
            title: robotoTextWidget(
              textval: MenuBookaRide,
              colorval: AppColor.lightwhite,
              sizeval: 20.0,
              fontWeight: FontWeight.normal,
            ),
            // Text(MenuBookaRide,style: TextStyle(fontSize: 20.0, color: Colors.white, fontFamily: 'Roboto'),),
            onTap: () {
              Navigator.pushReplacementNamed(context, pageRoutes.homeMaster);
            },
          ),
          ListTile(
            leading: SvgPicture.asset(
              "assets/svg/schedule-ride.svg",
              width: 22,
              height: 24,
            ),
            title: robotoTextWidget(
              textval: MenuScheduleaRide,
              colorval: AppColor.lightwhite,
              sizeval: 20.0,
              fontWeight: FontWeight.normal,
            ),
            // Text(MenuBookaRide,style: TextStyle(fontSize: 20.0, color: Colors.white, fontFamily: 'Roboto'),),
            onTap: () {
              Navigator.pushReplacementNamed(context, pageRoutes.homeMaster);
            },
          ),
          const SizedBox(
            height: 10,
          ),
          const Padding(
              padding: EdgeInsets.only(left: 70),
              child: Divider(color: Colors.white)),
          const SizedBox(
            height: 10,
          ),
          ListTile(
            leading: SvgPicture.asset(
              "assets/svg/upcoming-rides.svg",
              width: 22,
              height: 24,
            ),
            title: robotoTextWidget(
              textval: MenuUpcomingRide,
              colorval: AppColor.lightwhite,
              sizeval: 20.0,
              fontWeight: FontWeight.normal,
            ),
            // Text(MenuBookaRide,style: TextStyle(fontSize: 20.0, color: Colors.white, fontFamily: 'Roboto'),),
            onTap: () {
              Navigator.pushReplacementNamed(context, pageRoutes.homeMaster);
            },
          ),
          ListTile(
            leading: SvgPicture.asset(
              "assets/svg/ride-history.svg",
              width: 22,
              height: 24,
            ),
            title: robotoTextWidget(
              textval: MenuRideHistory,
              colorval: AppColor.lightwhite,
              sizeval: 20.0,
              fontWeight: FontWeight.normal,
            ),
            // Text(MenuBookaRide,style: TextStyle(fontSize: 20.0, color: Colors.white, fontFamily: 'Roboto'),),
            onTap: () {
              Navigator.pushReplacementNamed(context, pageRoutes.homeMaster);
            },
          ),
          const SizedBox(
            height: 10,
          ),
          const Padding(
              padding: EdgeInsets.only(left: 70),
              child: Divider(color: Colors.white)),
          const SizedBox(
            height: 10,
          ),
          ListTile(
            leading: const Icon(Icons.directions_car),
            title: Text(MenuSafety),
            onTap: () {
              Navigator.pushReplacementNamed(
                  context, pageRoutes.assign_vehicle);
            },
          ),
          ListTile(
            leading: const Icon(Icons.ev_station),
            title: Text(MenuFareCharges),
            onTap: () {
              Navigator.pushReplacementNamed(
                  context, pageRoutes.charging_station);
            },
          ),
          ListTile(
            leading: const Icon(Icons.settings),
            title: Text(MenuFavoritePlaces),
            onTap: () {
              Navigator.pushReplacementNamed(
                  context, pageRoutes.development_option);
            },
          ),
          ListTile(
            leading: const Icon(Icons.add_card_sharp),
            title: Text(MenuCustomerCare),
            onTap: () {
              Navigator.pushReplacementNamed(context, pageRoutes.manual_trip);
            },
          ),
          ListTile(
            leading: const Icon(Icons.add_card_sharp),
            title: Text(MenuSettings),
            onTap: () {
              Navigator.pushReplacementNamed(context, pageRoutes.manual_trip);
            },
          ),
        ],
      ),
    ));
  }
}
