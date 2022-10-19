import 'dart:convert';
import 'dart:io';

import 'package:envi/login/model/LoginModel.dart';
import 'package:http/http.dart' as http;

class UserApiService {
  late LoginModel user;

  Uri uri = Uri.parse('https://qausernew.azurewebsites.net/user/updateProfile');
  Future<dynamic> userEditProfile({
    required File image,
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
    var request = http.MultipartRequest('POST', uri);
    request.fields.addAll(body);
    request.files.add(http.MultipartFile.fromBytes(
      'pro_pic',
      File(image.path).readAsBytesSync(),
      filename: image.path.split("/").last,
    ));
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
}
