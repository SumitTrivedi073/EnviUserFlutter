import 'package:flutter/material.dart';

import '../main.dart';
import 'applicationconfig.dart';

void main() async {
  ApplicationConfig devAppConfig =
  ApplicationConfig(appName: 'Envi Prod', flavor: 'prod');
  Widget app = await initializeApp(devAppConfig);
  runApp(app);
}
/*
flutter run -t lib/main_prod.dart  --release --flavor=prod
flutter build appbundle -t lib/main_prod.dart  --flavor=prod
flutter build apk -t lib/main_prod.dart  --flavor=prod
*/