import 'dart:convert';

import 'package:envi/sidemenu/onRide/model/SosModel.dart';
import 'package:envi/theme/color.dart';
import 'package:envi/uiwidget/robotoTextWidget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../provider/model/tripDataModel.dart';
import '../theme/string.dart';
import '../theme/theme.dart';
import '../web_service/APIDirectory.dart';
import '../web_service/Constant.dart';
import 'package:envi/web_service/HTTP.dart' as HTTP;

class SOSView extends StatefulWidget {
  TripDataModel? liveTripData;

  SOSView({Key? key, this.liveTripData}) : super(key: key);


  @override
  // TODO: implement createState
  State<StatefulWidget> createState() => _SOSViewPageState();
}

class _SOSViewPageState extends State<SOSView> {

  late SharedPreferences sharedPreferences;
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return GestureDetector(
      onTap: (){
        sosApi();
      },
      child: Container(
          height: 50,
          width: 110,
          alignment: Alignment.topRight,
          margin: const EdgeInsets.only(right: 10,top: 10),
          child: Card(
            color: Colors.red,
            elevation: 5,
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(5)),
                side: BorderSide(width: 5, color: Colors.transparent)),

            child: Padding(
              padding: const EdgeInsets.all(5),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Center(
                      child: SvgPicture.asset(
                        "assets/svg/fire_alarm.svg",
                        width: 20,
                      ),
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    robotoTextWidget(textval: SOS,
                        colorval: AppColor.white,
                        sizeval: 14,
                        fontWeight: FontWeight.w800),
                  ]),
            ),
          )
      ),
    );
  }

  sosApi() async {

    sharedPreferences = await SharedPreferences.getInstance();
    Map data;
    data = {
      "id": sharedPreferences.getString(LoginID),
      "passengerTripmasterId": widget.liveTripData!.tripInfo.passengerTripMasterId,
      "name": sharedPreferences.getString(LoginName),
      "phone": sharedPreferences.getString(Loginphone),
      "vehicleNumber":  widget.liveTripData!.driverInfo.vehicleNumber,
      "driverName": widget.liveTripData!.driverInfo.name,
      "driverNumber": widget.liveTripData!.driverInfo.phone,

    };

    print("data=======>$data");
    dynamic res = await HTTP.post(SosApi(), data);
    if (res != null && res.statusCode != null && res.statusCode == 200) {
      print(jsonDecode(res.body));
      var jsonData = json.decode(res.body);
     SosModel sosModel = SosModel.fromJson(jsonData);
      showSnackbar(context,sosModel.message);
    } else {
      throw "Sos Api not worked.";
    }

  }

}
