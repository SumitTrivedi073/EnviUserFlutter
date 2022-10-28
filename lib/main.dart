import 'dart:async';
import 'dart:convert' as convert;

import 'package:envi/appConfig/appConfig.dart';
import 'package:envi/appConfig/landingPageSettings.dart';
import 'package:envi/database/favoritesData.dart';
import 'package:envi/database/favoritesDataDao.dart';
import 'package:envi/productFlavour/applicationconfig.dart';
import 'package:envi/provider/firestoreLiveTripDataNotifier.dart';
import 'package:envi/provider/firestoreScheduleTripNotifier.dart';
import 'package:envi/sidemenu/home/homePage.dart';
import 'package:envi/theme/string.dart';
import 'package:envi/theme/theme.dart';
import 'package:envi/web_service/APIDirectory.dart';
import 'package:envi/web_service/Constant.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'appConfig/Profiledata.dart';

import '../../../../web_service/HTTP.dart' as HTTP;
import 'database/database.dart';
import 'login/login.dart';
import 'notificationService/local_notification_service.dart';
import 'utils/utility.dart';

Future<void> backgroundHandler(RemoteMessage message) async {
  print(message.data.toString());
  print(message.notification!.title);
}

Future<Widget> initializeApp(ApplicationConfig appConfig) async {
  //await FirebaseAuth.instance.useAuthEmulator('localhost', 9099);
  final database = await $FloorFlutterDatabase
      .databaseBuilder('envi_user.db')
      .build();
  return MyApp(appConfig);
}
Future checkPermission() async {


  FirebaseMessaging messaging = FirebaseMessaging.instance;

  NotificationSettings settings = await messaging.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );

  if (settings.authorizationStatus == AuthorizationStatus.authorized) {
    print('User granted permission');
  } else if (settings.authorizationStatus == AuthorizationStatus.provisional) {
    print('User granted provisional permission');
  } else {
    print('User declined or has not accepted permission');
  }
}

class MyApp extends StatelessWidget {

  final ApplicationConfig appConfig;
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
  late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  @override
  void initState() {
    super.initState();
    checkLoginStatus();
    receiveNotification();
  }

  int hrsBetween(DateTime from, DateTime to) {
    from = DateTime(
        from.year, from.month, from.day, from.hour, from.minute, from.second);
    to = DateTime(to.year, to.month, to.day, to.hour, to.minute, to.second);
    return (to.difference(from).inHours);
  }

  void receiveNotification() {
    var initializationSettingsAndroid =
        AndroidInitializationSettings('@drawable/ic_notification');
    var initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    flutterLocalNotificationsPlugin.initialize(initializationSettings);
    FirebaseMessaging.instance.getInitialMessage().then(
      (message) {
        print("FirebaseMessaging.instance.getInitialMessage");
        if (message != null) {
          print("New Notification");
          checkLoginStatus();
        }
      },
    );

    // 2. This method only call when App in forground it mean app must be opened
    FirebaseMessaging.onMessage.listen(
      (message) {
        print("FirebaseMessaging.onMessage.listen");
        if (message.notification != null) {
          print(message.notification!.title);
          print(message.notification!.body);
          print("message.data11 ${message.data}");
          LocalNotificationService.createanddisplaynotification(message);
        }
      },
    );

    // 3. This method only call when App in background and not terminated(not closed)
    FirebaseMessaging.onMessageOpenedApp.listen(
      (message) {
        print("FirebaseMessaging.onMessageOpenedApp.listen");
        if (message.notification != null) {
          print(message.notification!.title);
          print(message.notification!.body);
          print("message.data22 ${message.data['_id']}");
        }
      },
    );
  }

