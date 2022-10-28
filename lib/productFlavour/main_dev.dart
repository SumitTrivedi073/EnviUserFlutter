import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

import '../main.dart';
import '../notificationService/local_notification_service.dart';
import 'applicationconfig.dart';

void main() async {

  runZonedGuarded<Future<void>>(() async {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp();
    FirebaseMessaging.onBackgroundMessage(backgroundHandler);
    LocalNotificationService.initialize();
    FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(true);

    FlutterError.onError =
        FirebaseCrashlytics.instance.recordFlutterFatalError;

    ApplicationConfig devAppConfig = ApplicationConfig(appName: 'Envi Dev', flavor: 'qa');
    Widget app = await initializeApp(devAppConfig);
    runApp(app);

  }, (error, stack) =>
      FirebaseCrashlytics.instance.recordError(error, stack, fatal: true));


}
/*
flutter run -t lib/productFlavour/main_dev.dart  --flavor=dev
# Debug signing configuration + dev flavor
flutter run -t lib/main_dev.dart  --debug --flavor=dev
flutter run -t lib/main_dev.dart  --release --flavor=dev
flutter build appbundle -t lib/main_dev.dart  --flavor=dev
flutter build apk -t lib/main_dev.dart  --flavor=dev
*/