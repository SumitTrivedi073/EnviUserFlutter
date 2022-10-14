import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:envi/database/favoritesData.dart';
import 'package:envi/theme/color.dart';
import 'package:envi/web_service/Constant.dart';
import 'package:flutter/material.dart';
import 'package:envi/web_service/Constant.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

import '../database/database.dart';
import '../database/favoritesDataDao.dart';

class Utility {
  _getId() async {
    var deviceInfo = DeviceInfoPlugin();
    if (Platform.isIOS) {
      // import 'dart:io'
      var iosDeviceInfo = await deviceInfo.iosInfo;
      return iosDeviceInfo.identifierForVendor; // Unique ID on iOS
    } else {
      var androidDeviceInfo = await deviceInfo.androidInfo;
      return androidDeviceInfo.id; // Unique ID on Android
    }
  }

  void showInSnackBar({required String value, context, Duration? duration}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(value),
        duration: duration ?? const Duration(milliseconds: 3000),
      ),
    );
  }
}

Utility utility = Utility();

_getId() async {
  var deviceInfo = DeviceInfoPlugin();
  if (Platform.isIOS) {
    // import 'dart:io'
    var iosDeviceInfo = await deviceInfo.iosInfo;
    return iosDeviceInfo.identifierForVendor; // Unique ID on iOS
  } else {
    var androidDeviceInfo = await deviceInfo.androidInfo;
    return androidDeviceInfo.id; // Unique ID on Android
  }
}

dynamic myEncode(dynamic item) {
  if (item is Timestamp) {
    return item.toString();
  }
  return item;
}

void showToast(String toast_msg) {
  Fluttertoast.showToast(
      msg: toast_msg,
      gravity: ToastGravity.CENTER,
      toastLength: Toast.LENGTH_LONG,
      timeInSecForIosWeb: 9);
}

String changeDateFormate(String date) {
  var inputFormat = DateFormat("yyyy-MM-dd'T'HH:mm:ssZ");
  var inputDate = inputFormat.parse(date); // <-- dd/MM 24H format

  var outputFormat = DateFormat('yyyy-MM-dd hh:mm');
  var outputDate = outputFormat.format(inputDate);

  return outputDate;
}

Future<void> makingPhoneCall(String phone) async {
  var url = Uri.parse("tel:$phone");
  if (await canLaunchUrl(url)) {
    await launchUrl(url);
  } else {
    throw 'Could not launch $url';
  }
}

String encodeImgURLString(tmp) {
  print("tmp=============>${tmp.toString()}");
  String endStr =
      tmp != null && tmp != '' ? Uri.encodeFull(tmp).trim() : placeHolderImage;
  return endStr;
}
Future<void> deleteAlldata() async {
  final database =
      await $FloorFlutterDatabase.databaseBuilder('envi_user.db').build();
  FavoritesDataDao dao = database.taskDao;
  List<FavoritesData> data = await dao.findAllTasks();
  FavoritesData res;
  for(res in data){
    print("datadelete${res}");
    await dao.deleteTask(res);
  }
  //await dao.deleteTasks(data);
}