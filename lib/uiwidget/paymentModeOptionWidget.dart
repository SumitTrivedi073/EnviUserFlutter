import 'package:envi/uiwidget/robotoTextWidget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../theme/color.dart';
import '../theme/string.dart';

class PaymentModeOptionWidget extends StatefulWidget {
  final String strpaymentOptions;
  final String selectedOption;

  PaymentModeOptionWidget(
      {required this.strpaymentOptions, required this.selectedOption});

  @override
  State<StatefulWidget> createState() => _PaymentModeOptionWidgetState();
}

class _PaymentModeOptionWidgetState extends State<PaymentModeOptionWidget> {
  late String strpaymentOptions;
  late String selectedOption;
  List<String> arroption = [];

  @override
  void initState() {
    selectedOption = widget.selectedOption;

    strpaymentOptions = widget.strpaymentOptions;
  }

  @override
  Widget build(BuildContext context) {
    arroption = strpaymentOptions.split(",");
    int listheight = 39 + 57 * arroption.length;
    return Container(
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
                Container(
                  margin: const EdgeInsets.only(
                      top: 5, left: 10, right: 10, bottom: 5),
                  height: 1,
                  width: MediaQuery.of(context).size.width,
                  child: const Divider(
                    color: Colors.grey,
                    height: 1,
                  ),
                ),
                Container(
                  height: listheight.toDouble(),
                  child: ListView.builder(
                    //controller: _controller,

                    itemBuilder: (context, index) {
                      return ListItem(index);
                    },
                    itemCount: 3,
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
        child: Container(
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
              CellRow2(index),
            ])));
  }

  GestureDetector CellRow2(index) {
    return GestureDetector(
        onTap: () {
          setState(() {
            selectedOption = arroption[index];
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
                          Image.asset(
                            getpaymentIcon(arroption[index]),
                            width: 20,
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          robotoTextWidget(
                            textval: getpaymentTitle(arroption[index]),
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
                            textval: getpaymentDecription(arroption[index]),
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
        ));
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
        title = onlinetitel;
        break;
      case "cash":
        title = cashtitel;
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
        // do something
        title = "assets/images/qr_code.png";
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
