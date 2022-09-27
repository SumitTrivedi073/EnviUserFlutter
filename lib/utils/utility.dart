import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:envi/theme/color.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Utility {
  _getId() async {
    var deviceInfo = DeviceInfoPlugin();
    if (Platform.isIOS) { // import 'dart:io'
      var iosDeviceInfo = await deviceInfo.iosInfo;
      return iosDeviceInfo.identifierForVendor; // Unique ID on iOS
    } else {
      var androidDeviceInfo = await deviceInfo.androidInfo;
      return androidDeviceInfo.id; // Unique ID on Android
    }
  }
}
_getId() async {
  var deviceInfo = DeviceInfoPlugin();
  if (Platform.isIOS) { // import 'dart:io'
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
