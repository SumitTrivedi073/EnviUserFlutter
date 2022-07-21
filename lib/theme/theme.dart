
import 'package:flutter/material.dart';

ThemeData appTheme() {
  return ThemeData(
    iconTheme: new IconThemeData(color: Colors.green),
    primarySwatch: Colors.green,
  );
}

getPadding({@required context, top: 0.0, right: 0.0, bottom: 0.0, left: 0.0}) {
  return EdgeInsets.only(top: top, right: right, bottom: bottom, left: left);
}
getsmallNetworkImage(context, path) {
  if (path != null && path != null) {
    return CircleAvatar(radius: 18,foregroundImage:NetworkImage(path) ) ;//Image.network(path,height: 40, fit: BoxFit.cover);
  } else {
    return Container(
      color: colorThemeData['backgroundColor'],
      alignment: Alignment.center,
      child: Text(
        'No Image Uploaded',
        style: TextStyle(
            fontSize: 5,
            fontWeight: FontWeight.bold,
            color: colorThemeData['secondaryTextColor']),
      ),
    );
  }
}


getStatusColor(context, status) {
  var tripStatus = status.toLowerCase();
  if (tripStatus == 'onboarding') {
    return Color(0XffE65100);
  } else if (tripStatus == 'cancelled') {
    return Color(0xffF11212);
  } else if (tripStatus == 'arrived') {
    return Color(0xff0D47A1);
  } else if (tripStatus == 'request') {
    return Color(0xFF1A237E);
  } else if (tripStatus == 'completed') {
    return Theme.of(context).primaryColor;
  } else if (tripStatus == 'allotted') {
    return Color(0XFF64B5F6);
  } else if (tripStatus == 'open') {
    return Theme.of(context).primaryColor;
  } else if (tripStatus == 'close') {
    return Color(0xffF11212);
  }
}

getTripStatusdisabledColor(context, status) {
  var tripStatus = status.toLowerCase();
  if (tripStatus == 'onboarding') {
    return Color(0xffFFF3E0);
  } else if (tripStatus == 'cancelled') {
    return Color(0xffFFEBEE);
  } else if (tripStatus == 'arrived') {
    return Color(0xffE3F2FD);
  } else if (tripStatus == 'request') {
    return Color(0xffE8EAF6);
  } else if (tripStatus == 'open') {
    return Color(0xffE8F5E9);
  } else if (tripStatus == 'close') {
    return Color(0xffFFEBEE);
  } else {
    return Color(0xffE8F5E9);
  }
}

var defaultIconStyle = {
  "size": 32.0,
  "color": colorThemeData['iconPrimaryColor']
};

var colorThemeData = {
  "primaryTextColor": Colors.black,
  "secondaryTextColor": Colors.grey,
  "textColorBlack54": Colors.black54,
  "textColorBlack87": Colors.black87,
  "textErrorColor": Colors.red[600],
  "raisedButtonTextColor": Colors.white,
  "iconPrimaryColor": Colors.black,
  "iconSecondaryColor": Colors.white,
  "greyIcon": Colors.grey,
  "snackbarTextColor": Colors.white,
  "backgroundColor": Colors.white,
  "whiteText": Colors.white,
  "grey600": Colors.grey[600],
  "transparentColor": Colors.transparent,
  "avatarBackground": Color(0xffE3DDDD),
  "disabledButtonColor": Color(0xffF7CBBF),
  "processedBadgeIconColor": Color(0xff1B5E20),
  'tableRowColor': Colors.grey[300],
  'accentColor': Color(0xffE16310),
  'primaryColor': Color(0xff4DB47B),
  'textColorBlue': Color(0xff061453),
  'loanColor': Color(0xffF39353),
  'secondaryColor': Color(0xff0C1D0F),
  'backgroundColorForWeb': Color(0xffF0F7F7)
};
