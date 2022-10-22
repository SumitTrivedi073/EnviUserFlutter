import 'dart:convert';
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
import 'package:shared_preferences/shared_preferences.dart';
import '../main.dart';
import '../web_service/Constant.dart';
import 'dart:io' as Io;
import 'package:flutter/services.dart' show rootBundle;

import 'package:path_provider/path_provider.dart';

class NewProfilePage extends StatefulWidget {
  const NewProfilePage(
      {Key? key, this.user, required this.isUpdate, this.callback, this.phone})
      : super(key: key);
  final LoginModel? user;
  final bool isUpdate;
  final String? phone;
  final void Function(LoginModel user)? callback;

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

  bool isEmail(String em) {
    String p =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';

    RegExp regExp = RegExp(p);

    return regExp.hasMatch(em);
  }

  final _profileForm = GlobalKey<FormState>();
  void updateUser() {
    _emailController.text = widget.user!.mailid;
    _phoneNoController.text = widget.user!.phone;
    _firstNameController.text = widget.user!.name;
    if (widget.user!.gender.toString().toLowerCase() == "m" ||
        widget.user!.gender.toString() == "Male") {
      selectedGender = "Male";
    } else if (widget.user!.gender.toString().toLowerCase() == "f" ||
        widget.user!.gender.toString() == "Female") {
      selectedGender = "Female";
    } else {
      selectedGender = "I'd rather not say";
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    // imagePicker = ImagePicker();
    if (widget.isUpdate) {
      updateUser();
    } else {
      _phoneNoController.text = widget.phone ?? '';
    }
    super.initState();
  }

  Future<File> getImageFileFromAssets() async {
    var bytes = await rootBundle.load('assets/images/logo.png');
    String tempPath = (await getTemporaryDirectory()).path;
    File file = File('$tempPath/profile.png');
    await file.writeAsBytes(
        bytes.buffer.asUint8List(bytes.offsetInBytes, bytes.lengthInBytes));

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
                              child: (widget.isUpdate)
                                  ? (_image != null)
                                      ? Image.file(
                                          _image!,
                                          width: 100.0,
                                          height: 100.0,
                                          fit: BoxFit.fitHeight,
                                        )
                                      : Container(
                                          child: FadeInImage.assetNetwork(
                                              height: 100,
                                              width: 100,
                                              fit: BoxFit.fill,
                                              placeholder:
                                                  'assets/images/envi-logo-small.png',
                                              image: encodeImgURLString(
                                                  widget.user!.propic)))
                                  : (_image != null)
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
                                    autovalidateMode:
                                        AutovalidateMode.onUserInteraction,
                                    validator: (value) {
                                      return Utility()
                                          .validatorText(value: value);
                                    },
                                    decoration: InputDecoration(
                                        contentPadding:
                                            const EdgeInsets.fromLTRB(
                                                20, 12, 20, 12),
                                        hintText: nameText,
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
                                  // TextFormField(
                                  //   controller: _lastNameController,
                                  //   decoration: InputDecoration(
                                  //       filled: true,
                                  //       contentPadding:
                                  //           const EdgeInsets.fromLTRB(
                                  //               20, 12, 20, 12),
                                  //       hintText: lname,
                                  //       hintStyle:
                                  //           AppTextStyle.robotoRegular18Gray,
                                  //       border: InputBorder.none,
                                  //       fillColor: AppColor.textfieldlightgrey),
                                  //   textAlign: TextAlign.left,
                                  // ),
                                  // const SizedBox(
                                  //   height: 5,
                                  // ),
                                  DropDownWidget(
                                    children: [
                                      maleText,
                                      femaleText,
                                      ratherNotSayText,
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
                        SizedBox(
                          height: 10,
                        ),
                        (widget.isUpdate)
                            ? TextFormField(
                                enabled: (widget.isUpdate) ? false : true,
                                controller: _phoneNoController,
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                validator: (value) {
                                  return Utility().validatorText(
                                      value: value,
                                      shouldBeNumber: true,
                                      minLimit: 10,
                                      isMandatary: true,
                                      maxLimit: 12);
                                },
                                decoration: const InputDecoration(
                                    filled: true,
                                    suffixIcon: Icon(
                                      Icons.edit_note_outlined,
                                      size: 30,
                                    ),
                                    hintText: 'Phone Number',
                                    hintStyle: AppTextStyle.robotoRegular18Gray,
                                    border: InputBorder.none,
                                    contentPadding: const EdgeInsets.all(10.0),
                                    isDense: true,
                                    fillColor: AppColor.textfieldlightgrey),
                                style: AppTextStyle.robotoRegular18,
                              )
                            : TextFormField(
                                enabled: (widget.isUpdate) ? false : true,
                                controller: _phoneNoController,
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                validator: (value) {
                                  return Utility().validatorText(
                                      value: value,
                                      shouldBeNumber: true,
                                      minLimit: 10,
                                      isMandatary: true,
                                      maxLimit: 12);
                                },
                                decoration: const InputDecoration(
                                    filled: true,
                                    hintText: 'Phone Number',
                                    hintStyle: AppTextStyle.robotoRegular18Gray,
                                    border: InputBorder.none,
                                    contentPadding: const EdgeInsets.all(10.0),
                                    isDense: true,
                                    fillColor: AppColor.textfieldlightgrey),
                                style: AppTextStyle.robotoRegular18,
                              ),
                        const SizedBox(
                          height: 20,
                        ),
                        TextFormField(
                          enabled: (widget.isUpdate) ? false : true,
                          controller: _emailController,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please fill this input field';
                            } else {
                              final isEmailCorrect = isEmail(value);
                              if (!isEmailCorrect) {
                                return 'Invalid Email';
                              } else {
                                return null;
                              }
                            }
                          },
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
                  if (widget.isUpdate) {
                    SharedPreferences sharedPreferences =
                        await SharedPreferences.getInstance();

                    var id = sharedPreferences.getString(loginID);
                    UserApiService userApi = UserApiService();
                    final response = await userApi.userEditProfile(
                        image: _image,
                        token: widget.user!.token,
                        name: _firstNameController.text,
                        gender: selectedGender!,
                        email: _emailController.text);
                    String updatedImg = '';
                    if (response != null &&
                        response['message'] ==
                            'user-profile updated successfully ') {
                      LoginModel usr = LoginModel(
                          widget.user!.token,
                          id ?? widget.user!.id,
                          _firstNameController.text,
                          response['pro_pic'] ?? widget.user!.propic,
                          selectedGender!,
                          widget.user!.phone,
                          widget.user!.mailid);
                      widget.callback!(usr);
                      // utility.showInSnackBar(
                      //     value: updatedSuccessText,
                      //     context: context,
                      //     duration: const Duration(seconds: 3));
                      showToast(updatedSuccessText);
                      Future.delayed(const Duration(seconds: 2), () {
                        Navigator.of(context).pop();
                      });
                    } else {
                      showToast(failedToUpdateText);
                      // utility.showInSnackBar(
                      //     value: failedToUpdateText,
                      //     context: context,
                      //     duration: const Duration(seconds: 3));
                    }
                  } else {
                    if (!mounted) return;
                    if (_profileForm.currentState!.validate()) {
                      SharedPreferences sharedPreferences =
                          await SharedPreferences.getInstance();
                      UserApiService userApi = UserApiService();
                      final response = await userApi.registerNewUser(
                          image: _image ?? await getImageFileFromAssets(),
                          name: _firstNameController.text,
                          gender: selectedGender!,
                          email: _emailController.text,
                          deviceId:
                              sharedPreferences.getString(deviceIdShared)!,
                          fcmToken:
                              sharedPreferences.getString(fcmTokenShared)!,
                          phoneNo: _phoneNoController.text);
                      if (response != null &&
                          response['message'] == 'registerd successfully') {
                        sharedPreferences.setString(
                            loginEmail, _emailController.text);
                        sharedPreferences.setString(
                            loginToken, response['content']['token']);
                        sharedPreferences.setString(
                            loginID, response['content']['userid']);
                        sharedPreferences.setString(
                            logingender, selectedGender!);
                        sharedPreferences.setString(
                            loginPhone, _phoneNoController.text);
                        sharedPreferences.setString(
                            loginName, _firstNameController.text);
                        sharedPreferences.setString(loginpropic,
                            encodeImgURLString(response['content']['image']));
                        // Future.delayed(Duration(microseconds: 200))
                        //     .then((value) {
                        //   utility.showInSnackBar(
                        //       value: 'Registered Successfully',
                        //       context: context,
                        //       duration: const Duration(seconds: 2));
                        // });
                        showToast('Registered Successfully');
                        Future.delayed(const Duration(seconds: 2), () {
                          if (!mounted) return;

                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => MainEntryPoint()));
                        });
                      } else {
                        showToast(failedRegister);
                        // utility.showInSnackBar(
                        //     value: failedRegister,
                        //     context: context,
                        //     duration: const Duration(seconds: 2));
                      }
                    }
                  }
                },
                height: 48,
                minWidth: double.infinity,
                color: AppColor.greyblack,
                child: Text(
                  (widget.isUpdate) ? 'Update Account' : createAccountText,
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
