import 'package:flutter/material.dart';

import '../main.dart';
import 'applicationconfig.dart';

void main() async {
  ApplicationConfig devAppConfig = ApplicationConfig(appName: 'Envi Dev', flavor: 'qa');
  Widget app = await initializeApp(devAppConfig);
  runApp(app);
}
/*
flutter run -t lib/productFlavour/main_dev.dart  --flavor=dev
# Debug signing configuration + dev flavor
flutter run -t lib/main_dev.dart  --debug --flavor=dev
flutter run -t lib/main_dev.dart  --release --flavor=dev
flutter build appbundle -t lib/main_dev.dart  --flavor=dev
flutter build apk -t lib/main_dev.dart  --flavor=dev
*/