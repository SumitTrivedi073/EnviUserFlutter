import 'package:envi/UiWidget/cardbanner.dart';
import 'package:envi/ridehistory/ridehistoryPage.dart';
import 'package:envi/theme/theme.dart';
import 'package:envi/theme/responsive.dart';
import 'package:envi/web_service/Constant.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:envi/UiWidget/pageRoutes.dart';
import 'home/homePage.dart';
import 'login/login.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      title: 'Envi',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Malbork',
        theme: appTheme(),
        home: MainEntryPoint(),
        routes: {
          pageRoutes.login: (context) => Loginpage(),
          pageRoutes.homeMaster: (context) => HomePage(title: "title"),
          pageRoutes.ridehistories:(context) => RideHistoryPage(),
        },
      )
    );
  }
}

class MainEntryPoint extends StatefulWidget {
  @override
  State<MainEntryPoint> createState() => _MainEntryPointState();
}

class _MainEntryPointState extends State<MainEntryPoint> {
  late SharedPreferences sharedPreferences;

  @override
  void initState() {
    super.initState();
    checkLoginStatus();
  }

  checkLoginStatus() async {
    sharedPreferences = await SharedPreferences.getInstance();
    if (sharedPreferences.getString(LoginID) == null) {
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (BuildContext context) => const Loginpage()),
              (Route<dynamic> route) => false);
    } else {
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
              builder: (BuildContext context) => const HomePage(title: "title")),
              (Route<dynamic> route) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: Responsive.isXS(context)
                ? AssetImage(mobileLoginBackGround)
                : AssetImage(loginPageBackgroundImage),
            fit: BoxFit.fill,
          ),
        ),
      ),
    );
  }
}



//https://github.com/humazed/google_map_location_picker