  checkLoginStatus() async {
    sharedPreferences = await SharedPreferences.getInstance();
    if (sharedPreferences.getString(loginID) == null) {
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
              builder: (BuildContext context) => const Loginpage()),
          (Route<dynamic> route) => false);
    } else {
      SetProfileData();
      GetAllFavouriteAddress();
      getLandingPageSettings();

      // ignore: use_build_context_synchronously
      context.read<firestoreLiveTripDataNotifier>().listenToLiveUpdateStream();
      context.read<firestoreScheduleTripNotifier>().listenToLiveUpdateStream();
    }
  }

  void SetProfileData() {
    Profiledata.setusreid(sharedPreferences.getString(loginID) ?? "");
    Profiledata.settoken(sharedPreferences.getString(loginToken) ?? "");
    Profiledata.setmailid(sharedPreferences.getString(loginEmail) ?? "");
    Profiledata.setpropic(sharedPreferences.getString(loginpropic) ?? "");
    Profiledata.setphone(sharedPreferences.getString(loginPhone) ?? "");
    Profiledata.setgender(sharedPreferences.getString(logingender) ?? "");
    Profiledata.setname(sharedPreferences.getString(loginName) ?? "");
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
        child: Center(
          child: Image.asset(
            "assets/images/envi-logo-small.png",
            width: 250,
            fit: BoxFit.fill,
          ),
        ),
      ),
    );
  }

  void getLandingPageSettings() async {
    dynamic response = await HTTP.get(getfetchLandingPageSettings());
    print(convert.jsonDecode(response.body));
    if (response != null && response.statusCode == 200) {
      var jsonData = convert.jsonDecode(response.body);
      print("jsonData==========>${jsonData.toString()}");

      LandingPageConfig.setshowInfoPopup(
          jsonData['landingPageSettings']['showInfoPopup']);
      LandingPageConfig.setinfoPopupType(
          jsonData['landingPageSettings']['infoPopupType']);

      LandingPageConfig.setautoExpiryDuration(
          jsonData['landingPageSettings']['autoExpiryDuration']);

      LandingPageConfig.setinfoPopupFrequency(
          jsonData['landingPageSettings']['infoPopupFrequency']);

      LandingPageConfig.setinfoPopupTitle(
          jsonData['landingPageSettings']['infoPopupTitle']);
      LandingPageConfig.setinfoPopupDescription(
          jsonData['landingPageSettings']['infoPopupDescription']);
      LandingPageConfig.setinfoPopupImgagedUrl(
          jsonData['landingPageSettings']['infoPopupImgagedUrl']);

      LandingPageConfig.setinfoPopupBackGroundColorCode(
          jsonData['landingPageSettings']['infoPopupBackGroundColorCode']);
      LandingPageConfig.setisInfoPopUpTransparent(
          jsonData['landingPageSettings']['isInfoPopUpTransparent']);
      LandingPageConfig.setisInfoPopUpFullScreen(
          jsonData['landingPageSettings']['isInfoPopUpFullScreen']);
      LandingPageConfig.setisOnMaintainance(
          jsonData['landingPageSettings']['isOnMaintainance']);
      LandingPageConfig.setmaintainanceInfoTouser(
          jsonData['landingPageSettings']['maintainanceInfoTouser']);
      LandingPageConfig.setenableReferAndWin(
          jsonData['landingPageSettings']['enableReferAndWin']);
      LandingPageConfig.setinfoPopupId(
          jsonData['landingPageSettings']['infoPopupId']);

      LandingPageConfig.setcustomerCare(
          jsonData['landingPageSettings']['customerCare']);
      AppConfig.setminAndroidVersion(jsonData['applicationConfig']
          ['swVersionConfig']['minAndroidVersion']);
      AppConfig.setminiOSVersion(
          jsonData['applicationConfig']['swVersionConfig']['miniOSVersion']);
      AppConfig.setandroidAppUrl(
          jsonData['applicationConfig']['swVersionConfig']['androidAppUrl']);
      AppConfig.setiosAppUrl(
          jsonData['applicationConfig']['swVersionConfig']['iosAppUrl']);
      AppConfig.setadvance_booking_time_limit(jsonData['applicationConfig']
          ['scheduleTripConfig']['advance_booking_time_limit']);
      AppConfig.setdriver_assignment_time_limit(jsonData['applicationConfig']
          ['scheduleTripConfig']['driver_assignment_time_limit']);
      AppConfig.setisScheduleFeatureEnabled(jsonData['applicationConfig']
          ['scheduleTripConfig']['isScheduleFeatureEnabled']);
      AppConfig.setscheduleFreeDriverDistance(jsonData['applicationConfig']
          ['scheduleTripConfig']['scheduleFreeDriverDistance']);
      AppConfig.setscheduleAllottedDriverDistance(jsonData['applicationConfig']
          ['scheduleTripConfig']['scheduleAllottedDriverDistance']);
      AppConfig.setpaymentOptions(jsonData['applicationConfig']['paymentConfig']
              ['paymentOptions']
          .toString());
      AppConfig.setdefaultPaymentMode(
          jsonData['applicationConfig']['paymentConfig']['defaultPaymentMode']);
      AppConfig.setisCancellationFeeApplicable(jsonData['applicationConfig']
          ['priceConfig']['isCancellationFeeApplicable']);
      AppConfig.setcancellationFee(
          jsonData['applicationConfig']['priceConfig']['cancellationFee']);
      if (!mounted) return;
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
              builder: (BuildContext context) =>
                  const HomePage(title: "title")),
          (Route<dynamic> route) => false);
      sharedPreferences.setInt(
          autoExpiryDurationText, LandingPageConfig().getautoExpiryDuration());
      // sharedPreferences.setString(
      //     infoPopupTypeText, LandingPageConfig().getinfoPopupType());
      sharedPreferences.setString(
          infoPopupImageUrlText, LandingPageConfig().getinfoPopupImgagedUrl());
      sharedPreferences.setString(
          infoPopupFrequencyText, LandingPageConfig().getinfoPopupFrequency());
      if (LandingPageConfig().getshowInfoPopup()) {
        switch (LandingPageConfig().getinfoPopupFrequency()) {
          case 'EVERY_LAUNCH':
            displayInfoPopup(sharedPreferences.getInt(autoExpiryDurationText)!);
            break;
          case 'DAILY_ONCE':
            if (sharedPreferences.getString(dailyOnceTimeText) == null) {
              displayInfoPopup(
                  sharedPreferences.getInt(autoExpiryDurationText)!);
              sharedPreferences.setString(
                  dailyOnceTimeText, DateTime.now().toString());
            } else {
              if (hrsBetween(
                      DateTime.parse(
                          sharedPreferences.getString(dailyOnceTimeText)!),
                      DateTime.now()) >
                  24) {
                displayInfoPopup(
                    sharedPreferences.getInt(autoExpiryDurationText)!);
                sharedPreferences.setString(
                    dailyOnceTimeText, DateTime.now().toString());
              }
            }
            break;
          case 'ONLY_ONCE':
            if (sharedPreferences.getString(infoPopupIdText) == null) {
              displayInfoPopup(
                  sharedPreferences.getInt(autoExpiryDurationText)!);
            } else {
              if (sharedPreferences.getString(infoPopupIdText) !=
                  LandingPageConfig().getinfoPopupId()) {
                displayInfoPopup(
                    sharedPreferences.getInt(autoExpiryDurationText)!);
              }
            }
            sharedPreferences.setString(
                infoPopupIdText, LandingPageConfig().getinfoPopupId());
            break;
          default:
            break;
        }
      }
    } else {}
  }

  Future displayInfoPopup(int miliSecond)  {
    return  showDialog(
        context: context,
        builder: ((context) {
          Future.delayed(
            Duration(milliseconds: miliSecond + 2000),
            () {
              Navigator.of(context).pop();
            },
          );

          return Dialog(
              child: Image.network(
            encodeImgURLString(
              sharedPreferences.getString(infoPopupImageUrlText)!,
            ),
            fit: BoxFit.fill,
          ));
        }));
  }

  void GetAllFavouriteAddress() async {
    final database =
        await $FloorFlutterDatabase.databaseBuilder('envi_user.db').build();
    final dao = database.taskDao;

    dynamic response =
        await HTTP.get(GetAllFavouriteAddressdata(Profiledata().getusreid()));
    if (response != null && response.statusCode == 200) {
      List<dynamic> jsonData =
          convert.jsonDecode(response.body)['content']['address'];
      // print(jsonData);
      for (var res in jsonData) {
        if (res["address"] != null || res["address"] != "") {
          String title = "";

          if (res["name"] != "") {
            title = res["name"];
          } else {
            final splitList = res["address"].split(",");
            title = splitList[1];
          }
          try {
            var data = await dao.findDataByaddressg(res["address"]);
            if (data == null) {
              final task = FavoritesData.optional(
                  identifier: res["id"],
                  address: res["address"],
                  isFavourite: res["isFavourite"],
                  latitude: res["location"]['coordinates'][1].toString(),
                  longitude: res["location"]['coordinates'][0].toString(),
                  title: title);
              print(task);
              await dao.insertTask(task);
            } else {
              print("data$data");
            }
          } catch (e) {
            print(e.toString());
          }
        }
      }
    } else {
      setState(() {});
    }
  }
}
