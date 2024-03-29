import 'dart:async';
import 'dart:convert' as convert;
import 'dart:io' show Platform;

import 'package:device_info_plus/device_info_plus.dart';
import 'package:envi/appConfig/appConfig.dart';
import 'package:envi/appConfig/landingPageSettings.dart';
import 'package:envi/database/favoritesData.dart';
import 'package:envi/database/favoritesDataDao.dart';
import 'package:envi/provider/firestoreLiveTripDataNotifier.dart';
import 'package:envi/provider/firestoreScheduleTripNotifier.dart';
import 'package:envi/sidemenu/home/homePage.dart';
import 'package:envi/theme/color.dart';
import 'package:envi/theme/string.dart';
import 'package:envi/theme/theme.dart';
import 'package:envi/uiwidget/robotoTextWidget.dart';
import 'package:envi/web_service/APIDirectory.dart';
import 'package:envi/web_service/ApiConstants.dart';
import 'package:envi/web_service/Constant.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:google_maps_flutter_android/google_maps_flutter_android.dart';
import 'package:google_maps_flutter_platform_interface/google_maps_flutter_platform_interface.dart';
import 'package:one_context/one_context.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../web_service/HTTP.dart' as HTTP;
import 'appConfig/Profiledata.dart';
import 'database/database.dart';
import 'login/login.dart';
import 'notificationService/local_notification_service.dart';
import 'utils/utility.dart';

Future<void> backgroundHandler(RemoteMessage message) async {
  print(message.data.toString());
  print(message.notification!.title);
}

