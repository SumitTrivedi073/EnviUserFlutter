import 'package:envi/login/model/LoginModel.dart';
import 'package:envi/web_service/HTTP.dart' as HTTP;

class UserApiService {
  late LoginModel user;

  Uri uri = Uri.parse('https://qausernew.azurewebsites.net/user/updateProfile');
  Future<bool> userEditProfile({required String token, required String name,required String gender,required String propic}) async {
    final body = <String, dynamic>{};
    body['name'] = name;
    body['pro_pic'] = propic;
    body['gender'] = gender;
    try {
      dynamic res = await HTTP.post(uri, body, {'x-access-token': token});
      if (res.statuscode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print(e);
      return false;
    }
   // return true; 
  }
}
