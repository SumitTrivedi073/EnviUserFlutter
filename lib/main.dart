import 'package:envi/appConfig/appConfig.dart';
import 'package:envi/appConfig/landingPageSettings.dart';
import 'package:envi/database/favoritesData.dart';
import 'package:envi/database/favoritesDataDao.dart';
import 'package:envi/provider/firestoreLiveTripDataNotifier.dart';
import 'package:envi/sidemenu/home/homePage.dart';
import 'package:envi/theme/theme.dart';
import 'package:envi/web_service/APIDirectory.dart';
import 'package:envi/web_service/Constant.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'database/database.dart';
import 'login/login.dart';
import 'dart:convert' as convert;
import '../../../../web_service/HTTP.dart' as HTTP;

Future<void> main() async {
WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
 //await FirebaseAuth.instance.useAuthEmulator('localhost', 9099);
final database = await $FloorFlutterDatabase
    .databaseBuilder('envi_uswer.db')
    .build();
final dao = database.taskDao;

  runApp(const MyApp());


// Ideal time to initialize

}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider.value(value: firestoreLiveTripDataNotifier()),

        ],
     child: MaterialApp(
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
    ));
  }
}

class MainEntryPoint extends StatefulWidget {
  @override
  State<MainEntryPoint> createState() => _MainEntryPointState();
}

class _MainEntryPointState extends State<MainEntryPoint> {
  late SharedPreferences sharedPreferences;
  late final FavoritesDataDao dao;

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
      GetAllFavouriteAddress();
      getLandingPageSettings();
      // ignore: use_build_context_synchronously
      context.read<firestoreLiveTripDataNotifier>()
          .listenToLiveUpdateStream();
    }
  /*  Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (BuildContext context) =>  MapDirectionWidget()),
            (Route<dynamic> route) => false);*/
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
    //  print(convert.jsonDecode(response.body)['applicationConfig']);
   // print(convert.jsonDecode(response.body)['landingPageSettings']);
LandingPageConfig.setshowInfoPopup(jsonData['landingPageSettings']['showInfoPopup']);
    LandingPageConfig.setinfoPopupType(jsonData['landingPageSettings']['infoPopupType']);
    LandingPageConfig.setautoExpiryDuration(jsonData['landingPageSettings']['autoExpiryDuration']);
    LandingPageConfig.setinfoPopupFrequency(jsonData['landingPageSettings']['infoPopupFrequency']);
    LandingPageConfig.setinfoPopupTitle(jsonData['landingPageSettings']['infoPopupTitle']);
    LandingPageConfig.setinfoPopupDescription(jsonData['landingPageSettings']['infoPopupDescription']);
    LandingPageConfig.setinfoPopupImgagedUrl(jsonData['landingPageSettings']['infoPopupImgagedUrl']);
    LandingPageConfig.setinfoPopupBackGroundColorCode(jsonData['landingPageSettings']['infoPopupBackGroundColorCode']);
    LandingPageConfig.setisInfoPopUpTransparent(jsonData['landingPageSettings']['isInfoPopUpTransparent']);
    LandingPageConfig.setisInfoPopUpFullScreen(jsonData['landingPageSettings']['isInfoPopUpFullScreen']);
LandingPageConfig.setisOnMaintainance(jsonData['landingPageSettings']['isOnMaintainance']);
    LandingPageConfig.setmaintainanceInfoTouser(jsonData['landingPageSettings']['maintainanceInfoTouser']);
    LandingPageConfig.setenableReferAndWin(jsonData['landingPageSettings']['enableReferAndWin']);
    LandingPageConfig.setinfoPopupId(jsonData['landingPageSettings']['infoPopupId']);
    LandingPageConfig.setcustomerCare(jsonData['landingPageSettings']['customerCare']);
    AppConfig.setminAndroidVersion(jsonData['applicationConfig']['swVersionConfig']['minAndroidVersion']);
    AppConfig.setminiOSVersion(jsonData['applicationConfig']['swVersionConfig']['miniOSVersion']);
    AppConfig.setandroidAppUrl(jsonData['applicationConfig']['swVersionConfig']['androidAppUrl']);
    AppConfig.setiosAppUrl(jsonData['applicationConfig']['swVersionConfig']['iosAppUrl']);
    AppConfig.setadvance_booking_time_limit(jsonData['applicationConfig']['scheduleTripConfig']['advance_booking_time_limit']);
    AppConfig.setdriver_assignment_time_limit(jsonData['applicationConfig']['scheduleTripConfig']['driver_assignment_time_limit']);
    AppConfig.setisScheduleFeatureEnabled(jsonData['applicationConfig']['scheduleTripConfig']['isScheduleFeatureEnabled']);
    AppConfig.setscheduleFreeDriverDistance(jsonData['applicationConfig']['scheduleTripConfig']['scheduleFreeDriverDistance']);
    AppConfig.setscheduleAllottedDriverDistance(jsonData['applicationConfig']['scheduleTripConfig']['scheduleAllottedDriverDistance']);
    AppConfig.setpaymentOptions(jsonData['applicationConfig']['paymentConfig']['paymentOptions'].toString());
    AppConfig.setdefaultPaymentMode(jsonData['applicationConfig']['paymentConfig']['defaultPaymentMode']);

      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
              builder: (BuildContext context) => const HomePage(title: "title")),
              (Route<dynamic> route) => false);
    } else {

    }
  }
  void GetAllFavouriteAddress() async {
    final database = await $FloorFlutterDatabase
        .databaseBuilder('envi_user.db')
        .build();
    final dao = database.taskDao;

dynamic userid =sharedPreferences.getString(LoginID);
    dynamic response = await HTTP.get(GetAllFavouriteAddressdata(userid));
    if (response != null && response.statusCode == 200) {

      List<dynamic>   jsonData = convert.jsonDecode(response.body)['content']['address'];
      // print(jsonData);
      for (var res in jsonData) {

        if(res["address"] != null || res["address"] != ""){
          String title = "";

          if(res["name"] != ""){
            title = res["name"];
          }else{
            final splitList = res["address"].split(",");
            title = splitList[1];

          }
         var data =  await dao.findByIdentifier(res["id"]) ;
          if(data == null) {
            final task = FavoritesData.optional(identifier: res["id"],
                address: res["address"],
                isFavourite: res["isFavourite"],
                latitude: res["location"]['coordinates'][1].toString(),
                longitude: res["location"]['coordinates'][0].toString(),
                title: title);
            print(task);
            await dao.insertTask(task);
          }
        }
      }

    } else {
      setState(() {

      });
    }
  }
}



//https://github.com/humazed/google_map_location_picker