Future<void> main() async {
  runZonedGuarded<Future<void>>(() async {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp();
    FirebaseMessaging.onBackgroundMessage(backgroundHandler);
    LocalNotificationService.initialize();
    FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(true);

    FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;

    final database =
        await $FloorFlutterDatabase.databaseBuilder('envi_user.db').build();
    final dao = database.taskDao;

    final GoogleMapsFlutterPlatform mapsImplementation =
        GoogleMapsFlutterPlatform.instance;
    if (mapsImplementation is GoogleMapsFlutterAndroid) {
      mapsImplementation.useAndroidViewSurface = true;
    }

    runApp(const MyApp());
    if (Platform.isAndroid) {
      var androidInfo = await DeviceInfoPlugin().androidInfo;
      var sdkInt = androidInfo.version.sdkInt;
      if (sdkInt > 31) {
        checkPermission();
      }
    } else if (Platform.isIOS) {
      checkPermission();
    }
  },
      (error, stack) =>
          FirebaseCrashlytics.instance.recordError(error, stack, fatal: true));
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
  const MyApp({Key? key}) : super(key: key);

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
          theme: appTheme(),
          builder: OneContext().builder,
          home: MainEntryPoint(),
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
        const AndroidInitializationSettings('@drawable/ic_notification');
    const DarwinInitializationSettings initializationSettingsDarwin =
        DarwinInitializationSettings(
      requestSoundPermission: true,
      requestBadgePermission: true,
      requestAlertPermission: true,
    );
    var initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid,
        iOS: initializationSettingsDarwin);

    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    flutterLocalNotificationsPlugin.initialize(initializationSettings);

    FirebaseMessaging.instance.getInitialMessage().then(
      (message) {
        print("FirebaseMessaging.instance.getInitialMessage");
        if (message != null) {
          print("New Notification");
          checkLoginStatus();
          ShowPushNotificationExpand(
              message.notification!.title, message.notification!.body);
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
          //       LocalNotificationService.createanddisplaynotification(message);
          if (message != null) {
            ShowPushNotificationExpand(
                message.notification!.title, message.notification!.body);
          }
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
          if (message != null) {
            ShowPushNotificationExpand(
                message.notification!.title, message.notification!.body);
          }
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
      getLandingPageSettings();
      GetAllFavouriteAddress();

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
    dynamic response = await HTTP.get(context,getfetchLandingPageSettings());
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
      if (jsonData['applicationConfig']['generalConfig'] != null &&
          jsonData['applicationConfig']['generalConfig']['isBookNowEnabled'] !=
              null) {
        AppConfig.setisNormalBookingFeatureEnabled(
            jsonData['applicationConfig']['generalConfig']['isBookNowEnabled']);
      }
      if (jsonData['applicationConfig']['searchConfig'] != null) {
        AppConfig.setgoogleDirectionDriverIntervalInMin(
            jsonData['applicationConfig']['searchConfig']
                ['googleDirectionWFDriverIntervalInMin']);

        AppConfig.setgoogleDirectionDriverIntervalMaxTrialCount(
            jsonData['applicationConfig']['searchConfig']
                ['googleDirectionWFDriverIntervalMaxTrialCount']);

        AppConfig.setmaxAllowedDistance(jsonData['applicationConfig']
            ['searchConfig']['maxAllowedDistance']);
      }
      sharedPreferences.setInt(
          autoExpiryDurationText, LandingPageConfig().getautoExpiryDuration());
      // sharedPreferences.setString(
      //     infoPopupTypeText, LandingPageConfig().getinfoPopupType());
      sharedPreferences.setString(
          infoPopupImageUrlText, LandingPageConfig().getinfoPopupImgagedUrl());
      sharedPreferences.setString(
          infoPopupFrequencyText, LandingPageConfig().getinfoPopupFrequency());

      if (Platform.isAndroid) {
        if (AndroidAppVersion < AppConfig.minAndroidVersion) {
          softwareVersionUpdatePopup();
        } else {
          showInfoPopup();
        }
      } else if (Platform.isIOS) {
        if (IOSAppVersion < AppConfig.miniOSVersion) {
          softwareVersionUpdatePopup();
        } else {
          showInfoPopup();
        }
      }
    }
  }

  Future displayInfoPopup(int miliSecond) {
    Timer? timer = Timer(
        Duration(
            milliseconds: miliSecond != null && miliSecond != 0
                ? miliSecond
                : 10000), () {
      OneContext().popDialog('cancel');
    });
    return OneContext()
        .showDialog(
            barrierDismissible: false,
            builder: (_) {
              return AlertDialog(
                  content: Image.network(
                encodeImgURLString(
                  sharedPreferences.getString(infoPopupImageUrlText)!,
                ),
                fit: BoxFit.fill,
              ));
            })
        .then((value) {
      // dispose the timer in case something else has triggered the dismiss.
      timer?.cancel();
      timer = null;
    });
    ;
  }

  void GetAllFavouriteAddress() async {
    final database =
        await $FloorFlutterDatabase.databaseBuilder('envi_user.db').build();
    final dao = database.taskDao;

    dynamic response =
        await HTTP.get(context,GetAllFavouriteAddressdata(Profiledata().getusreid()));
    if (response != null && response.statusCode == 200) {
      if (convert.jsonDecode(response.body)['content'] != null &&
          convert.jsonDecode(response.body)['content']['address'] != null) {
        List<dynamic> jsonData =
            convert.jsonDecode(response.body)['content']['address'];
        // print(jsonData);
        for (var res in jsonData) {
          if (res["address"] != null || res["address"] != "") {
            String title = "";

            if (res["name"].toString().isNotEmpty) {
              title = res["name"];
            } else {
              if (res["address"].toString().contains(",")) {
                final splitList = res["address"].split(",");
                title = splitList[1];
              } else {
                final splitList = res["address"];
                title = splitList[1];
              }
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
                await dao.insertTask(task);
              } else {
                print("data$data");
              }
            } catch (e) {
              print(e.toString());
            }
          }
        }
      }
      if (!mounted) return;
      Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (BuildContext context) => const HomePage(title: "",)),
              (Route<dynamic> route) => false);

    }
  }

  void softwareVersionUpdatePopup() {
    OneContext().showDialog(
        barrierDismissible: false,
        builder: (_) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            content: SizedBox(
              height: 120,
              child: Center(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(5),
                      child: robotoTextWidget(
                          textval: appName,
                          colorval: AppColor.darkGreen,
                          sizeval: 16,
                          fontWeight: FontWeight.w800),
                    ),
                    const Padding(
                      padding: EdgeInsets.all(5),
                      child: robotoTextWidget(
                          textval:
                              'Latest Envi App is available please update first and enjoy',
                          colorval: AppColor.black,
                          sizeval: 14,
                          fontWeight: FontWeight.w600),
                    ),
                    SizedBox(
                      width: 100,
                      child: ElevatedButton(
                        onPressed: () {
                          if (Platform.isAndroid) {
                            launchUrl(
                              Uri.parse(AppConfig().getandroidAppUrl()),
                              mode: LaunchMode.externalApplication,
                            );
                          } else if (Platform.isIOS) {
                            launchUrl(
                              Uri.parse(AppConfig().getiosAppUrl()),
                              mode: LaunchMode.externalApplication,
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          primary: AppColor.darkGreen,
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(5), // <-- Radius
                          ),
                        ),
                        child: const robotoTextWidget(
                          textval: 'Ok',
                          colorval: AppColor.white,
                          sizeval: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            )));
  }

  void showInfoPopup() {
    if (LandingPageConfig().getshowInfoPopup()) {
      switch (LandingPageConfig().getinfoPopupFrequency()) {
        case 'EVERY_LAUNCH':
          displayInfoPopup(sharedPreferences.getInt(autoExpiryDurationText)!);
          break;
        case 'DAILY_ONCE':
          if (sharedPreferences.getString(dailyOnceTimeText) == null) {
            displayInfoPopup(sharedPreferences.getInt(autoExpiryDurationText)!);
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
            displayInfoPopup(sharedPreferences.getInt(autoExpiryDurationText)!);
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
  }

  Future ShowPushNotificationExpand(String? title, String? message) {
    return OneContext().showDialog(
        barrierDismissible: false,
        builder: (_) => AlertDialog(
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10))),
            content: Wrap(children: [
              Column(mainAxisSize: MainAxisSize.min, children: [
                Padding(
                  padding: const EdgeInsets.only(top: 5),
                  child: Text(
                    title!.toTitleCase(),
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
                        message!,
                        style: TextStyle(
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
                Container(
                  width: 100,
                  child: ElevatedButton(
                    onPressed: () {
                      OneContext().popDialog('Ok');
                    },
                    style: ElevatedButton.styleFrom(
                      primary: AppColor.darkGreen,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12), // <-- Radius
                      ),
                    ),
                    child: robotoTextWidget(
                      textval: 'Ok',
                      colorval: AppColor.white,
                      sizeval: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ]),
            ])));
  }
}
