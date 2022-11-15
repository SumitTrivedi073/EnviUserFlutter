import 'package:envi/Profile/newprofilePage.dart';
import 'package:envi/appConfig/Profiledata.dart';
import 'package:envi/uiwidget/robotoTextWidget.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../login/model/LoginModel.dart';
import '../main.dart';
import '../theme/color.dart';
import '../theme/images.dart';
import '../theme/string.dart';
import '../utils/utility.dart';
import '../web_service/Constant.dart';

class ProfileAfterloginPage extends StatefulWidget {
  LoginModel profiledatamodel;
  ProfileAfterloginPage({required this.profiledatamodel});
  @override
  State<ProfileAfterloginPage> createState() => _profileAfterloginPageState();
}

class _profileAfterloginPageState extends State<ProfileAfterloginPage> {
  var _formKey = GlobalKey<FormState>();
  var isLoading = false;
  LoginModel? user;
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
    sharedPreferences.setString(loginID, "1");
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (BuildContext context) => MainEntryPoint()),
        (Route<dynamic> route) => false);
  }

  @override
  void initState() {
    // TODO: implement initState
    user = widget.profiledatamodel;
    super.initState();
  }

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
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
              decoration: const BoxDecoration(boxShadow: [
                BoxShadow(
                  color: AppColor.white,
                  blurRadius: 20.0, // soften the shadow
                )
              ]),
              child: isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : profileContinue(),
            ),
          ],
        ),
      ),
    );
  }

  Form profileContinue() {
    String gender = "";
    if (user!.gender.toString() == "m") {
      gender = "Male";
    } else if (user!.gender.toString() == "f") {
      gender = "Female";
    } else {
      gender = "";
    }
    return Form(
      key: _formKey,
      child: Center(
        child: Column(
          children: <Widget>[
            Image.asset(
              "assets/images/envi-logo-small.png",
              width: 140,
              height: 140,
              fit: BoxFit.none,
            ),
            const SizedBox(
              height: 15,
            ),
            robotoTextWidget(
                textval: "Welcome back, ${user!.name.toTitleCase()}!",
                colorval: AppColor.black,
                sizeval: 20.0,
                fontWeight: FontWeight.bold),
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
                                              user: user!,
                                              isUpdate: true,
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
                          child: Image.network(
                            encodeImgURLString(user!.propic),
                            loadingBuilder: (BuildContext context, Widget child,
                                ImageChunkEvent? loadingProgress) {
                              if (loadingProgress == null) return child;
                              return Center(
                                child: CircularProgressIndicator(
                                  value: loadingProgress.expectedTotalBytes !=
                                          null
                                      ? loadingProgress.cumulativeBytesLoaded /
                                          loadingProgress.expectedTotalBytes!
                                      : null,
                                ),
                              );
                            },
                            errorBuilder: (context, error, stackTrace) {
                              return Image.asset(
                                Images.personPlaceHolderImage,
                                height: 50,
                                width: 50,
                              );
                            },
                            fit: BoxFit.fill,
                            height: 100,
                            width: 100,
                          ),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        robotoTextWidget(
                            textval: user!.name.toTitleCase(),
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
                            textval: user!.phone,
                            colorval: AppColor.textgray,
                            sizeval: 14.0,
                            fontWeight: FontWeight.normal),
                        const SizedBox(
                          height: 5,
                        ),
                        robotoTextWidget(
                            textval: user!.mailid,
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
                          sharedPreferences.setString(loginEmail, user!.mailid);
                          sharedPreferences.setString(loginToken, user!.token);
                          sharedPreferences.setString(loginID, user!.id);
                          sharedPreferences.setString(
                              loginpropic, encodeImgURLString(user!.propic));
                          sharedPreferences.setString(
                              logingender, user!.gender);
                          sharedPreferences.setString(loginPhone, user!.phone);
                          sharedPreferences.setString(loginName, user!.name);
                          Profiledata.setusreid(user!.id);
                          Profiledata.settoken(user!.token);
                          Profiledata.setmailid(user!.mailid);
                          Profiledata.setpropic(
                              encodeImgURLString(user!.propic));
                          Profiledata.setphone(user!.phone);
                          Profiledata.setgender(user!.gender);
                          Profiledata.setname(user!.name);
                          if (!mounted) return;
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => MainEntryPoint()));
                        },
                        child: robotoTextWidget(
                            textval: continuebut.toUpperCase(),
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
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => MainEntryPoint()));
                    },
                    child: robotoTextWidget(
                        textval: loginwithdeffrentnumber,
                        colorval: AppColor.black,
                        sizeval: 14.0,
                        fontWeight: FontWeight.bold),
                  ),
                )),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
