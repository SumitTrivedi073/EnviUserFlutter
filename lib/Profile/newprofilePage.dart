import 'package:envi/theme/string.dart';
import 'package:envi/uiwidget/dropdown.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

import '../web_service/Constant.dart';

class NewProfilePage extends StatefulWidget {
  const NewProfilePage({Key? key}) : super(key: key);

  @override
  State<NewProfilePage> createState() => _NewProfilePageState();
}

class _NewProfilePageState extends State<NewProfilePage> {
  String? selectedGender;
  //choose gender
  void chooseGender(String val) {
    setState(() {
      selectedGender = val;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(PageBackgroundImage),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          children: [
            Image.asset(
              "assets/images/logo.png",
              width: 140,
              height: 140,
              fit: BoxFit.none,
            ),
            DropDownWidget(
              children: [maleText, femaleText, ratherNotSayText],
              width: double.infinity,
              backGroundColor: Colors.white,
              selectedValue: selectedGender,
              onChange: (val) {
                chooseGender(val);
              },
            ),

        MaterialButton(onPressed: () {

        },
        )
          ],
        ),
      ),
    ));
  }
}
