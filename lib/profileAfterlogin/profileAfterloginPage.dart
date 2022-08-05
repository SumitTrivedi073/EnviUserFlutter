
import 'package:envi/uiwidget/robotoTextWidget.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../main.dart';
import '../theme/color.dart';
import '../theme/string.dart';
import '../web_service/Constant.dart';

class ProfileAfterloginPage extends StatefulWidget {
  const ProfileAfterloginPage({Key? key}) : super(key: key);

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
              decoration: BoxDecoration(boxShadow: [
                BoxShadow(
                  color: Colors.white.withOpacity(.5),
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
  Form profileContinue(){
    return  Form(
      key: _formKey,
      child: Center(
        child: Column(
          children: <Widget>[
            const robotoTextWidget(textval: "Wellcome back, Nitesh!", colorval: AppColor.black, sizeval: 17.0, fontWeight: FontWeight.bold),
            robotoTextWidget(textval: reviewprofile, colorval: AppColor.black, sizeval: 17.0, fontWeight: FontWeight.normal),
SizedBox(height: 20,),
            Container(
              color: AppColor.white,
              padding:
              const EdgeInsets.symmetric(horizontal: 5.0),
              child: Align(
                alignment: Alignment.center,
                child: Column(
                  children: [
                    SizedBox(height: 20,),
                    ClipRRect(
                        borderRadius: BorderRadius.circular(55.0),
                        child: Image.network("https://i.picsum.photos/id/1001/5616/3744.jpg?hmac=38lkvX7tHXmlNbI0HzZbtkJ6_wpWyqvkX4Ty6vYElZE",
                          fit: BoxFit.fill,height: 55,
                          width: 55,)
                    ),
                    SizedBox(height: 5,),
                    robotoTextWidget(textval: "Nitesh Gupta", colorval: AppColor.greyblack, sizeval: 13.0, fontWeight: FontWeight.bold),
                    SizedBox(height: 5,),
                    robotoTextWidget(textval: "Male", colorval: AppColor.greyblack, sizeval: 13.0, fontWeight: FontWeight.normal),
                    SizedBox(height: 5,),
                    robotoTextWidget(textval: "+9424880582", colorval: AppColor.greyblack, sizeval: 13.0, fontWeight: FontWeight.normal),
                    SizedBox(height: 5,),
                    robotoTextWidget(textval: "niteshgupta@hotmail.com", colorval: AppColor.greyblack, sizeval: 13.0, fontWeight: FontWeight.normal),
                    SizedBox(height: 20,),
                  ],
                )
              ),
            ),
            SizedBox(height: 20,),
            Container(
              color: AppColor.greyblack,
              padding:
              const EdgeInsets.symmetric(horizontal: 20.0),
              child: Align(
                alignment: Alignment.center,
                child: TextButton(
                    style: TextButton.styleFrom(
                      primary: Colors.white,
                    ),
                    onPressed: () {},
                    child:  robotoTextWidget(textval: continuebut, colorval: AppColor.white, sizeval: 17.0, fontWeight: FontWeight.bold)
                ),
              ),
            ),
            SizedBox(height: 20,),
            Container(
              color: AppColor.lightwhite,
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


                child: robotoTextWidget(textval: loginwithdeffrentnumber, colorval: AppColor.black, sizeval: 17.0, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }

}
