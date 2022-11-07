import 'dart:convert';
import 'dart:io';

import 'package:envi/login/model/LoginModel.dart';
import 'package:envi/theme/color.dart';
import 'package:envi/theme/string.dart';
import 'package:envi/theme/styles.dart';
import 'package:envi/uiwidget/appbarInside.dart';
import 'package:envi/uiwidget/dropdown.dart';
import 'package:envi/utils/utility.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:image_picker/image_picker.dart';
import 'package:envi/web_service/HTTP.dart' as HTTP;
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../appConfig/Profiledata.dart';
import '../main.dart';
import '../sidemenu/home/homePage.dart';
import '../theme/images.dart';
import '../web_service/APIDirectory.dart';
import '../web_service/Constant.dart';
import 'dart:io' as Io;
import 'package:flutter/services.dart' show rootBundle;

import 'package:path_provider/path_provider.dart';

class NewProfilePage extends StatefulWidget {
  const NewProfilePage(
      {Key? key,
      this.user,
      required this.isUpdate,
      this.phone,
      this.countryCode})
      : super(key: key);
  final LoginModel? user;
  final bool isUpdate;
  final String? phone;
  final String? countryCode;

  @override
  State<NewProfilePage> createState() => _NewProfilePageState();
}

class _NewProfilePageState extends State<NewProfilePage> {
  var registerNewUserResponse;
  var updateUserResponse;
  bool isLoading = false;
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

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  bool isEmail(String em) {
    String p =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';

    RegExp regExp = RegExp(p);

    return regExp.hasMatch(em);
  }

  final _profileForm = GlobalKey<FormState>();

  void updateExistingUser() {
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
      updateExistingUser();
    } else {
      _phoneNoController.text = widget.phone ?? '';
    }
    super.initState();
  }

//update user
  Future<dynamic> userEditProfile({
    File? image,
    required String token,
    required String name,
    required String gender,
    required String email,
  }) async {
    final body = <String, String>{};
    body['name'] = name;
    // body['pro_pic'] = propic;
    body['gender'] = gender;
    body['mailid'] = email;
    var headers = {'x-access-token': token};
    var request = http.MultipartRequest('POST', updateUser());
    request.fields.addAll(body);
    if (image != null) {
      request.files.add(http.MultipartFile.fromBytes(
        'pro_pic',
        File(image.path).readAsBytesSync(),
        filename: image.path.split("/").last,
      ));
    }

    request.headers.addAll(headers);
    http.StreamedResponse response = await request.send();
    try {
      if (response.statusCode == 200) {
        updateUserResponse = jsonDecode(await response.stream.bytesToString());
        return true;
      } else {
        debugPrint(response.toString());
        return false;
      }
    } catch (e) {
      debugPrint(response.reasonPhrase);
      return false;
    }
  }

