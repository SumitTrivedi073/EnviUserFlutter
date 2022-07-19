import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../web_service/Constant.dart';
import 'package:envi/UiWidget/pageRoutes.dart';

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
      child: ListView(
        // Important: Remove any padding from the ListView.
        padding: EdgeInsets.zero,
        children: <Widget>[
          UserAccountsDrawerHeader(
            accountName: Text("Admin", style: TextStyle(color: Colors.white)),
            accountEmail:
                Text(email ?? "", style: TextStyle(color: Colors.white)),
            currentAccountPicture: CircleAvatar(
              backgroundColor: Colors.white,
              child: Text(
                "A",
                style: TextStyle(fontSize: 40.0, color: Colors.green),
              ),
            ),
          ),
          ListTile(
            leading: Icon(Icons.home),
            title: Text(MenuBookaRide),
            onTap: () {
              Navigator.pushReplacementNamed(context, pageRoutes.homeMaster);
            },
          ),
           ListTile(
             leading: Icon(Icons.volume_up),
             title: Text(MenuScheduleaRide),
             onTap: () {
               Navigator.pushReplacementNamed(context, pageRoutes.promotion);
             },
           ),
          ListTile(
            leading: Icon(Icons.directions_car),
            title: Text(MenuUpcomingRide),
            onTap: () {
              Navigator.pushReplacementNamed(context, pageRoutes.cars);
            },
          ),
          ListTile(
            leading: Icon(Icons.person),
            title: Text(MenuRideHistory),
            onTap: () {
              Navigator.pushReplacementNamed(context, pageRoutes.drivers);
            },
          ),
          ListTile(
            leading: Icon(Icons.directions_car),
            title: Text(MenuSafety),
            onTap: () {
              Navigator.pushReplacementNamed(
                  context, pageRoutes.assign_vehicle);
            },
          ),
          ListTile(
            leading: Icon(Icons.ev_station),
            title: Text(MenuFareCharges),
            onTap: () {
              Navigator.pushReplacementNamed(
                  context, pageRoutes.charging_station);
            },
          ),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text(MenuFavoritePlaces),
            onTap: () {
              Navigator.pushReplacementNamed(
                  context, pageRoutes.development_option);
            },
          ),
          ListTile(
            leading: Icon(Icons.add_card_sharp),
            title: Text(MenuCustomerCare),
            onTap: () {
              Navigator.pushReplacementNamed(context, pageRoutes.manual_trip);
            },
          ),
          ListTile(
            leading: Icon(Icons.add_card_sharp),
            title: Text(MenuSettings),
            onTap: () {
              Navigator.pushReplacementNamed(context, pageRoutes.manual_trip);
            },
          ),
        ],
      ),
    );
  }
}
