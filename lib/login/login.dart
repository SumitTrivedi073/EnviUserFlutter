import 'dart:async';
import 'dart:convert' as convert;
import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';

import 'package:envi/profileAfterlogin/profileAfterloginPage.dart';
import 'package:envi/theme/theme.dart';
import 'package:envi/uiwidget/robotoTextWidget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../web_service/HTTP.dart' as HTTP;
import '../Profile/newprofilePage.dart';
import '../theme/color.dart';
import '../theme/string.dart';
import '../utils/utility.dart';
import '../web_service/APIDirectory.dart';
import '../web_service/ApiConfig.dart';
import '../web_service/Constant.dart';
import 'model/LoginModel.dart';

class Loginpage extends StatefulWidget {
  const Loginpage({Key? key}) : super(key: key);

  @override
  State<Loginpage> createState() => _LoginpageState();
}

class _LoginpageState extends State<Loginpage> {
  var _formKey = GlobalKey<FormState>();
  var _formKeyofrverify = GlobalKey<FormState>();
  var isLoading = false;
  bool _showmobileview = true;
  String loginverificationId = "";
  TextEditingController phoneController = new TextEditingController();
  TextEditingController otpController = new TextEditingController();
  TextEditingController plushcontroller = new TextEditingController();
  TextEditingController countrycontroller = new TextEditingController();
  final FirebaseAuth auth = FirebaseAuth.instance;
  Timer? _timer = null;
  int _start = 60;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkPermission();
    plushcontroller.text = "+";
    countrycontroller.text = "91";
    deleteAlldata();
  }

  Future checkPermission() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission != PermissionStatus.granted) {
      LocationPermission permission = await Geolocator.requestPermission();
      if (permission != PermissionStatus.granted) {
        print("permission Approved");
      }
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //body
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(PageBackgroundImage),
              fit: BoxFit.cover,
            ),
          ),
          child: Column(
            // Vertically center the widget inside the column
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                margin: const EdgeInsets.only(left: 30, right: 30),
                width: MediaQuery.of(context).size.width > 400
                    ? 400
                    : MediaQuery.of(context).size.width,
                decoration: BoxDecoration(boxShadow: [
                  BoxShadow(
                    color: Colors.white.withOpacity(.5),
                    blurRadius: 20.0, // soften the shadow
                  )
                ]),
                child: isLoading
                    ? const Center(child: const CircularProgressIndicator())
                    : _showmobileview
                        ? loginview()
                        : verifyview(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    if (_timer != null && _timer!.isActive) {
      _timer!.cancel();
    }
    super.dispose();
  }

  Form verifyview() {
    return Form(
      key: _formKeyofrverify,
      child: Center(
        child: Column(
          children: <Widget>[
          Card(
          semanticContainer: true,
        clipBehavior: Clip.antiAliasWithSaveLayer,
        shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
    ),
    elevation: 5,
    child: Container(
    color: AppColor.white,
    padding: const EdgeInsets.symmetric(horizontal: 15.0),
    child: Align(
    alignment: Alignment.center,
    child:Column(children: [

      const SizedBox(
        height: 20,
      ),
      Image.asset(
        "assets/images/envi-logo-small.png",
        width: 276,
        fit: BoxFit.fill,
      ),
      const SizedBox(
        height: 15,
      ),
      robotoTextWidget(
          textval:
          'OTP SENT TO +${countrycontroller.text} ${phoneController.text}',
          colorval: AppColor.black,
          sizeval: 14.0,
          fontWeight: FontWeight.w600),
      if(_start > 0)

        robotoTextWidget(
            textval: "00:$_start",
            colorval: AppColor.black,
            sizeval: 17.0,
            fontWeight: FontWeight.bold),
      const SizedBox(
        height: 10,
      ),
      TextFormField(
        controller: otpController,
        inputFormatters: [LengthLimitingTextInputFormatter(6)],
        keyboardType: TextInputType.phone,
        style: const TextStyle(color: AppColor.black),
        decoration: const InputDecoration(
          hintText: "Enter OTP",
          hintStyle: TextStyle(color: Colors.black45),
        ),
        validator: (value) {
          if (value!.isEmpty) {
            return 'Please enter valid OTP!';
          }
          return null;
        },
      ),
      const SizedBox(
        height: 20,
      ),
    ])))),

            const SizedBox(
              height: 15,
            ),
        Card(
          semanticContainer: true,
          clipBehavior: Clip.antiAliasWithSaveLayer,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5.0),
          ),
          elevation: 5,
          child:Container(
            color: AppColor.greyblack,
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Align(
                alignment: Alignment.center,
                child: TextButton(
                    style: TextButton.styleFrom(
                      primary: Colors.teal,
                    ),
                    onPressed: () {
                      final isValid =
                          _formKeyofrverify.currentState!.validate();
                      if (!isValid) {
                        return;
                      }

                      _formKeyofrverify.currentState!.save();
                      setState(() {
                        isLoading = true;
                      });
                      verifyotp();
                    },
                    child: robotoTextWidget(
                        textval: verify,
                        colorval: AppColor.white,
                        sizeval: 17.0,
                        fontWeight: FontWeight.w800)),
              ),
            ),),

        if(_start < 0)
        Card(
          semanticContainer: true,
          clipBehavior: Clip.antiAliasWithSaveLayer,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5.0),
          ),
          elevation: 5,
          child: Container(
            color: AppColor.greyblack,
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Align(
                alignment: Alignment.center,
                child: TextButton(
                    style: TextButton.styleFrom(
                      primary: Colors.teal,
                    ),
                    onPressed: () {
                      if (_start < 0) {
                        fetchotp(
                            phoneNumber:
                                "+${countrycontroller.text}${phoneController.text}");
                      }
                    },
                    child: robotoTextWidget(
                            textval: resend,
                            colorval: AppColor.white,
                            sizeval: 16.0,
                            fontWeight: FontWeight.bold)),
              ),
            )),
            const SizedBox(
              height: 15,
            ),
        Card(
          semanticContainer: true,
          clipBehavior: Clip.antiAliasWithSaveLayer,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5.0),
          ),
          elevation: 5,
          child:Container(
            color: AppColor.white,
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: MaterialButton(
                minWidth: double.infinity,
                height: 25,
                onPressed: () {
                  setState(() {
                    if (_timer != null && _timer!.isActive) {
                      _timer!.cancel();
                    }
                    _showmobileview = true;
                  });
                },
                child: robotoTextWidget(
                    textval: loginwithdeffrentnumber,
                    colorval: AppColor.black,
                    sizeval: 17.0,
                    fontWeight: FontWeight.bold),
              ),
            )),
          ],
        ),
      ),
    );
  }

  Form loginview() {
    return Form(
      key: _formKey,
      child: Center(
        child: Column(
          children: <Widget>[

            Card(
            semanticContainer: true,
            clipBehavior: Clip.antiAliasWithSaveLayer,
    shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(10.0),
    ),
    elevation: 5,
    child: Container(
    color: AppColor.white,
    padding: const EdgeInsets.symmetric(horizontal: 15.0),
    child: Align(
    alignment: Alignment.center,
              child:Column(children: [
                const SizedBox(
                  height: 20,
                ),
                Image.asset(
                  "assets/images/envi-logo-small.png",
                  width: 276,
                  fit: BoxFit.none,
                ),
                const SizedBox(
                  height: 15,
                ),
                robotoTextWidget(
                    textval: welcome,
                    colorval: AppColor.black,
                    sizeval: 20.0,
                    fontWeight: FontWeight.bold),

                const SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Expanded(
                    //   child: TextFormField(
                    //     textAlign: TextAlign.center,
                    //     controller: plushcontroller,
                    //     readOnly: true,
                    //     style: const TextStyle(color: AppColor.black),
                    //   ),
                    // ),
                    const SizedBox(
                      width: 5,
                    ),
                    Expanded(
                      flex: 2,
                      child: TextFormField(
                        textAlign: TextAlign.center,
                        controller: countrycontroller,
                        keyboardType: TextInputType.phone,
                        style: const TextStyle(color: AppColor.black),
                        decoration: const InputDecoration(
                          prefixText: '+',
                          // hintText: "country code",
                          hintStyle: TextStyle(
                            color: Colors.black45,
                            fontSize:18
                          ),
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter valid country code!';
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    Expanded(
                      flex: 6, // wrap your Column in Expanded
                      child: TextFormField(
                        controller: phoneController,
                        // maxLength: 12,
                        inputFormatters: [LengthLimitingTextInputFormatter(12)],
                        keyboardType: TextInputType.number,
                        style: const TextStyle(color: AppColor.black),
                        decoration: const InputDecoration(
                          hintText: "phone number",
                          hintStyle:
                          TextStyle(color: Colors.black45, fontSize: 18),
                        ),
                        validator: (value) {
                          if (value!.isEmpty ||
                              !RegExp("^[\+]?[(]?[0-9]{3}[)]?[-\s\.]?[0-9]{3}[-\s\.]?[0-9]{4,6}")
                                  .hasMatch(value)) {
                            return 'Please enter valid phone number!';
                          }

                          return null;
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
              ],)
      ),)
            ),

            const SizedBox(
              height: 15,
            ),
        Card(
          semanticContainer: true,
          clipBehavior: Clip.antiAliasWithSaveLayer,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5.0),
          ),
          elevation: 5,
          child: Container(
            color: AppColor.greyblack,
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: MaterialButton(
                minWidth: double.infinity,
                height: 45,
                onPressed: () {
                  final isValid = _formKey.currentState!.validate();
                  if (!isValid) {
                    return;
                  }
                  _formKey.currentState!.save();

                  if (_showmobileview) {
                    setState(() {
                      isLoading = true;
                    });

                    if (isEmulation) {
                      signIn();
                    } else {
                      fetchotp(
                          phoneNumber:
                              "+${countrycontroller.text}${phoneController.text}");
                    }
                  }
                },
                child: robotoTextWidget(
                    textval: submitAllCapsText,
                    colorval: AppColor.white,
                    sizeval: 17.0,
                    fontWeight: FontWeight.bold),
              ),
            ),),

            const SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> fetchotp({required String phoneNumber}) async {
    await auth.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      verificationCompleted: (PhoneAuthCredential credential) async {
        await auth.signInWithCredential(credential);
      },
      verificationFailed: (FirebaseAuthException e) {
        if (e.code == 'invalid-phone-number') {
          print('The provided phone number is not valid.');
        }
        setState(() {
          isLoading = false;
        });
        showSnackbar(context, e.message.toString());
      },
      codeSent: (String verificationId, int? resendToken) async {
        loginverificationId = verificationId;
        _start = 60;
        startTimer();
        setState(() {
          isLoading = false;
        });
        _showmobileview = false;
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        // print("object");
      },
    );
  }

  Future<void> verifyotp() async {
    PhoneAuthCredential phoneAuthCredential = PhoneAuthProvider.credential(
        verificationId: loginverificationId, smsCode: otpController.text);

    signInWithPhoneAuthCredential(phoneAuthCredential);
  }

  void signInWithPhoneAuthCredential(
      PhoneAuthCredential phoneAuthCredential) async {
    try {
      final authCredential =
          await auth.signInWithCredential(phoneAuthCredential);
      if (authCredential.user != null) {
        setState(() {
          isLoading = true;
        });

        if (_timer != null && _timer!.isActive) {
          _timer!.cancel();

          _start=0;
        }
        signIn();
      }
    } on FirebaseAuthException catch (e) {
      print("catch$e");
      if (_timer != null && _timer!.isActive) {
        _timer!.cancel();
        _start =0;
      }


      setState(() {
        isLoading = false;
      });
      showSnackbar(context, e.message.toString());
    }
  }

  void startTimer() {
    const oneSec = const Duration(seconds: 1);
    _timer = Timer.periodic(
        oneSec,
        (Timer timer) => setState(() {
              if (_start < 0) {
                timer.cancel();
              } else {
                setState(() {
                 // print(_start);
                  _start = _start - 1;
                });
              }
            }));
  }

  _getId() async {
    var deviceInfo = DeviceInfoPlugin();
    if (Platform.isIOS) {
      // import 'dart:io'
      var iosDeviceInfo = await deviceInfo.iosInfo;
      return iosDeviceInfo.identifierForVendor; // Unique ID on iOS
    } else {
      var androidDeviceInfo = await deviceInfo.androidInfo;
      return androidDeviceInfo.id; // Unique ID on Android
    }
  }

  void signIn() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    String? deviceId = await _getId();
    final fcmToken = await FirebaseMessaging.instance.getToken();
    Map data = {
      "countrycode": countrycontroller.text.toString(),
      "phone": phoneController.text.toString(),
      "FcmToken": fcmToken,
      "deviceId": deviceId
    };

    print(data);
    sharedPreferences.setString(deviceIdShared, deviceId!);
    sharedPreferences.setString(fcmTokenShared, fcmToken!);
    var jsonData = null;
    dynamic response = await HTTP.post(userLogin(), data);
    print(response.statusCode);
   // print("jsonData========>${convert.jsonDecode(response.body)}");
    if (response != null && response.statusCode == 200) {
      isLoading = false;
      jsonData = convert.jsonDecode(response.body);

      LoginModel users = LoginModel.fromJson(jsonData['content']);

      setState(() {


        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ProfileAfterloginPage(
                      profiledatamodel: users,
                    )));
      });
    } else {
      if (response.statusCode == 400) {
        if (!mounted) return;
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => NewProfilePage(
                      isUpdate: false,
                      phone: phoneController.text.toString(),
                      countryCode: countrycontroller.text,
                    )));
        isLoading = false;
        setState(() {});
      } else {
        if (!mounted) return;
        showSnackbar(context, 'Unable To Login');
      }
    }
  }
}
