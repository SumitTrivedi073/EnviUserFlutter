import 'dart:ffi';
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

  String? validatorText({
    bool? isEmail,
    String? value,
    String? emptyMsg,
    bool isMandatary = true,
    int minLimit = 2,
    int maxLimit = 256,
    String? condistionUnMetMsg,
    bool shouldBeNumber = false,
    bool isDecimalMadatory = false,
    double? maxVal,
    double? minVal,
  }) {
    if (isMandatary) {
      if (value!.isEmpty) {
        return emptyMsg ?? 'Please fill this input field';
      } else {
        if (!(value.length >= minLimit)) {
          return 'Should be greater then ${minLimit - 1} characters';
        } else if (value.length > maxLimit) {
          return 'Should be smaller then $maxLimit characters';
        }
        if (shouldBeNumber) {
          try {
            if (double.parse(value.toString()).runtimeType == double ||
                double.parse(value.toString()).runtimeType == int) {
              if (isDecimalMadatory) {
                if (value.split('.').length <= 1) {
                  return 'Please enter value with a decimal';
                } else if (value.split('.')[1].length < 1) {
                  return 'Please enter value with a decimal';
                }
              }
              if (minVal != null) {
                if (double.parse(value.toString()) <= minVal) {
                  return 'Should be greater then $minVal';
                }
              }
              if (maxVal != null) {
                if (double.parse(value.toString()) >= maxVal) {
                  return 'Should be less then $maxVal';
                }
              }
              // if(isEmail && ){

              // }
            }
          } catch (e) {
            return 'Please enter a float value';
          }
        }

        return null;
      }
    }
    return null;
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
  for (res in data) {
    print("datadelete${res}");
    await dao.deleteTask(res);
  }
  //await dao.deleteTasks(data);
}

double nullSafeFloat(obj, value) {
  if (obj == null || obj[value] == null)
    return 0.0;
  else
    return obj[value].toDouble();
}

//This is to strip of unnecessory chars from address
String formatAddress(String address) {
  var formated = address
      .replaceAllMapped(
          new RegExp(r'[A-Za-z0-9]+\+[A-Za-z0-9]+,(.*)', caseSensitive: false),
          (Match m) => "${m[1]}")
      .replaceAllMapped(
          new RegExp(r'(^.*).*karnataka[+ \n\t\r\f]*,*.*',
              caseSensitive: false),
          (Match m) => "${m[1]}")
      .replaceAllMapped(
          new RegExp(r'(^.*).*india[ \n\t\r\f]*,*.*', caseSensitive: false),
          (Match m) => "${m[1]}")
      .replaceAll(new RegExp("[0-9]{6}"), '') //pincode
      .replaceAll(new RegExp("[+ \n\t\r\f],"), '')
      .replaceAll(new RegExp("[+ \n\t\r\f,]\$"), '')
      .replaceAll(new RegExp("^[,]"), '')
      .replaceAll(new RegExp("[,]\$"), '');

  return formated;
}

extension StringCasingExtension on String {
  String toCapitalized() => length > 0 ?'${this[0].toUpperCase()}${substring(1).toLowerCase()}':'';
  String toTitleCase() => replaceAll(RegExp(' +'), ' ').split(' ').map((str) => str.toCapitalized()).join(' ');
}
