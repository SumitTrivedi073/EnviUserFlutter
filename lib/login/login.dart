import 'package:envi/Profile/profilePage.dart';
import 'package:envi/uiwidget/robotoTextWidget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../main.dart';
import '../theme/color.dart';
import '../theme/string.dart';
import '../web_service/Constant.dart';

class Loginpage extends StatefulWidget {
  const Loginpage({Key? key}) : super(key: key);

  @override
  State<Loginpage> createState() => _LoginpageState();
}

class _LoginpageState extends State<Loginpage> {
  var _formKey = GlobalKey<FormState>();
  var isLoading = false;
  bool _showmobileview = true;
  String? verificationId;
  TextEditingController phoneController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();
  TextEditingController plushcontroller = new TextEditingController();
  TextEditingController countrycontroller = new TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  Future<void> _submit() async {
    final isValid = _formKey.currentState!.validate();
    if (!isValid) {
      return;
    }
    _formKey.currentState!.save();
    setState(() {
      isLoading = true;
    });
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setString(LoginID, "1");
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (BuildContext context) => MainEntryPoint()),
        (Route<dynamic> route) => false);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkPermission();
    plushcontroller.text = "+";
    countrycontroller.text = "91";
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
      body: Container(
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
                  : _showmobileview ? loginview() :verifyview(),
            ),
          ],
        ),
      ),
    );
  }
  Form verifyview(){
    return  Form(
      key: _formKey,
      child: Center(
        child: Column(
          children: <Widget>[
robotoTextWidget(textval: verifymsg, colorval: AppColor.black, sizeval: 17.0, fontWeight: FontWeight.normal),
            TextFormField(
              controller: phoneController,
              keyboardType: TextInputType.phone,

              style: const TextStyle(color: AppColor.black),
              decoration: const InputDecoration(
                  hintText: "Please enter OTP",
                  hintStyle: TextStyle(color: Colors.black45),
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
            SizedBox(height:15,),
            Container(
              padding:
              const EdgeInsets.symmetric(horizontal: 20.0),
              child: Align(
                alignment: Alignment.center,
                child: TextButton(
                    style: TextButton.styleFrom(
                      primary: Colors.teal,
                    ),
                    onPressed: () {
                      Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(
                              builder: (BuildContext context) => ProfilePage()),
                              (Route<dynamic> route) => false);
                    },
                    child:  robotoTextWidget(textval: verify, colorval: AppColor.butgreen, sizeval: 17.0, fontWeight: FontWeight.bold)
                ),
              ),
            ),
            Container(
              padding:
              const EdgeInsets.symmetric(horizontal: 20.0),
              child: Align(
                alignment: Alignment.center,
                child: TextButton(
                  style: TextButton.styleFrom(
                    primary: Colors.teal,
                  ),
                  onPressed: () {},
                  child:  robotoTextWidget(textval: resend, colorval: AppColor.butgreen, sizeval: 17.0, fontWeight: FontWeight.bold)
                ),
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              height: 40.0,
              padding:
              const EdgeInsets.symmetric(horizontal: 20.0),

              child: MaterialButton(
                minWidth: double.infinity,
                height: 45,
                onPressed: () {

                    setState(() {
                      _showmobileview = true;
                    });

                },


                child: robotoTextWidget(textval: numberedit, colorval: AppColor.butgreen, sizeval: 17.0, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
  Form loginview(){
    return  Form(
      key: _formKey,
      child: Center(
        child: Column(
          children: <Widget>[
            robotoTextWidget(textval: welcome, colorval: AppColor.black, sizeval: 17.0, fontWeight: FontWeight.bold),
            robotoTextWidget(textval: mobilevalidation, colorval: AppColor.black, sizeval: 17.0, fontWeight: FontWeight.normal),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                 Expanded(child:   TextFormField(
controller: plushcontroller,
readOnly: true,
                   style: const TextStyle(color: AppColor.black),

                 ),
                 ),

                SizedBox(width: 5,),
                 Expanded(
                   flex:2,child:   TextFormField(
                  controller: countrycontroller,
                  keyboardType: TextInputType.phone,

                  style: const TextStyle(color: AppColor.black),
                  decoration: const InputDecoration(
                    hintText: "country code",
                    hintStyle: TextStyle(color: Colors.black45),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter valid country code!';
                    }
                    return null;
                  },
                ),
                ),
                SizedBox(width: 5,),
                Expanded(
                  flex: 5,// wrap your Column in Expanded
                  child:  TextFormField(
                    controller: phoneController,
                    keyboardType: TextInputType.phone,

                    style: const TextStyle(color: AppColor.black),
                    decoration: const InputDecoration(
                      hintText: "Please enter phone number",
                      hintStyle: TextStyle(color: Colors.black45),
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

            Container(
              width: MediaQuery.of(context).size.width,
              height: 40.0,
              padding:
              const EdgeInsets.symmetric(horizontal: 20.0),
              margin: const EdgeInsets.only(top: 30.0),
              child: MaterialButton(
                minWidth: double.infinity,
                height: 45,
                onPressed: () {
                  if(_showmobileview){
                    setState(() {
                      phoneSignIn(phoneNumber: "+${countrycontroller.text}${plushcontroller.text}");
                      _showmobileview = false;
                    });
                  }
                },

                child:  robotoTextWidget(textval: "Submit", colorval: AppColor.butgreen, sizeval: 17.0, fontWeight: FontWeight.bold),
              ),
            ),

          ],
        ),
      ),
    );
  }
  Future<void> phoneSignIn({required String phoneNumber}) async {
    await _auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: _onVerificationCompleted,
        verificationFailed: _onVerificationFailed,
        codeSent: _onCodeSent,
        codeAutoRetrievalTimeout: _onCodeTimeout);
  }

  _onVerificationCompleted(PhoneAuthCredential authCredential) async {
    print("verification completed ${authCredential.smsCode}");
    User? user = FirebaseAuth.instance.currentUser;
    setState(() {
     // this.otpCode.text = authCredential.smsCode!;
    });
    if (authCredential.smsCode != null) {
      try{
        UserCredential credential =
        await user!.linkWithCredential(authCredential);
      }on FirebaseAuthException catch(e){
        if(e.code == 'provider-already-linked'){
          await _auth.signInWithCredential(authCredential);
        }
      }
      setState(() {
        isLoading = false;
      });
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
              builder: (BuildContext context) => ProfilePage()),
              (Route<dynamic> route) => false);
    }
  }

  _onVerificationFailed(FirebaseAuthException exception) {
    if (exception.code == 'invalid-phone-number') {
      showMessage("The phone number entered is invalid!");
    }
  }

  _onCodeSent(String verificationId, int? forceResendingToken) {
    this.verificationId = verificationId;
    print(forceResendingToken);
    print("code sent");
  }

  _onCodeTimeout(String timeout) {
    print(timeout);
    return null;
  }

  void showMessage(String errorMessage) {
    showDialog(
        context: context,
        builder: (BuildContext builderContext) {
          return AlertDialog(
            title: Text("Error"),
            content: Text(errorMessage),
            actions: [
              TextButton(
                child: Text("Ok"),
                onPressed: () async {
                  Navigator.of(builderContext).pop();
                },
              )
            ],
          );
        }).then((value) {
      setState(() {
        isLoading = false;
      });
    });
  }
}
