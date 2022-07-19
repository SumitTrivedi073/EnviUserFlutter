import 'package:envi/UiWidget/cardbanner.dart';
import 'package:envi/theme/Theme.dart';
import 'package:envi/theme/responsive.dart';
import 'package:envi/web_service/Constant.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:envi/UiWidget/pageRoutes.dart';

import 'UiWidget/appbar.dart';
import 'controller/home/homePage.dart';
import 'login/login.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Envi',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Malbork',
        theme: appTheme(),
        home: MainEntryPoint(),
        routes: {
          
          pageRoutes.login: (context) => Loginpage(),
          pageRoutes.setting: (context) => HomePage(title: "title"),

          
        },
      )
    );
  }
}

class MainEntryPoint extends StatefulWidget {
  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  @override
  State<MainEntryPoint> createState() => _MainEntryPointState();
}

class _MainEntryPointState extends State<MainEntryPoint> {
  late SharedPreferences sharedPreferences;

  @override
  void initState() {
    super.initState();
    // firestoreConn(setLiveDataStream);

    checkLoginStatus();
  }

  checkLoginStatus() async {
    sharedPreferences = await SharedPreferences.getInstance();
    if (sharedPreferences.getString(LoginID) == null) {
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (BuildContext context) => Loginpage()),
              (Route<dynamic> route) => false);
    } else {
      //firestoreConnAlerts();

      Navigator.of(context).pushAndRemoveUntil(
        // MaterialPageRoute(builder: (BuildContext context) => MainPage()),
          MaterialPageRoute(
              builder: (BuildContext context) => HomePage(title: "title")),
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

