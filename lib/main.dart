import 'package:envi/database/favoritesData.dart';
import 'package:envi/database/favoritesDataDao.dart';
import 'package:envi/productFlavour/appconfig.dart';
import 'package:envi/provider/firestoreLiveTripDataNotifier.dart';
import 'package:envi/provider/firestoreScheduleTripNotifier.dart';
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

Future<Widget> initializeApp(AppConfig appConfig) async {
WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
 //await FirebaseAuth.instance.useAuthEmulator('localhost', 9099);
final database = await $FloorFlutterDatabase
    .databaseBuilder('envi_user.db')
    .build();
return MyApp(appConfig);


// Ideal time to initialize

}

class MyApp extends StatelessWidget {

  final AppConfig appConfig;
  const MyApp(this.appConfig);

  Widget _flavorBanner(Widget child) {
    return Banner(
      child: child,
      location: BannerLocation.topEnd,
      message: appConfig.flavor,
      color: appConfig.flavor == 'qa'
          ? Colors.red.withOpacity(0.6)
          : Colors.green.withOpacity(0.6),
      textStyle: TextStyle(
          fontWeight: FontWeight.w700, fontSize: 14.0, letterSpacing: 1.0),
      textDirection: TextDirection.ltr,
    );
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider.value(value: firestoreLiveTripDataNotifier()),
          ChangeNotifierProvider.value(value: firestoreScheduleTripNotifier()),
        ],
     child: MaterialApp(
      title: 'Envi',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Envi',
        theme: appTheme(),
        home: _flavorBanner(
          MainEntryPoint(),
        ),
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
      context.read<firestoreScheduleTripNotifier>()
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
     // print(jsonData);

      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
              builder: (BuildContext context) => const HomePage(title: "title")),
              (Route<dynamic> route) => false);
    } else {
      setState(() {

      });
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
       print(jsonData);
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
          else{
            print("data$data");

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


