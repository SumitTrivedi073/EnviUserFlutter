import 'package:envi/UiWidget/pageRoutes.dart';
import 'package:envi/uiwidget/robotoTextWidget.dart';
import 'package:envi/uiwidget/sfcompactTextWidget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../theme/color.dart';
import '../theme/string.dart';
import '../theme/theme.dart';
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
      color: AppColor.drawercontainer,
      child: ListView(
        // Important: Remove any padding from the ListView.
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: const BoxDecoration(
              color: AppColor.drawertop,
            ),
            child: Container(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                      Container(
                        height: 70.0,
                        width: 70.0,
                        margin: const EdgeInsets.only(top: 20.0),
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(50.0),
                          child: getsmallNetworkImage(context,
                              "https://i.picsum.photos/id/1001/5616/3744.jpg?hmac=38lkvX7tHXmlNbI0HzZbtkJ6_wpWyqvkX4Ty6vYElZE"),
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      userDetails(),
                    ]),
                  ]),
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
            onTap: () {
              Navigator.pushReplacementNamed(context, pageRoutes.rideupcoming);
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
            onTap: () {
              Navigator.pushReplacementNamed(context, pageRoutes.ridehistories);
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
              "assets/svg/safety.svg",
              width: 22,
              height: 24,
            ),
            title: robotoTextWidget(
              textval: MenuSafety,
              colorval: AppColor.red,
              sizeval: 20.0,
              fontWeight: FontWeight.normal,
            ),
            onTap: () {
              Navigator.pushReplacementNamed(context, pageRoutes.homeMaster);
            },
          ),
          const SizedBox(
            height: 20,
          ),
          ListTile(
            leading: SvgPicture.asset(
              "assets/svg/fare-charges.svg",
              width: 22,
              height: 24,
            ),
            title: robotoTextWidget(
              textval: MenuFareCharges,
              colorval: AppColor.lightText,
              sizeval: 20.0,
              fontWeight: FontWeight.normal,
            ),
            onTap: () {
              Navigator.pushReplacementNamed(context, pageRoutes.homeMaster);
            },
          ),
          ListTile(
            leading: SvgPicture.asset(
              "assets/svg/favorite-places.svg",
              width: 22,
              height: 24,
            ),
            title: robotoTextWidget(
              textval: MenuFavoritePlaces,
              colorval: AppColor.lightText,
              sizeval: 20.0,
              fontWeight: FontWeight.normal,
            ),
            onTap: () {
              Navigator.pushReplacementNamed(context, pageRoutes.homeMaster);
            },
          ),
          ListTile(
            leading: SvgPicture.asset(
              "assets/svg/customer-care.svg",
              width: 22,
              height: 24,
            ),
            title: robotoTextWidget(
              textval: MenuCustomerCare,
              colorval: AppColor.lightText,
              sizeval: 20.0,
              fontWeight: FontWeight.normal,
            ),
            onTap: () {
              Navigator.pushReplacementNamed(context, pageRoutes.homeMaster);
            },
          ),
          ListTile(
            leading: SvgPicture.asset(
              "assets/svg/settings.svg",
              width: 22,
              height: 24,
            ),
            title: robotoTextWidget(
              textval: MenuSettings,
              colorval: AppColor.lightText,
              sizeval: 20.0,
              fontWeight: FontWeight.normal,
            ),
            onTap: () {
              Navigator.pushReplacementNamed(context, pageRoutes.homeMaster);
            },
          ),
          const SizedBox(
            height: 15,
          ),
          footerView(),
          const SizedBox(
            height: 15,
          ),
        ],
      ),
    ));
  }

  Column userDetails() {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          SizedBox(
            height: 10,
          ),
          robotoTextWidget(
            textval: 'Nitesh Gupta',
            colorval: AppColor.grey,
            fontWeight: FontWeight.w800,
            sizeval: 20.0,
          ),
          SizedBox(
            height: 10,
          ),
          robotoTextWidget(
            textval: 'SILVER LEVEL',
            colorval: AppColor.lightgreen,
            fontWeight: FontWeight.w600,
            sizeval: 14.0,
          ),
        ]);
  }

  Row footerView() {
    return Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const Padding(
              padding: EdgeInsets.only(left: 20),
              child: Divider(color: Colors.white)),
          Expanded(
            flex: 1,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                SFCompactTextWidget(
                    textval: "ENVI",
                    colorval: AppColor.lightText,
                    sizeval: 22.0,
                    fontWeight: FontWeight.normal)
              ],
            ),
          ),
        ]);
  }
}
