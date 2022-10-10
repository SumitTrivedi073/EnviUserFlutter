import 'dart:convert';

import 'package:envi/appConfig/appConfig.dart';
import 'package:envi/provider/model/tripDataModel.dart';
import 'package:envi/uiwidget/robotoTextWidget.dart';
import 'package:flutter/material.dart';

import '../theme/color.dart';
import '../theme/string.dart';

class PaymentModeOptionWidget extends StatefulWidget {

  TripDataModel tripDataModel;
  final void Function(String) callback;

  PaymentModeOptionWidget(
      {Key? key,required this.tripDataModel, required this.callback});

  @override
  State<StatefulWidget> createState() => _PaymentModeOptionWidgetState();
}

class _PaymentModeOptionWidgetState extends State<PaymentModeOptionWidget> {
  List<String> arroption = [];
  late String selectedOption = widget.tripDataModel.tripInfo.paymentMode;
  String PaymentOption = AppConfig.paymentOptions;
  

  @override
  Widget build(BuildContext context) {
    PaymentOption = PaymentOption.replaceAll("[", "");
    PaymentOption = PaymentOption.replaceAll("]", "");
    PaymentOption = PaymentOption.replaceAll(" ", "");
    arroption = PaymentOption.split(',');
    int listheight = 80 * arroption.length;
    return Container(
      margin: const EdgeInsets.only(left: 10,right: 10),
      child: Card(
          semanticContainer: true,
          clipBehavior: Clip.antiAliasWithSaveLayer,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          elevation: 5,
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              children: [
                robotoTextWidget(
                  textval: selectepaymentmode,
                  colorval: const Color(0xFF1DCA1D),
                  sizeval: 18,
                  fontWeight: FontWeight.w600,
                ),
                SizedBox(
                  height: listheight.toDouble(),
                  child: ListView.builder(
                    itemBuilder: (context, index) {
                      return ListItem(index);
                    },
                    itemCount: arroption.length,
                  ),
                ),
              ],
            ),
          )),
    );
  }

  Card ListItem(index) {
    return Card(
        elevation: 1,
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
          GestureDetector(
              onTap: () {
                setState(() {
                  selectedOption = arroption[index];
                  widget.callback(selectedOption);
                });
                print("Tapped a Container");
              },
              child: Container(
                height: 57,
                decoration: selectedOption == arroption[index]
                    ? const BoxDecoration(
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(10),
                            topRight: Radius.circular(10)),
                        gradient: LinearGradient(
                          begin: Alignment.center,
                          end: Alignment.centerRight,
                          colors: [AppColor.white, Colors.lightGreen],
                        ))
                    : const BoxDecoration(
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(10),
                            topRight: Radius.circular(10)),
                      ),
                child: Column(
                  children: [
                    const SizedBox(
                      height: 7,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Padding(padding: EdgeInsets.only(left: 10),
                                child: Image.asset(
                                  getpaymentIcon(arroption[index]),
                                  width: 20,
                                )),
                                const SizedBox(
                                  width: 5,
                                ),
                                robotoTextWidget(
                                  textval:
                                      getpaymentTitle(arroption[index]),
                                  colorval: AppColor.black,
                                  sizeval: 16.0,
                                  fontWeight: FontWeight.w600,
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 3,
                            ),
                            Row(
                              children: [
                                const Padding(
                                  padding: EdgeInsets.only(left: 25),
                                ),
                                robotoTextWidget(
                                  textval: getpaymentDecription(
                                      arroption[index]),
                                  colorval: AppColor.grey,
                                  sizeval: 13.0,
                                  fontWeight: FontWeight.normal,
                                ),
                              ],
                            ),
                          ],
                        ),
                        if (arroption[index] == selectedOption)
                          Center(
                            child: Container(
                              margin: const EdgeInsets.only(right: 15),
                              child: const Icon(
                                Icons.check,
                                color: AppColor.darkGreen,
                                size: 25.0,
                              ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(
                      height: 7,
                    ),
                  ],
                ),
              )),
        ]));
  }

  String getpaymentTitle(String type) {
    String title = "";
    print(type);
    switch (type) {
      case "qr_code":
        // do something
        title = qrtitel;
        break;
      case "online":
        title = onlineTitle;
        break;
      case "cash":
        title = cashTitle;
        break;
    }
    return title;
  }

  String getpaymentDecription(String type) {
    String title = "";
    print(type);
    switch (type) {
      case "qr_code":
        // do something
        title = qrDecription;
        break;
      case "online":
        title = onlineDecription;
        break;
      case "cash":
        title = cashDecription;
        break;
    }
    return title;
  }

  String getpaymentIcon(String type) {
    String title = "";
    print(type);
    switch (type) {
      case "qr_code":
        title = "assets/images/payment_qr_code.png";
        break;
      case "online":
        title = "assets/images/payment_online.png";
        break;
      case "cash":
        title = "assets/images/payment_cash.png";
        break;
    }
    return title;
  }
}
