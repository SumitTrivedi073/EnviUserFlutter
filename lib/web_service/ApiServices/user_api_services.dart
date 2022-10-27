import 'dart:convert';
import 'dart:io';

import 'package:envi/login/model/LoginModel.dart';
import 'package:envi/web_service/APIDirectory.dart';
import 'package:http/http.dart' as http;
import 'package:envi/web_service/HTTP.dart' as HTTP;

class UserApiService {
  late LoginModel user;

  // Uri uri = Uri.parse('https://qausernew.azurewebsites.net/user/updateProfile');

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
        var res = jsonDecode(await response.stream.bytesToString());
        print(res['pro_pic']);
        return res;
      }
    } catch (e) {
      print(response.reasonPhrase);
      return;
    }
  }

  Future<dynamic> registerNewUser({
    required File image,
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
    body['countrycode'] = '91';
    body['deviceId'] = deviceId;
    body['phone'] = phoneNo;
    body['FcmToken'] = fcmToken;

    var request = http.MultipartRequest('POST', registerUser());
    request.fields.addAll(body);
    
    request.files.add(http.MultipartFile.fromBytes(
      'pro_pic',
      File(image.path).readAsBytesSync(),
      filename: image.path.split("/").last,
    ));
    http.StreamedResponse response = await request.send();
    try {
      if (response.statusCode == 200) {
        var res = jsonDecode(await response.stream.bytesToString());
        print(res);
        return res;
      }
    } catch (e) {
      print(response.reasonPhrase);
      return e;
    }
  }
}
