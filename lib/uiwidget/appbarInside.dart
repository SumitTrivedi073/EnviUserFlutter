import 'package:envi/appConfig/Profiledata.dart';
import 'package:envi/uiwidget/robotoTextWidget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../theme/color.dart';
import '../theme/images.dart';
import '../utils/utility.dart';

class AppBarInsideWidget extends StatefulWidget {
  final String pagetitle;
  final bool isBackButtonNeeded;
  final dynamic onPressBack;
  final EdgeInsets? customMargin;
  const AppBarInsideWidget(
      {Key? key,
      required this.pagetitle,
      this.isBackButtonNeeded = true,
      this.onPressBack,
      this.customMargin})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _AppBarInsidePageState();
}

class _AppBarInsidePageState extends State<AppBarInsideWidget> {
  String? loginPic;

  @override
  void initState() {

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
 
    return Container(
      margin: widget.customMargin ??
          const EdgeInsets.only(top: 30, left: 10, right: 10),
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
                      : const SizedBox(),
                  robotoTextWidget(
                    textval: widget.pagetitle.toTitleCase(),
                    colorval: AppColor.lightwhite,
                    sizeval: 18.0,
                    fontWeight: FontWeight.w800,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(5),
                    child: ClipRRect(
                        borderRadius: BorderRadius.circular(40.0),
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
                  ),
                ],
              )),
        ],
      ),
    );
  }
}
