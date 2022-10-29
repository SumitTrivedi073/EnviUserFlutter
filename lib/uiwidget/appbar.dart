import 'package:envi/appConfig/Profiledata.dart';
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
                        print("your menu action here");

                        Scaffold.of(context).openDrawer();
                      },
                    ),
                    Container(
                      alignment: Alignment.center,
                      child: Row(
                        children: const [
                          Text(
                            "ENVI",
                            style: TextStyle(
                                color: Colors.white,
                                fontFamily: 'SFCompactText',
                                fontWeight: FontWeight.w200,
                                fontSize: 18),
                          ),
                        ],
                      ),
                    ),
                    ClipRRect(
                          borderRadius: BorderRadius.circular(50.0),
                          child: Image.network(
                            encodeImgURLString(Profiledata().getpropic()),
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
        ],
      ),
    );
  }
}
