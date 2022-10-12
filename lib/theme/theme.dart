import 'package:flutter/material.dart';

import 'package:date_format/date_format.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';

import 'color.dart';

ThemeData appTheme() {
  return ThemeData(
    iconTheme: const IconThemeData(color: Colors.green),
    primarySwatch: Colors.green,
  );
}

getPadding({@required context, top: 0.0, right: 0.0, bottom: 0.0, left: 0.0}) {
  return EdgeInsets.only(top: top, right: right, bottom: bottom, left: left);
}

getsmallNetworkImage(context, path) {
  if (path != null && path != null) {
    print(path);
    return CircleAvatar(
        radius: 18,
        foregroundImage: NetworkImage(
            path)); //Image.network(path,height: 40, fit: BoxFit.cover);
  } else {
    return Container(
      color: AppColor.white,
      alignment: Alignment.center,
      child: const Text(
        'No Image Uploaded',
        style: TextStyle(
            fontSize: 5, fontWeight: FontWeight.bold, color: AppColor.black),
      ),
    );
  }
}
getheaderNetworkImage(context, path) {
  if (path != null && path != null) {
    print(path);
    return Image.network(path, height: 40, width: 50, fit: BoxFit.cover);//Image.network(path,height: 40, fit: BoxFit.cover);
  } else {
    return Container(
      color: AppColor.white,
      alignment: Alignment.center,
      child: const Text(
        'No Image Uploaded',
        style: TextStyle(
            fontSize: 5, fontWeight: FontWeight.bold, color: AppColor.black),
      ),
    );
  }
}
getNetworkImage(context, path) {
  if (path != null && path != null) {
    return Image.network(path, height: 100, width: 100, fit: BoxFit.fitWidth);
  } else {
    return Container(
      color: AppColor.white,
      alignment: Alignment.center,
      child: SvgPicture.asset(
        "assets/svg/car-type-sedan.svg",
        width: 100,
        height: 100,
      ),
    );
  }
}

int calculateDifference(DateTime date) {
  DateTime now = DateTime.now();
  return DateTime(date.year, date.month, date.day).difference(DateTime(now.year, now.month, now.day)).inDays;
}
getdayTodayTomarrowYesterday(String strdate){
  DateTime parseDt = DateTime.parse(strdate).toLocal();
  if(calculateDifference(parseDt) == -1){
return "Yesterday ${convertTimeFromString(strdate)}";
  }
 else if(calculateDifference(parseDt) == 0){
    return "Today ${convertTimeFromString(strdate)}";
  }
  else if(calculateDifference(parseDt) == 1){
    return "Tomorrow ${convertTimeFromString(strdate)}";
  }

  else {
    return "${convertDateFromString(strdate)} ${convertTimeFromString(strdate)}";
  }
}
String convertDateFromString(String strDate) {
  DateTime parseDt = DateTime.parse(strDate).toLocal();
  var date1 = formatDate(parseDt, [dd, ' ', M, ',', yyyy]);
  return date1;
}
String convertTimeFromString(String strDate) {
  var timeFormatter = DateFormat('hh:mm');
  DateTime parseDt = DateTime.parse(strDate).toLocal();
  var hourMinString = timeFormatter.format(parseDt);
  var temp = DateFormat.yMEd().add_jms().format(parseDt);
  var timeString = hourMinString + ' ' + temp.split(' ')[3];
  return timeString;
}
void showSnackbar(BuildContext context, String message) {
  final scaffold = ScaffoldMessenger.of(context);
  scaffold.showSnackBar(
    SnackBar(
      content:  Text(message),
    ),
  );
}
List decodePolyline(String input) {
  var list=input.codeUnits;
  List lList = [];
  int index=0;
  int len=input.length;
  int c=0;
  List<LatLng> positions = [];
  // repeating until all attributes are decoded
  do {
    var shift=0;
    int result=0;

    // for decoding value of one attribute
    do {
      c=list[index]-63;
      result|=(c & 0x1F)<<(shift*5);
      index++;
      shift++;
    } while(c>=32);
    /* if value is negetive then bitwise not the value */
    if(result & 1==1) {
      result=~result;
    }
    var result1 = (result >> 1) * 0.00001;
    lList.add(result1);
  } while(index<len);

  /*adding to previous value as done in encoding */
  for(int i=2;i<lList.length;i++) {
    lList[i]+=lList[i-2];
  }

  for(int i=0; i<lList.length; i+=2) {
    positions.add(LatLng(lList[i], lList[i+1]));
  }

  return positions;
}