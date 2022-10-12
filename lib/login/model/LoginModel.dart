import 'package:envi/web_service/Constant.dart';

import '../../utils/utility.dart';

class LoginModel {
  late String token;
  late String id, name, propic, gender, phone, mailid;

  LoginModel(this.token, this.id, this.name, this.propic, this.gender,
      this.phone, this.mailid);

  LoginModel.fromJson(Map<String, dynamic> json) {
    token = json['token'];
    id = json['userid'];
    name = json['name'];
    propic = encodeImgURLString(json["propic"]);
    gender = json["gender"];
    phone = json["phone"];
    mailid = json["mailid"];
  }
  Map<String, dynamic> toJson() => {
        "token": token,
        "userid": id,
        "name": name,
        "propic": propic,
        "gender": gender,
        "phone": phone,
        "mailid": mailid,
      };
}
