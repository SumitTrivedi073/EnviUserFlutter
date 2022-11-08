import 'package:envi/appConfig/Profiledata.dart';
import 'package:envi/theme/string.dart';
import 'package:envi/uiwidget/robotoTextWidget.dart';
import 'package:flutter/material.dart';

import '../theme/color.dart';
import '../theme/images.dart';
import '../utils/utility.dart';
import '../theme/theme.dart';
import '../web_service/Constant.dart';
import 'navigationdrawer.dart';

class AppBarWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _AppBarPageState();
}

class _AppBarPageState extends State<AppBarWidget> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      height: 90,
      margin: EdgeInsets.only(left: 10, right: 10),
      child: Stack(
        children: <Widget>[
          Positioned(
            top: 30.0,
            left: 0.0,
            right: 0.0,
            child: Card(
              elevation: 4,
              color: AppColor.greyblack,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: const Icon(
                        Icons.menu,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        Scaffold.of(context).openDrawer();
                      },
                    ),
                    ClipRRect(
                          borderRadius: BorderRadius.circular(50.0),
                          child: Image.network(
                            encodeImgURLString(Profiledata.propic),
                            errorBuilder: (context, error, stackTrace) {
                              return Image.asset(
                                Images.personPlaceHolderImage,
                                height: 40,
                                width: 40,
                              );
                            },
                            fit: BoxFit.fill,
                            height: 40,
                            width: 40,
                          )),

                  ],
                ),
              ),
            ),
          ),
          Align(alignment: Alignment.center,
            child:   Container(
              margin: EdgeInsets.only(top: 20),
              child: robotoTextWidget(
                textval: appName.toTitleCase(),
                colorval: AppColor.lightwhite,
                sizeval: 18.0,
                fontWeight: FontWeight.w800,
              ),
            ),)
        ],
      ),
    );
  }
}