//register new user
  Future<dynamic> registerNewUser({
    File? image,
    required String name,
    required String gender,
    required String email,
    required String deviceId,
    required String fcmToken,
    required String phoneNo,
  }) async {
    final body = <String, String>{};
    body['name'] = name;
    // body['pro_pic'] = propic;
    body['gender'] = gender;
    body['mailid'] = email;
    body['countrycode'] = widget.countryCode ?? '91';
    body['deviceId'] = deviceId;
    body['phone'] = phoneNo;
    body['FcmToken'] = fcmToken;

    var request = http.MultipartRequest('POST', registerUser());
    request.fields.addAll(body);
    if (image != null) {
      request.files.add(http.MultipartFile.fromBytes(
        'pro_pic',
        File(image.path).readAsBytesSync(),
        filename: image.path.split("/").last,
      ));
    }
    http.StreamedResponse response = await request.send();
    try {
      if (response.statusCode == 200) {
        registerNewUserResponse =
            jsonDecode(await response.stream.bytesToString());
        return true;
      } else {
        debugPrint(response.toString());
        return false;
      }
    } catch (e) {
      debugPrint(response.reasonPhrase);
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: Container(
        height: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(PageBackgroundImage),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          children: [
            AppBarInsideWidget(pagetitle: 'Profile Page'),
            Expanded(
              child: SingleChildScrollView(
                child: Container(
                  padding: EdgeInsets.only(left: 20, right: 20),
                  child: Column(
                    children: [
                      Image.asset(
                        "assets/images/envi-logo-small.png",
                        fit: BoxFit.fill,
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
                      (!widget.isUpdate)
                          ? Text(
                              letsSetUpyourProfileText,
                              style: AppTextStyle.robotoRegular16,
                            )
                          : const SizedBox(),
                      const SizedBox(height: 25),
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
                                              : Image.network(
                                                  encodeImgURLString(
                                                      widget.user!.propic),
                                                  errorBuilder: (context, error,
                                                      stackTrace) {
                                                    return Image.asset(
                                                      Images
                                                          .personPlaceHolderImage,
                                                      height: 100,
                                                    );
                                                  },
                                                  fit: BoxFit.fill,
                                                  height: 100,
                                                  width: 100,
                                                )
                                          : (_image != null)
                                              ? Image.file(
                                                  _image!,
                                                  width: 100.0,
                                                  height: 100.0,
                                                  fit: BoxFit.fitHeight,
                                                )
                                              : Container(
                                                  color: AppColor
                                                      .textfieldlightgrey,
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
                                            autovalidateMode: AutovalidateMode
                                                .onUserInteraction,
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
                                                hintStyle: AppTextStyle
                                                    .robotoRegular18Gray,
                                                border: InputBorder.none,
                                                fillColor: AppColor
                                                    .textfieldlightgrey),
                                            textAlign: TextAlign.left,
                                          ),
                                          const SizedBox(
                                            height: 10,
                                          ),
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
                                                color: AppColor.white,
                                                width: 0),
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
                                const SizedBox(
                                  height: 10,
                                ),
                                (widget.isUpdate)
                                    ? TextFormField(
                                        enabled:
                                            (widget.isUpdate) ? false : true,
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
                                            hintStyle: AppTextStyle
                                                .robotoRegular18Gray,
                                            border: InputBorder.none,
                                            contentPadding:
                                                EdgeInsets.all(10.0),
                                            isDense: true,
                                            fillColor:
                                                AppColor.textfieldlightgrey),
                                        style: AppTextStyle.robotoRegular18Gray,
                                      )
                                    : TextFormField(
                                        enabled:
                                            (widget.isUpdate) ? false : true,
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
                                            hintStyle: AppTextStyle
                                                .robotoRegular18Gray,
                                            border: InputBorder.none,
                                            contentPadding:
                                                EdgeInsets.all(10.0),
                                            isDense: true,
                                            fillColor:
                                                AppColor.textfieldlightgrey),
                                        style: AppTextStyle.robotoRegular18,
                                      ),
                                const SizedBox(
                                  height: 20,
                                ),
                                TextFormField(
                                  controller: _emailController,
                                  autovalidateMode:
                                      AutovalidateMode.onUserInteraction,
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
                                      hintStyle:
                                          AppTextStyle.robotoRegular18Gray,
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
                      (!isLoading)
                          ? MaterialButton(
                              onPressed: () async {
                                updateProfile();
                              },
                              height: 48,
                              minWidth: double.infinity,
                              color: AppColor.greyblack,
                              child: Text(
                                (widget.isUpdate)
                                    ? 'UPDATE'
                                    : createAccountText,
                                style: AppTextStyle.robotoBold20White,
                              ),
                            )
                          : const Center(child: CircularProgressIndicator())
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    ));
  }

  Future<void> updateProfile() async {
    if (widget.isUpdate) {
      setState(() {
        isLoading = true;
      });
      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();

      var id = sharedPreferences.getString(loginID);

      final response = await userEditProfile(
          image: _image,
          token: widget.user!.token,
          name: _firstNameController.text,
          gender: selectedGender!,
          email: _emailController.text);

      if (response) {
        setState(() {
          isLoading = false;
        });
        LoginModel usr = LoginModel(
            widget.user!.token,
            id ?? widget.user!.id,
            _firstNameController.text,
            updateUserResponse['pro_pic'] ?? widget.user!.propic,
            selectedGender!,
            widget.user!.phone,
            widget.user!.mailid);
        sharedPreferences.setString(loginEmail, _emailController.text);
        sharedPreferences.setString(loginToken, widget.user!.token);
        sharedPreferences.setString(loginID, widget.user!.id);
        sharedPreferences.setString(logingender, selectedGender!);
        sharedPreferences.setString(loginPhone, _phoneNoController.text);
        sharedPreferences.setString(loginName, _firstNameController.text);
        sharedPreferences.setString(
            loginpropic, updateUserResponse['pro_pic'] ?? widget.user!.propic);
        Profiledata.setusreid(widget.user!.id);

        Profiledata.settoken(widget.user!.token);
        Profiledata.setmailid(_emailController.text);
        Profiledata.setpropic(
            updateUserResponse['pro_pic'] ?? widget.user!.propic);
        Profiledata.setphone(_phoneNoController.text);
        Profiledata.setgender(selectedGender!);
        Profiledata.setname(_firstNameController.text);
        showToast(updatedSuccessText);

        Navigator.of(context).push(MaterialPageRoute(
            builder: (BuildContext context) => const HomePage(title: "title")));
      } else {
        setState(() {
          isLoading = false;
        });
        showToast(failedToUpdateText);
      }
    } else {
      if (!mounted) return;
      if (_profileForm.currentState!.validate()) {
        setState(() {
          isLoading = true;
        });
        SharedPreferences sharedPreferences =
            await SharedPreferences.getInstance();
        final response = await registerNewUser(
            image: _image,
            name: _firstNameController.text,
            gender: selectedGender!,
            email: _emailController.text,
            deviceId: sharedPreferences.getString(deviceIdShared)!,
            fcmToken: sharedPreferences.getString(fcmTokenShared)!,
            phoneNo: _phoneNoController.text);
        setState(() {
          isLoading = false;
        });
        if (response) {
          sharedPreferences.setString(loginEmail, _emailController.text);
          sharedPreferences.setString(
              loginToken, registerNewUserResponse['content']['token']);
          sharedPreferences.setString(
              loginID, registerNewUserResponse['content']['userid']);
          sharedPreferences.setString(logingender, selectedGender!);
          sharedPreferences.setString(loginPhone, _phoneNoController.text);
          sharedPreferences.setString(loginName, _firstNameController.text);
          sharedPreferences.setString(loginpropic,
              encodeImgURLString(registerNewUserResponse['content']['image']));
          Profiledata.setusreid(registerNewUserResponse['content']['userid']);
          Profiledata.settoken(registerNewUserResponse['content']['token']);
          Profiledata.setmailid(_emailController.text);
          Profiledata.setpropic(
              encodeImgURLString(registerNewUserResponse['content']['image']));
          Profiledata.setphone(_phoneNoController.text);
          Profiledata.setgender(selectedGender!);
          Profiledata.setname(_firstNameController.text);
          showToast('Registered Successfully');
          Future.delayed(const Duration(seconds: 2), () {
            if (!mounted) return;
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => MainEntryPoint()));
          });
        } else {
          showToast(failedRegister);
        }
      }
    }
  }
}
