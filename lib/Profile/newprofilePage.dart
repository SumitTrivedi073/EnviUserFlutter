import 'dart:io';

import 'package:envi/login/model/LoginModel.dart';
import 'package:envi/theme/color.dart';
import 'package:envi/theme/string.dart';
import 'package:envi/theme/styles.dart';
import 'package:envi/uiwidget/dropdown.dart';
import 'package:envi/utils/utility.dart';
import 'package:envi/web_service/ApiServices/user_api_services.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:image_picker/image_picker.dart';
import 'package:envi/web_service/HTTP.dart' as HTTP;
import '../web_service/Constant.dart';

import 'package:flutter/services.dart' show rootBundle;

import 'package:path_provider/path_provider.dart';

class NewProfilePage extends StatefulWidget {
  const NewProfilePage({Key? key, required this.user}) : super(key: key);
  final LoginModel user;
  @override
  State<NewProfilePage> createState() => _NewProfilePageState();
}

class _NewProfilePageState extends State<NewProfilePage> {
  File? _image;
  Future getImage() async {
    final img = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (img == null) return;
    final imageTemp = File(img.path);
    setState(() {
      _image = imageTemp;
    });
  }

  String? selectedGender;
  //textformfield controllers
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _phoneNoController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  //choose gender
  void chooseGender(String val) {
    setState(() {
      selectedGender = val;
    });
  }

  final _profileForm = GlobalKey<FormState>();
  void updateUser() {
    _emailController.text = widget.user.mailid;
    _phoneNoController.text = widget.user.phone;
    _firstNameController.text = widget.user.name;
    if (widget.user.gender.toString() == "m") {
      selectedGender = "Male";
    } else if (widget.user.gender.toString() == "f") {
      selectedGender = "Female";
    } else {
      selectedGender = "I'd rather not say";
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    // imagePicker = ImagePicker();
    updateUser();
    super.initState();
  }

  Future<File> getImageFileFromAssets() async {
  

  var bytes = await rootBundle.load('assets/images/logo.png');
   String tempPath = (await getTemporaryDirectory()).path;
  File file = File('$tempPath/profile.png');
  await file.writeAsBytes(bytes.buffer.asUint8List(bytes.offsetInBytes, bytes.lengthInBytes));

  return file;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
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
                "assets/images/envi-logo-small.png",
                width: 112,
                height: 140,
                fit: BoxFit.none,
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                thankYouForChoosingEnviText,
                style: AppTextStyle.robotoBold20Black,
              ),
              const SizedBox(
                height: 5,
              ),
              Text(
                letsSetUpyourProfileText,
                style: AppTextStyle.robotoRegular16,
              ),
              Form(
                key: _profileForm,
                child: Card(
                  elevation: 2,
                  shadowColor: AppColor.grey,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  color: AppColor.white,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            GestureDetector(
                              onTap: () async {
                                getImage();
                              },
                              child: (_image != null)
                                  ? Image.file(
                                      _image!,
                                      width: 100.0,
                                      height: 100.0,
                                      fit: BoxFit.fitHeight,
                                    )
                                  : Container(
                                      color: AppColor.textfieldlightgrey,
                                      height: 90,
                                      width: 90,
                                      child: const Icon(
                                        Icons.camera_alt_outlined,
                                        color: AppColor.grey,
                                      ),
                                    ),
                            ),
                            const SizedBox(
                              width: 12,
                            ),
                            Expanded(
                              child: Column(
                                children: [
                                  TextFormField(
                                    controller: _firstNameController,
                                    decoration: InputDecoration(
                                        contentPadding:
                                            const EdgeInsets.fromLTRB(
                                                20, 12, 20, 12),
                                        hintText: firstname,
                                        filled: true,
                                        hintStyle:
                                            AppTextStyle.robotoRegular18Gray,
                                        border: InputBorder.none,
                                        fillColor: AppColor.textfieldlightgrey),
                                    textAlign: TextAlign.left,
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  TextFormField(
                                    controller: _lastNameController,
                                    decoration: InputDecoration(
                                        filled: true,
                                        contentPadding:
                                            const EdgeInsets.fromLTRB(
                                                20, 12, 20, 12),
                                        hintText: lname,
                                        hintStyle:
                                            AppTextStyle.robotoRegular18Gray,
                                        border: InputBorder.none,
                                        fillColor: AppColor.textfieldlightgrey),
                                    textAlign: TextAlign.left,
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  DropDownWidget(
                                    children: [
                                      maleText,
                                      femaleText,
                                      ratherNotSayText
                                    ],
                                    endWidget: const Icon(
                                      Icons.arrow_drop_down,
                                      size: 30,
                                    ),
                                    hintText: genderText,
                                    width: double.infinity,
                                    borderRadius: BorderRadius.zero,
                                    border: Border.all(
                                        color: AppColor.white, width: 0),
                                    backGroundColor:
                                        AppColor.textfieldlightgrey,
                                    selectedValue: selectedGender,
                                    defaultValue: selectedGender,
                                    onChange: (val) {
                                      chooseGender(val);
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        TextField(
                          enabled: false,
                          controller: _phoneNoController,
                          decoration: InputDecoration(
                              filled: true,
                              suffixIcon: const Icon(
                                Icons.edit_note_outlined,
                                size: 30,
                              ),
                              hintText: examplePhoneNumberText,
                              hintStyle: AppTextStyle.robotoRegular18Gray,
                              border: InputBorder.none,
                              contentPadding: const EdgeInsets.all(10.0),
                              isDense: true,
                              fillColor: AppColor.textfieldlightgrey),
                          style: AppTextStyle.robotoRegular18,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        TextFormField(
                          enabled: false,
                          controller: _emailController,
                          decoration: InputDecoration(
                              filled: true,
                              contentPadding:
                                  EdgeInsets.fromLTRB(20, 12, 20, 12),
                              hintText: email,
                              hintStyle: AppTextStyle.robotoRegular18Gray,
                              border: InputBorder.none,
                              fillColor: AppColor.textfieldlightgrey),
                          textAlign: TextAlign.left,
                        ),
                        const SizedBox(
                          height: 50,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              MaterialButton(
                onPressed: () async {
                  UserApiService userApi = UserApiService();
                  final response = await userApi.userEditProfile(
                      image: _image??await getImageFileFromAssets(),
                      token: widget.user.token,
                      name: _firstNameController.text,
                      gender: selectedGender!,
                      email: _emailController.text);

                  if (response) {
                    utility.showInSnackBar(
                        value: updatedSuccessText,
                        context: context,
                        duration: const Duration(seconds: 3));
                    Future.delayed(const Duration(seconds: 2), () {
                      Navigator.of(context).pop();
                      setState(() {});
                    });
                  } else {
                    utility.showInSnackBar(
                        value: failedToUpdateText,
                        context: context,
                        duration: const Duration(seconds: 3));
                  }
                },
                height: 48,
                minWidth: double.infinity,
                color: AppColor.greyblack,
                child: Text(
                  createAccountText,
                  style: AppTextStyle.robotoBold20White,
                ),
              )
            ],
          ),
        ),
      ),
    ));
  }
}
