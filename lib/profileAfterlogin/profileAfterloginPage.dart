import 'package:envi/Profile/newprofilePage.dart';
import 'package:envi/uiwidget/robotoTextWidget.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../login/model/LoginModel.dart';
import '../main.dart';
import '../theme/color.dart';
import '../theme/string.dart';
import '../web_service/Constant.dart';

class ProfileAfterloginPage extends StatefulWidget {
  LoginModel profiledata;
  ProfileAfterloginPage({required this.profiledata});
  @override
  State<ProfileAfterloginPage> createState() => _profileAfterloginPageState();
}

class _profileAfterloginPageState extends State<ProfileAfterloginPage> {
  var _formKey = GlobalKey<FormState>();
  var isLoading = false;
  bool _showmobileview = true;

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
              decoration: const BoxDecoration(boxShadow: [
                BoxShadow(
                  color: AppColor.white,
                  blurRadius: 20.0, // soften the shadow
                )
              ]),
              child: isLoading
                  ? const Center(child: const CircularProgressIndicator())
                  : profileContinue(),
            ),
          ],
        ),
      ),
    );
  }

  Form profileContinue() {
    String gender = "";
    if (widget.profiledata.gender.toString() == "m") {
      gender = "Male";
    } else if (widget.profiledata.gender.toString() == "f") {
      gender = "Female";
    } else {
      gender = "";
    }
    return Form(
      key: _formKey,
      child: Center(
        child: Column(
          children: <Widget>[
            // Image.asset(
            //   "assets/images/logo.png",
            //   width: 276,
            //   fit: BoxFit.fill,
            // ),
            Image.asset(
              "assets/images/envi-logo-small.png",
              width: 112,
              height: 140,
              fit: BoxFit.none,
            ),
            const SizedBox(
              height: 15,
            ),
            robotoTextWidget(
                textval: "Wellcome back, ${widget.profiledata.name}!",
                colorval: AppColor.black,
                sizeval: 20.0,
                fontWeight: FontWeight.bold),
            robotoTextWidget(
                textval: reviewprofile,
                colorval: AppColor.black,
                sizeval: 16.0,
                fontWeight: FontWeight.normal),
            const SizedBox(
              height: 20,
            ),
            Card(
              semanticContainer: true,
              clipBehavior: Clip.antiAliasWithSaveLayer,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              elevation: 5,
              child: Container(
                color: AppColor.white,
                padding: const EdgeInsets.symmetric(horizontal: 5.0),
                child: Align(
                    alignment: Alignment.center,
                    child: Column(
                      children: [
                        Row(
                          children: [
                            const SizedBox(
                              height: 20,
                            ),
                            const Spacer(),
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => NewProfilePage(
                                              user: widget.profiledata,
                                            )));
                              },
                              child: const Icon(
                                Icons.edit_note_outlined,
                                size: 30,
                                color: AppColor.darkGreen,
                              ),
                            ),
                          ],
                        ),
                        ClipRRect(
                            borderRadius: BorderRadius.circular(55.0),
                            child: FadeInImage.assetNetwork(
                                height: 100,
                                width: 100,
                                fit: BoxFit.fill,
                                placeholder:
                                    'assets/images/envi-logo-small.png',
                                image:
                                    '$imageServerurl${widget.profiledata.propic}')),
                        const SizedBox(
                          height: 5,
                        ),
                        robotoTextWidget(
                            textval: widget.profiledata.name,
                            colorval: AppColor.black,
                            sizeval: 18.0,
                            fontWeight: FontWeight.normal),
                        const SizedBox(
                          height: 5,
                        ),
                        robotoTextWidget(
                            textval: gender,
                            colorval: AppColor.textgray,
                            sizeval: 14.0,
                            fontWeight: FontWeight.normal),
                        const SizedBox(
                          height: 5,
                        ),
                        robotoTextWidget(
                            textval: widget.profiledata.phone,
                            colorval: AppColor.textgray,
                            sizeval: 14.0,
                            fontWeight: FontWeight.normal),
                        const SizedBox(
                          height: 5,
                        ),
                        robotoTextWidget(
                            textval: widget.profiledata.mailid,
                            colorval: AppColor.textgray,
                            sizeval: 14.0,
                            fontWeight: FontWeight.normal),
                        const SizedBox(
                          height: 20,
                        ),
                      ],
                    )),
              ),
            ),
            const SizedBox(
              height: 20,
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
                  child: Align(
                    alignment: Alignment.center,
                    child: TextButton(
                        style: TextButton.styleFrom(
                          primary: Colors.white,
                        ),
                        onPressed: () async {
                          SharedPreferences sharedPreferences =
                              await SharedPreferences.getInstance();
                          sharedPreferences.setString(
                              LoginEmail, widget.profiledata.mailid);
                          sharedPreferences.setString(
                              LoginToken, widget.profiledata.token);
                          sharedPreferences.setString(
                              LoginID, widget.profiledata.id);
                          sharedPreferences.setString(
                              Loginpropic, widget.profiledata.propic);
                          sharedPreferences.setString(
                              Logingender, widget.profiledata.gender);
                          sharedPreferences.setString(
                              Loginphone, widget.profiledata.phone);
                          sharedPreferences.setString(
                              LoginName, widget.profiledata.name);
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => MainEntryPoint()));
                        },
                        child: robotoTextWidget(
                            textval: continuebut,
                            colorval: AppColor.white,
                            sizeval: 17.0,
                            fontWeight: FontWeight.bold)),
                  ),
                )),
            const SizedBox(
              height: 20,
            ),
            Card(
                semanticContainer: true,
                clipBehavior: Clip.antiAliasWithSaveLayer,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5.0),
                ),
                elevation: 5,
                child: Container(
                  color: AppColor.white,
                  width: MediaQuery.of(context).size.width,
                  height: 40.0,
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: MaterialButton(
                    minWidth: double.infinity,
                    height: 45,
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => MainEntryPoint()));
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
}
