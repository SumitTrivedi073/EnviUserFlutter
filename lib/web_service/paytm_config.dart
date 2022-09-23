import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:paytm_allinonesdk/paytm_allinonesdk.dart';

class PaytmConfig {
  final String _mid = "...";
  final String _mKey = "...";
  final String _website = "DEFAULT";
  final String _url = '';
  // 'https://flutter-paytm-backend.herokuapp.com/generateTxnToken';

  String get mid => _mid;
  String get mKey => _mKey;
  String get website => _website;
  String get url => _url;

  String getMap(double amount, String callbackUrl, String orderId) {
    return json.encode({
      "mid": mid,
      "key_secret": mKey,
      "website": website,
      "orderId": orderId,
      "amount": amount.toString(),
      "callbackUrl": callbackUrl,
      "custId": "122",
    });
  }

  Future<void> generateTxnToken(double amount, String orderId) async {
    final callBackUrl =
        'https://securegw.paytm.in/theia/paytmCallback?ORDER_ID=$orderId';
    final body = getMap(amount, callBackUrl, orderId);

    try {
      final response = await http.post(
        Uri.parse(url),
        body: body,
        headers: {'Content-type': "application/json"},
      );
      String txnToken = response.body;

   //   await initiateTransaction(orderId, amount, txnToken, callBackUrl);
    } catch (e) {
      print(e);
    }
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
    await initiateTransaction( jres['ORDER_ID'], jres['amount'].toDouble(), jres['txnToken'], jres['CALLBACK_URL'], jres['MID']);
    } else {
      print(response.reasonPhrase);
    }
  }

  Future<void> initiateTransaction(String orderId, double amount,
      String txnToken, String callBackUrl,String miid) async {
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
      // setState(() {
      //     result = value.toString();
      //   });
      }
      )
      .catchError((onError) {
        if (onError is PlatformException) {
          result = onError.message! + " \n  " + onError.details.toString();
          //    setState(() {
          //   result = onError.message.toString() +
          //       " \n  " +
          //       onError.details.toString();
          // });
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
}
