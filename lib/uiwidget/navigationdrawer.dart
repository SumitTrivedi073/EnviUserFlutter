import 'package:envi/login/login.dart';
import 'package:envi/sidemenu/home/homePage.dart';
import 'package:envi/sidemenu/ridehistory/ridehistoryPage.dart';
import 'package:envi/sidemenu/upcomingride/upcomingridesPage.dart';
import 'package:envi/uiwidget/robotoTextWidget.dart';
import 'package:envi/uiwidget/sfcompactTextWidget.dart';
import 'package:envi/web_service/HTTP.dart' as HTTP;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../appConfig/Profiledata.dart';
import '../appConfig/landingPageSettings.dart';
import '../sidemenu/favoritePlaces/favoritePlacesPage.dart';
import '../theme/color.dart';
import '../theme/string.dart';
import '../theme/theme.dart';
import '../utils/utility.dart';
import '../web_service/APIDirectory.dart';
import '../web_service/Constant.dart';

class NavigationDrawer extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _NavigationPageState();
}

class _NavigationPageState extends State<NavigationDrawer> {
  String? email;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    init();
  }

  init() async {
    setState(() {
      email = Profiledata().getmailid();
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
                          child: getsmallNetworkImage(
                              context, encodeImgURLString(Profiledata.propic)),
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
          // ListTile(
          //   leading: SvgPicture.asset(
          //     "assets/svg/book-ride.svg",
          //     width: 22,
          //     height: 24,
          //   ),
          //   title: robotoTextWidget(
          //     textval: MenuBookaRide,
          //     colorval: AppColor.lightwhite,
          //     sizeval: 20.0,
          //     fontWeight: FontWeight.normal,
          //   ),
          //   onTap: () {
          //     closeDrawer();
          //     Navigator.of(context).pushAndRemoveUntil(
          //         MaterialPageRoute(
          //             builder: (context) => HomePage(title: 'title')),
          //         (route) => true);
          //   },
          // ),
          // ListTile(
          //   leading: SvgPicture.asset(
          //     "assets/svg/schedule-ride.svg",
          //     width: 22,
          //     height: 24,
          //   ),
          //   title: robotoTextWidget(
          //     textval: MenuScheduleaRide,
          //     colorval: AppColor.lightwhite,
          //     sizeval: 20.0,
          //     fontWeight: FontWeight.normal,
          //   ),
          //   onTap: () {
          //     closeDrawer();
          //   },
          // ),
          const SizedBox(
            height: 10,
          ),
          // const Padding(
          //     padding: EdgeInsets.only(left: 70),
          //     child: Divider(color: Colors.white)),
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
              closeDrawer();
              Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => UpcomingRidesPage()),
                  (route) => true);
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
              closeDrawer();
              Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => RideHistoryPage()),
                  (route) => true);
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
              closeDrawer();
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
              closeDrawer();
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
              closeDrawer();
              Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => FavoritePlacesPage()),
                  (route) => true);
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
              closeDrawer();
              makingPhoneCall(LandingPageConfig().getcustomerCare() != null
                  ? LandingPageConfig().getcustomerCare()
                  : '');
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
              closeDrawer();
            },
          ),
          ListTile(
            leading: const Icon(
              Icons.privacy_tip,
              size: 24,
              color: Color(0xFF567b6b),
            ),
            title: robotoTextWidget(
              textval: MenuPrivacyPolicy,
              colorval: AppColor.lightText,
              sizeval: 20.0,
              fontWeight: FontWeight.normal,
            ),
            onTap: () {
              closeDrawer();
             launchUrlString('https://www.malbork.in/#/privacy');
            },
          ),
          ListTile(
            leading: const Icon(
              Icons.logout,
              size: 24,
              color: Color(0xFF567b6b),
            ),
            title: robotoTextWidget(
              textval: MenuLogout,
              colorval: AppColor.lightText,
              sizeval: 20.0,
              fontWeight: FontWeight.normal,
            ),
            onTap: () {
              closeDrawer();
              showDialog(
                context: context,
                builder: (BuildContext context) => dialogueLogout(context),
              );
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
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      const SizedBox(
        height: 10,
      ),
      robotoTextWidget(
        textval: Profiledata().getname().toString(),
        colorval: AppColor.grey,
        fontWeight: FontWeight.w800,
        sizeval: 20.0,
      ),
      const SizedBox(
        height: 10,
      ),
      const robotoTextWidget(
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

  void closeDrawer() {
    Navigator.pop(context);
  }

  Widget dialogueLogout(BuildContext context) {
    return AlertDialog(
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10))),
      content: SizedBox(
          height: 100,
          child: Column(children: [
            Padding(
              padding: const EdgeInsets.only(top: 5),
              child: Text(
                appName,
                style: const TextStyle(
                    color: AppColor.butgreen,
                    fontFamily: 'Roboto',
                    fontWeight: FontWeight.w600,
                    fontSize: 14),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              logoutConfirmation,
              style: const TextStyle(
                  color: AppColor.butgreen,
                  fontFamily: 'Roboto',
                  fontWeight: FontWeight.w600,
                  fontSize: 14),
            ),
            const SizedBox(
              height: 10,
            ),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      style: ElevatedButton.styleFrom(
                        primary: AppColor.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12), // <-- Radius
                        ),
                      ),
                      child: robotoTextWidget(
                        textval: cancel,
                        colorval: AppColor.greyblack,
                        sizeval: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        confirmLogout(context);
                      },
                      style: ElevatedButton.styleFrom(
                        primary: AppColor.greyblack,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12), // <-- Radius
                        ),
                      ),
                      child: robotoTextWidget(
                        textval: confirm,
                        colorval: AppColor.white,
                        sizeval: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            )
          ])),
    );
  }

  Future<void> confirmLogout(BuildContext context) async {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    await _auth.signOut();

    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    try {
      dynamic res = await HTTP.get(userLogout());
    } catch (e) {}

    showToast("Logout SuccessFully");
    sharedPreferences.clear();

    Profiledata.setusreid("");
    Profiledata.settoken("");
    Profiledata.setmailid("");
    Profiledata.setpropic("");
    Profiledata.setphone("");
    Profiledata.setgender("");
    Profiledata.setname("");
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (BuildContext context) => const Loginpage()),
        (Route<dynamic> route) => false);
  }
}
