import 'package:flutter/material.dart';

import '../main.dart';
import 'applicationconfig.dart';

void main() async {
  ApplicationConfig devAppConfig =
  ApplicationConfig(appName: 'Envi Prod', flavor: 'prod');
  Widget app = await initializeApp(devAppConfig);
  runApp(app);
}