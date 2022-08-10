import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

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
