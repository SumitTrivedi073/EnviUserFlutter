import 'dart:convert';

import 'package:envi/payment/models/payment_type.dart';
import 'package:envi/web_service/payment.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:envi/web_service/HTTP.dart' as HTTP;
import '../UiWidget/appbar.dart';
import '../UiWidget/cardbanner.dart';
import '../theme/color.dart';
import '../theme/string.dart';
import '../uiwidget/paymentModeOptionWidget.dart';
import '../uiwidget/robotoTextWidget.dart';
import '../web_service/Constant.dart';
import '../../web_service/paytm_config.dart';
import 'package:http/http.dart' as http;
import 'package:paytm_allinonesdk/paytm_allinonesdk.dart';

class PaymentPage extends StatefulWidget {
  const PaymentPage({Key? key}) : super(key: key);
//final String passengerTripId;
  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  String selectedPayOption = '';
  bool arrowClicked = false;
  List<String> breakDownNames = [
    distanceTravelledText,
    totalFareText,
    ratePerKmText,
    lessDiscountText,
    tollsText,
    taxesText,
    amountPayableText
  ];
  List<String> breakDownVals = [
    '13.0 Kms',
    'x 18.00 ₹',
    '234.00 ₹',
    '- 40.0 ₹',
    '70.00 ₹',
    '32.00 ₹',
    '296.00'
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(PageBackgroundImage),
            fit: BoxFit.fill,
          ),
        ),
        padding: const EdgeInsets.fromLTRB(10, 30, 10, 10),
        child: Scaffold(
          appBar: AppBar(
            actions: [
              Card(
                child: Image.network(
                  placeHolderImage,
                  fit: BoxFit.fill,
                  height: 40,
                  width: 50,
                ),
              )
            ],
            centerTitle: true,
            title: Text(
              envi,
              style: const TextStyle(
                  color: Colors.white,
                  fontFamily: 'SFCompactText',
                  fontWeight: FontWeight.w200,
                  fontSize: 18),
            ),
            backgroundColor: AppColor.greyblack,
            elevation: 4,
            leading: IconButton(
              icon: const Icon(
                Icons.menu,
                color: Colors.white,
              ),
              onPressed: () {},
            ),
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                CardBanner(
                    title: youHaveArrivedText,
                    image: 'assets/images/driver_arrived_img.png'),
                SizedBox(
                  height: 76,
                  child: Card(
                    child: Row(
                      children: [
                        Image.network(
                          placeHolderImage,
                          fit: BoxFit.fill,
                          height: 54,
                          width: 50,
                        ),
                        Flexible(
                          flex: 2,
                          child: Column(
                            children: [
                              robotoTextWidget(
                                  textval: rateYourDriverText,
                                  colorval: AppColor.black,
                                  sizeval: 14.0,
                                  fontWeight: FontWeight.bold),
                              const SizedBox(
                                height: 7,
                              ),
                              RatingBar.builder(
                                initialRating: 0,
                                minRating: 1,
                                direction: Axis.horizontal,
                                allowHalfRating: true,
                                itemCount: 5,
                                itemSize: 27,
                                unratedColor: AppColor.border,
                                itemPadding:
                                    const EdgeInsets.symmetric(horizontal: 2.0),
                                itemBuilder: (context, _) => const Icon(
                                  Icons.star,
                                  color: Colors.amber,
                                ),
                                onRatingUpdate: (rating) {
                                  print(rating);
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                paymentBreakDown(breakDownVals),
                PaymentModeOptionWidget(
                  strpaymentOptions: "qr_code,online,cash",
                  selectedOption: "qr_code",
                  callback: selectedOption,
                ),
                Container(
                    width: double.infinity,
                    margin: const EdgeInsets.all(5),
                    child: ElevatedButton(
                      onPressed: () {
                        // if (selectedPayOption == 'online') {
                        //   createOrder();
                        // }
                        // else {
                        // paymentService.updatePayment(paymentType: PaymentType(paymentMode: selectedPayOption , passengerTripMasterId: passengerTripId))
                        // }
                      },
                      style: ElevatedButton.styleFrom(
                        primary: AppColor.greyblack,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12), // <-- Radius
                        ),
                      ),
                      child: robotoTextWidget(
                        textval: confirm,
                        colorval: AppColor.white,
                        sizeval: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    )),
              ],
            ),
          ),
        ),
      ),
    );
  }

  selectedOption(String val) {
    setState(() {
      selectedPayOption = val;
    });
  }

  Future<dynamic> createOrder() async {
    var headers = {
      'x-access-token':
          'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6IjNkYjljNDk2LTBmZTItNDc5Mi1hODdlLWI5ZWZhZWUzZmQ1YiIsInR5cGVpZCI6MywicGhvbmVOdW1iZXIiOiI5NDI0ODgwNTgyIiwiaWF0IjoxNjYzODE5NjE3fQ.uLjsbCFkQR9I4WNz5nkzBCCRRCDaASHYP5EJ0W0_kDM',
      'Content-Type': 'application/json'
    };
    var request = http.Request('POST',
        Uri.parse('https://qausernew.azurewebsites.net/order/createOrder'));
    request.body = json.encode(
        {"passengerTripMasterId": "9b20343d-b725-4fc4-80cf-d0c68c4ae860"});
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();
    var result;
    if (response.statusCode == 200) {
      //print(await response.stream.bytesToString());
      result = await response.stream.bytesToString();
      var jres = json.decode(result);
      print(jres['MID']);
      await initiateTransaction(jres['ORDER_ID'], jres['amount'].toDouble(),
          jres['txnToken'], jres['CALLBACK_URL'], jres['MID']);
    } else {
      print(response.reasonPhrase);
    }
  }

  Future<void> initiateTransaction(String orderId, double amount,
      String txnToken, String callBackUrl, String miid) async {
    String result = '';
    try {
      var response = AllInOneSdk.startTransaction(
        miid,
        orderId,
        amount.toString(),
        txnToken,
        callBackUrl,
        false,
        true,
      );
      response.then((value) {
        // Transaction successfull
        setState(() {
          result = value.toString();
        });
      }).catchError((onError) {
        if (onError is PlatformException) {
          result = onError.message! + " \n  " + onError.details.toString();
          setState(() {
            result = onError.message.toString() +
                " \n  " +
                onError.details.toString();
          });
        } else {
          result = onError.toString();
          print(result);
        }
      });
    } catch (err) {
      // Transaction failed
      result = err.toString();
      print(result);
    }
  }

  Widget paymentBreakDown(List<String> valList) {
    return Card(
      child: Column(
        children: [
          ListTile(
            title: robotoTextWidget(
                textval: yourFareText,
                colorval: AppColor.black,
                sizeval: 14,
                fontWeight: FontWeight.normal),
            subtitle: robotoTextWidget(
                textval: includesdiscountText,
                colorval: AppColor.textgray,
                sizeval: 14,
                fontWeight: FontWeight.normal),
            trailing: const robotoTextWidget(
                textval: '₹296',
                colorval: AppColor.darkGreen,
                sizeval: 40,
                fontWeight: FontWeight.normal),
          ),
          const Divider(
            thickness: 2,
          ),
          ExpansionTile(
            onExpansionChanged: (value) {
              setState(() {
                arrowClicked = !arrowClicked;
              });
            },
            //  backgroundColor: Colors.white,
            leading: (arrowClicked)
                ? Icon(Icons.arrow_drop_up)
                : Icon(Icons.arrow_drop_down),
            trailing: const Icon(Icons.share),
            title: robotoTextWidget(
                textval: breakdownText,
                colorval: AppColor.black,
                sizeval: 14,
                fontWeight: FontWeight.bold),
            children: [
              Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                      children: List.generate(
                          breakDownNames.length,
                          (index) => Row(
                                children: [
                                  robotoTextWidget(
                                      textval: breakDownNames[index],
                                      colorval: AppColor.grey,
                                      sizeval: 13,
                                      fontWeight: FontWeight.w400),
                                  Spacer(),
                                  robotoTextWidget(
                                      textval: valList[index],
                                      colorval: AppColor.black,
                                      sizeval: 13,
                                      fontWeight: (index == 6 || index == 2)
                                          ? FontWeight.w700
                                          : FontWeight.w400)
                                ],
                              )))),
            ],
          ),
        ],
      ),
    );
  }
}
