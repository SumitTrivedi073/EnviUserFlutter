
import 'package:envi/uiwidget/robotoTextWidget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../theme/color.dart';
import '../web_service/Constant.dart';

class AppBarInsideWidget extends StatefulWidget {
  final String title;

  @override
  Widget build(BuildContext context) {

    // TODO: implement build
    return Container(
      margin: EdgeInsets.only(top: 30),
      child: Stack(
        children: <Widget>[
          Card(
              elevation: 4,
              color: AppColor.greyblack,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,

                  children: [
                    IconButton(
                      icon: SvgPicture.asset(
                        "assets/svg/chevron-back-button.svg",
                        width: 22,
                        height: 24,

                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),

                    Container(
                      alignment: Alignment.center,
                      child: Row(
                        children: [
                          robotoTextWidget(textval: title,colorval: AppColor.lightwhite,sizeval: 18.0,fontWeight: FontWeight.w800,),
                        ],
                      ),
                    ),

                    Card(
                      child: Image.network("$imageServerurl${(sharedPreferences.getString(Loginpropic) ?? '')}",
                        fit: BoxFit.fill,height: 40,
                        width: 40,),
                    )
                  ],
                ),
              ),
            ),

        ],
      ),
    );
  }
}