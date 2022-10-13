import 'package:envi/appConfig/Profiledata.dart';
import 'package:envi/uiwidget/robotoTextWidget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../theme/color.dart';
import '../theme/theme.dart';
import '../utils/utility.dart';
import '../web_service/Constant.dart';

class AppBarInsideWidget extends StatefulWidget {
  const AppBarInsideWidget(
      {Key? key,
      required this.title,
      this.isBackButtonNeeded = true,
      this.onPressBack})
      : super(key: key);
  final String title;
  final bool isBackButtonNeeded;
  final dynamic onPressBack;
  @override
  State<StatefulWidget> createState() => _AppBarInsidePageState();
}

class _AppBarInsidePageState extends State<AppBarInsideWidget> {
  String? loginPic;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      margin: const EdgeInsets.only(top: 30, left: 10, right: 10),
      child: Stack(
        children: <Widget>[
          Card(
            elevation: 4,
            color: AppColor.greyblack,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                (widget.isBackButtonNeeded)
                    ? IconButton(
                        icon: SvgPicture.asset(
                          "assets/svg/chevron-back-button.svg",
                          width: 22,
                          height: 24,
                        ),
                        onPressed: widget.onPressBack ??
                            () {
                              Navigator.pop(context);
                            })
                    : SizedBox(),
                robotoTextWidget(
                  textval: widget.title,
                  colorval: AppColor.lightwhite,
                  sizeval: 18.0,
                  fontWeight: FontWeight.w800,
                ),
                Card(
                  child: Image.network(
                    encodeImgURLString(Profiledata.propic),
                    fit: BoxFit.fill,
                    height: 40,
                    width: 50,
                  ),
                )
              ],
            )
          ),
        ],
      ),
    );
  }
}
