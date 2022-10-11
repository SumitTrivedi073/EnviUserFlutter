import 'dart:io';

import 'package:envi/login/model/LoginModel.dart';
import 'package:http/http.dart' as http;

class UserApiService {
  late LoginModel user;

  Uri uri = Uri.parse('https://qausernew.azurewebsites.net/user/updateProfile');
  Future<bool> userEditProfile(
      {required File image,
      required String token,
      required String name,
      required String gender,
      required String email
     }) async {
    final body = <String, String>{};
    body['name'] = name;
    // body['pro_pic'] = propic;
    body['gender'] = gender;
    body['mailid'] = email;
    var headers = {'x-access-token': token};
    var request = http.MultipartRequest('POST', uri);
    request.fields.addAll(body);
    request.files.add(http.MultipartFile.fromBytes(
      'pro_pic',
      File(image.path).readAsBytesSync(),
      filename: image.path.split("/").last,
    ));
    request.headers.addAll(headers);
    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }
}