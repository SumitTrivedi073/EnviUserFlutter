import '../utils/utility.dart';

class Profiledata {
  Profiledata._privateConstructor();

  static final Profiledata _instance = Profiledata._privateConstructor();

  factory Profiledata() {
    return _instance;
  }
  static String token = "";
  static String usreid = "",
      name = "",
      propic = "",
      gender = "",
      phone = "",
      mailid = "";

  static void setusreid(String val) {
    usreid = val;
  }

  String getusreid() {
    return usreid;
  }

  static setname(String val) {
    name = val;
  }

  String getname() {
    return name;
  }

  static setpropic(String val) {
    propic = encodeImgURLString(val);
  }

  String getpropic() {
    return propic;
  }

  static settoken(String val) {
    token = val;
  }

  String gettoken() {
    return token;
  }

  static setgender(String val) {
    gender = val;
  }

  String getgender() {
    return gender;
  }

  static setphone(String val) {
    phone = val;
  }

  String getphone() {
    return phone;
  }

  static setmailid(String val) {
    mailid = val;
  }

  String getmailid() {
    return mailid;
  }
}
