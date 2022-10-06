import 'package:flutter/material.dart';

import '../main.dart';
import 'appconfig.dart';

void main() async {
  AppConfig devAppConfig = AppConfig(appName: 'Envi Dev', flavor: 'qa');
  Widget app = await initializeApp(devAppConfig);
  runApp(app);
}