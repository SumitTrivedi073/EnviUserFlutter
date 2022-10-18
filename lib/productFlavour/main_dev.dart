import 'package:flutter/material.dart';

import '../main.dart';
import 'applicationconfig.dart';

void main() async {
  ApplicationConfig devAppConfig = ApplicationConfig(appName: 'Envi Dev', flavor: 'qa');
  Widget app = await initializeApp(devAppConfig);
  runApp(app);
}