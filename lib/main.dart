import 'package:envi/sidemenu/home/homePage.dart';
import 'package:envi/theme/theme.dart';
import 'package:envi/theme/responsive.dart';
import 'package:envi/web_service/APIDirectory.dart';
import 'package:envi/web_service/Constant.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'login/login.dart';
import 'dart:convert' as convert;
import '../../../../web_service/HTTP.dart' as HTTP;

Future<void> main() async {
WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
 //await FirebaseAuth.instance.useAuthEmulator('localhost', 9099);
  runApp(const MyApp());


// Ideal time to initialize

}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
print("==============MyApp");
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
    print("================_MainEntryPointState");
  }

  checkLoginStatus() async {
    sharedPreferences = await SharedPreferences.getInstance();
    if (sharedPreferences.getString(LoginID) == null) {
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (BuildContext context) => const Loginpage()),
              (Route<dynamic> route) => false);
    } else {

      getLandingPageSettings();
      // Navigator.of(context).pushAndRemoveUntil(
      //     MaterialPageRoute(
      //         builder: (BuildContext context) => const HomePage(title: "title")),
      //         (Route<dynamic> route) => false);
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
            image: AssetImage(PageBackgroundImage),
            fit: BoxFit.fill,
          ),
        ),
        child: Center(child:  Image.asset("assets/images/logo.png",width: 276,fit: BoxFit.fill,),
          ),
      ),
    );
  }
  void getLandingPageSettings() async {

    dynamic response = await HTTP.get(getfetchLandingPageSettings());
    if (response != null && response.statusCode == 200) {

    var  jsonData = convert.jsonDecode(response.body);
      print(jsonData);

      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
              builder: (BuildContext context) => const HomePage(title: "title")),
              (Route<dynamic> route) => false);
    } else {
      setState(() {

      });
    }
  }
}



//https://github.com/humazed/google_map_location_picker

