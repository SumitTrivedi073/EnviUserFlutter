import 'package:envi/theme/color.dart';
import 'package:envi/uiwidget/robotoTextWidget.dart';
import 'package:flutter/material.dart';

class OTPView extends StatefulWidget {
  final String? otp;

  // receive data from the FirstScreen as a parameter
  const OTPView({Key? key, required this.otp})
      : super(key: key);

  @override
  // TODO: implement createState
  State<StatefulWidget> createState() => _OTPViewPageState();
}

class _OTPViewPageState extends State<OTPView> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      height: 40,
      width: 110,
      alignment: Alignment.topRight,
      margin: const EdgeInsets.only(left: 10, right: 10,top: 10),
      child: Card(
        color: Colors.transparent,
        elevation: 8,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(30)),
            side: BorderSide(width: 5, color: Colors.transparent)),

        child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                width: 50,
                decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(30),
                        topLeft: Radius.circular(30)),color: AppColor.alfaorange),
                child:  const Center(child: robotoTextWidget(textval: "OTP",
                    colorval: AppColor.black,
                    sizeval: 12,
                    fontWeight: FontWeight.w800),),

              ),
              Container(
                width: 50,
                decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                        bottomRight: Radius.circular(30),
                        topRight: Radius.circular(30)),color: Color(0xFFFFDD6E)),
                child:  Center(child: robotoTextWidget(textval: widget.otp.toString(),
                    colorval: AppColor.black,
                    sizeval: 14,
                    fontWeight: FontWeight.w800),
                ),),
            ]),
      )
    );
  }
}
