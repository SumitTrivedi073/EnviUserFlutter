

import 'package:envi/theme/color.dart';
import 'package:envi/uiwidget/robotoTextWidget.dart';
import 'package:flutter/material.dart';

class EstimateFareWidget extends StatefulWidget {
  final String? amountTobeCollected;

  // receive data from the FirstScreen as a parameter
  const EstimateFareWidget({Key? key, required this.amountTobeCollected})
      : super(key: key);

  @override
  // TODO: implement createState
  State<StatefulWidget> createState() => _EstimateFareWidgetPageState();
}

class _EstimateFareWidgetPageState extends State<EstimateFareWidget> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
        height: 50,
        margin: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
        child: Card(
          color: Colors.white,
          elevation: 8,
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(5)),
              side: BorderSide(width: 5, color: Colors.transparent)),

          child: Container(
            margin: const EdgeInsets.only(left: 10,right: 10),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Row(children: [
                    const robotoTextWidget(textval: "Estimated Fare",
                        colorval: AppColor.black,
                        sizeval: 14,
                        fontWeight: FontWeight.w600),
                    IconButton(
                        onPressed: () {},
                        icon: const Icon(
                          Icons.info_outlined,
                          size: 20.0,
                          color: Colors.grey,
                        )),

                  ],),
                  robotoTextWidget(textval: '₹${widget.amountTobeCollected}',
                      colorval: AppColor.black,
                      sizeval: 16,
                      fontWeight: FontWeight.w600)
                ]),
          ),
        )
    );
  }
}
