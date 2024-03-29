import 'package:envi/Profile/newprofilePage.dart';
import 'package:envi/login/login.dart';
import 'package:envi/sidemenu/ridehistory/ridehistoryPage.dart';
import 'package:envi/sidemenu/upcomingride/upcomingridesPage.dart';
import 'package:envi/uiwidget/robotoTextWidget.dart';
import 'package:envi/uiwidget/sfcompactTextWidget.dart';
import 'package:envi/web_service/Constant.dart';
import 'package:envi/web_service/HTTP.dart' as HTTP;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../appConfig/Profiledata.dart';
import '../appConfig/landingPageSettings.dart';
import '../login/model/LoginModel.dart';
import '../sidemenu/favoritePlaces/favoritePlacesPage.dart';
import '../theme/color.dart';
import '../theme/images.dart';
import '../theme/string.dart';
import '../utils/utility.dart';
import '../web_service/APIDirectory.dart';

class NavigationDrawer extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _NavigationPageState();
}

class _NavigationPageState extends State<NavigationDrawer> {
  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  _launchURLApp(url) async {
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      throw 'Could not launch $url';
    }
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
            child: GestureDetector(
              onTap: () {
                LoginModel user = LoginModel(
                    Profiledata().gettoken(),
                    Profiledata().getusreid(),
                    Profiledata().getname(),
                    Profiledata().getpropic(),
                    Profiledata().getgender(),
                    Profiledata().getphone(),
                    Profiledata().getmailid());
                closeDrawer();
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => NewProfilePage(
                              user: user,
                              isUpdate: true,
                            )));
              },
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
                            borderRadius: BorderRadius.circular(40.0),
                            child: Image.network(
                              encodeImgURLString(Profiledata.propic),
                              errorBuilder: (context, error, stackTrace) {
                                return Image.asset(
                                  Images.personPlaceHolderImage,
                                  height: 40,
                                  width: 40,
                                );
                              },
                              fit: BoxFit.fill,
                              height: 40,
                              width: 40,
                            )),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      userDetails(),
                    ]),
                  ]),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
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
              // closeDrawer();
              showDialog(
                context: context,
                builder: (BuildContext context) => dialogueLogout(context),
              );
            },
          ),
          ListTile(
            leading: const Icon(
              Icons.delete,
              size: 24,
              color: AppColor.red,
            ),
            title: robotoTextWidget(
              textval: menudeleteaccount,
              colorval: AppColor.red,
              sizeval: 20.0,
              fontWeight: FontWeight.normal,
            ),
            onTap: () {
              //  closeDrawer();
              showDialog(
                context: context,
                builder: (BuildContext context) => dialogueDelete(context),
              );
            },
          ),
          Padding(
            padding: const EdgeInsets.only(left: 10, right: 10),
            child: footerView(),
          )
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
        textval: Profiledata().getname().toString().toTitleCase(),
        colorval: AppColor.grey,
        fontWeight: FontWeight.w800,
        sizeval: 20.0,
      ),
      const SizedBox(
        height: 5,
      ),
      robotoTextWidget(
        textval: Profiledata().getmailid().toString(),
        colorval: Colors.grey,
        fontWeight: FontWeight.w400,
        sizeval: 10.0,
      ),
    ]);
  }

  Row footerView() {
    return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          const SFCompactTextWidget(
              textval: "ENVI",
              colorval: AppColor.lightText,
              sizeval: 22.0,
              fontWeight: FontWeight.normal),
          Row(
            children: [
              GestureDetector(
                onTap: () {
                  var url = Uri.parse(instagramUrl);
                  _launchURLApp(url);
                },
                child: Image.asset(
                  "assets/images/instagram.png",
                ),
              ),
              const SizedBox(
                width: 25,
              ),
              GestureDetector(
                onTap: () {
                  var url = Uri.parse(FacebookUrl);

                  _launchURLApp(url);
                },
                child: Image.asset(
                  "assets/images/facebook.png",
                ),
              ),
              const SizedBox(
                width: 25,
              ),
              GestureDetector(
                onTap: () {
                  var url = Uri.parse(twitterUrl);
                  _launchURLApp(url);
                },
                child: Image.asset(
                  "assets/images/twitter.png",
                ),
              ),
              const SizedBox(
                width: 25,
              ),
            ],
          )
        ]);
  }

  void closeDrawer() {
    Navigator.pop(context);
  }

  Widget dialogueDelete(BuildContext context) {
    return AlertDialog(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10))),
        content: Wrap(children: [
          Column(mainAxisSize: MainAxisSize.min, children: [
            Padding(
              padding: const EdgeInsets.only(top: 5),
              child: Text(
                appName,
                style: const TextStyle(
                    color: AppColor.butgreen,
                    fontFamily: 'Roboto',
                    fontWeight: FontWeight.w600,
                    fontSize: 18),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Container(
              alignment: Alignment.center,
              child: Wrap(
                children: [
                  Text(
                    deleteaccountConfirmation,
                    style: const TextStyle(
                        color: AppColor.black,
                        fontSize: 14,
                        fontWeight: FontWeight.w600),
                  )
                ],
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
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
                ElevatedButton(
                  onPressed: () {
                    deleteacountApiCall(context);
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
              ],
            ),
          ]),
        ]));
  }

  Widget dialogueLogout(BuildContext context) {
    return AlertDialog(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10))),
        content: Container(
          child: Column(mainAxisSize: MainAxisSize.min, children: [
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Flexible(
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
                Flexible(
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
            )
          ]),
        ));
  }

  Future<void> confirmLogout(BuildContext context) async {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    await _auth.signOut();

    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    try {
      dynamic res = await HTTP.get(context, userLogout());
    } catch (e) {
      showToast(e.toString());
    }

    showToast("Logout SuccessFully");
    sharedPreferences.clear();

    Profiledata.setusreid("");
    Profiledata.settoken("");
    Profiledata.setmailid("");
    Profiledata.setpropic("");
    Profiledata.setphone("");
    Profiledata.setgender("");
    Profiledata.setname("");

    Navigator.of(context, rootNavigator: true).push(MaterialPageRoute(
        builder: (BuildContext context) => const Loginpage()));
  }

  Future<void> deleteacountApiCall(BuildContext context) async {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    await _auth.signOut();

    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    dynamic res = await HTTP.postwithoutdata(
        context, userdeRegisterMe(), null); //post(userdeRegisterMe());
    print(res.statusCode);
    if (res.statusCode == 200) {
      showToast("Deleted Account SuccessFully");
      sharedPreferences.clear();

      Profiledata.setusreid("");
      Profiledata.settoken("");
      Profiledata.setmailid("");
      Profiledata.setpropic("");
      Profiledata.setphone("");

      Profiledata.setgender("");
      Profiledata.setname("");

      Navigator.of(context, rootNavigator: true).push(MaterialPageRoute(
          builder: (BuildContext context) => const Loginpage()));
    } else {
      showToast("Failed to Delete");
    }
  }
}
