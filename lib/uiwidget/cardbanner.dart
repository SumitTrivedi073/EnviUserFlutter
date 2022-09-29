import 'package:envi/theme/color.dart';
import 'package:flutter/material.dart';

class CardBanner extends StatefulWidget {
  final String? title, image;

  // receive data from the FirstScreen as a parameter
  const CardBanner({Key? key, required this.title, required this.image})
      : super(key: key);

  @override
  // TODO: implement createState
  State<StatefulWidget> createState() => _CardBannerPageState();
}

class _CardBannerPageState extends State<CardBanner> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      margin: const EdgeInsets.only(left: 10, right: 10),
      child: Card(
          semanticContainer: true,
          clipBehavior: Clip.antiAliasWithSaveLayer,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          elevation: 5,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Text(
                  widget.title.toString(),
                  style: const TextStyle(
                      color: AppColor.black,
                      fontFamily: 'Roboto',
                      fontWeight: FontWeight.w800,
                      fontSize: 18),
                ),
              ),
              Image.asset(
                widget.image.toString(),
                fit: BoxFit.fill,
              ),
            ],
          )),
    );
  }
}
