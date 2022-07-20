import 'package:envi/theme/color.dart';
import 'package:flutter/material.dart';

class CardBanner extends StatefulWidget {
  @override
  // TODO: implement createState
  State<StatefulWidget> createState() => _CardBannerPageState();
}

class _CardBannerPageState extends State<CardBanner> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      child: Card(
          semanticContainer: true,
          clipBehavior: Clip.antiAliasWithSaveLayer,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          elevation: 5,
          child: Column(
            children: [
              const Padding(
                padding: EdgeInsets.only(top: 10),
                child: Text(
                  "Connecting Driver...",
                  style: TextStyle(
                      color: AppColor.black,
                      fontFamily: 'Roboto',
                      fontWeight: FontWeight.w800,
                      fontSize: 18),
                ),
              ),
              Image.asset(
                'assets/images/connecting_driver_img.png',
                fit: BoxFit.fill,
              ),
            ],
          )),
    );
  }
}
