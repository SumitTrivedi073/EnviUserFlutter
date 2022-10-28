import 'dart:convert' as convert;

import 'package:envi/provider/model/tripDataModel.dart';
import 'package:envi/sidemenu/home/homePage.dart';
import 'package:envi/uiwidget/paymentModeOptionWidget.dart';
import 'package:envi/uiwidget/paymentbreakdown.dart';
import 'package:envi/uiwidget/ratingWidget.dart';
import 'package:envi/web_service/HTTP.dart' as HTTP;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:paytm_allinonesdk/paytm_allinonesdk.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

import '../../UiWidget/cardbanner.dart';
import '../../provider/firestoreLiveTripDataNotifier.dart';
import '../../theme/string.dart';
import '../../theme/theme.dart';
import '../../uiwidget/appbarInside.dart';
import '../../web_service/APIDirectory.dart';
import '../../web_service/Constant.dart';
import '../onRide/model/SosModel.dart';

class PaymentPage extends StatefulWidget {
  const PaymentPage({Key? key}) : super(key: key);

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  String? selectedPayOption = '';
  String? passangerTripMasterId = '';
  late TripDataModel tripDataModel;
  LatLng? latlong;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Consumer<firestoreLiveTripDataNotifier>(
            builder: (context, value, child) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (value.liveTripData != null) {
              tripDataModel = value.liveTripData!;
              passangerTripMasterId =
                  value.liveTripData!.tripInfo!.passengerTripMasterId;
              selectedPayOption = value.liveTripData!.tripInfo!.paymentMode;
            }else{
              Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(
                      builder: (BuildContext context) =>
                      const HomePage(title: 'title')),
                      (Route<dynamic> route) => false);
            }
          });
          return value.liveTripData != null
              ? Scaffold(
                  body: Container(
                      height: double.infinity,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage(PageBackgroundImage),
                          fit: BoxFit.cover,
                        ),
                      ),
                      child: SingleChildScrollView(
                          child:  Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                            AppBarInsideWidget(
                              title: appName,
                              isBackButtonNeeded: false,
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            CardBanner(
                                title: youHaveArrivedText,
                                image: "assets/images/driver_arrived_img.png"),
                            const SizedBox(
                              height: 10,
                            ),
                            RatingBarWidget(livetripData: value.liveTripData),
                            PaymentBreakdownWidget(
                                livetripData: value.liveTripData),
                            PaymentModeOptionWidget(
                              tripDataModel: value.liveTripData!,
                              callback: selectedOption,
                            )
                          ]))))
              : Container();
        }),
      ),
    );
  }

  selectedOption(String val) {
    setState(() {
      selectedPayOption = val;
      if (selectedPayOption == 'online') {
        createOrder();
      }
      updatePayment(selectedPayOption, passangerTripMasterId);
    });
  }

  Future<void> updatePayment(
      String? selectedPayOption, String? passangerTripMasterId) async {
    Map body;
    body = {
      "passengerTripMasterId": passangerTripMasterId,
      "paymentMode": selectedPayOption
    };
    var jsonData;
    dynamic res = await HTTP.post(updatePaymentMode(), body);
    if (res != null && res.statusCode != null && res.statusCode == 200) {
      jsonData = convert.jsonDecode(res.body);
      SosModel sosModel = SosModel.fromJson(jsonData);
      showSnackbar(context, sosModel.message);
    } else {
      throw "Can't update.";
    }
  }

  Future<void> createOrder() async {

    Map body;
    body = {
      "passengerTripMasterId": tripDataModel.tripInfo!.passengerTripMasterId,
    };
    var jsonData;
    dynamic res = await HTTP.post(CreateOrder(), body);
    if (res != null && res.statusCode != null && res.statusCode == 200) {
      jsonData = convert.jsonDecode(res.body);
      print("jsonData=============>$jsonData");
      await initiateTransaction(
          jsonData['ORDER_ID'],
          jsonData['amount'].toDouble(),
          jsonData['txnToken'],
          jsonData['CALLBACK_URL'],
          jsonData['MID']);
    } else {
      throw "Can't update.";
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

  Future getCurrentLocation() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission != PermissionStatus.granted) {
      LocationPermission permission = await Geolocator.requestPermission();
      if (permission != PermissionStatus.granted) getLocation();
      return;
    }
    getLocation();
  }

  getLocation() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    if (mounted) {
      setState(() {
        latlong = LatLng(position.latitude, position.longitude);
      });
    }
  }
}
