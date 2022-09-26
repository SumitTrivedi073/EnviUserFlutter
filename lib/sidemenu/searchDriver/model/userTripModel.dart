// To parse this JSON data, do
//
//     final userTripModel = userTripModelFromJson(jsonString);

import 'dart:convert';

UserTripModel userTripModelFromJson(String str) => UserTripModel.fromJson(json.decode(str));

String userTripModelToJson(UserTripModel data) => json.encode(data.toJson());

class UserTripModel {
  UserTripModel({
    required this.message,
    required this.content,
  });

  String message;
  Content content;

  factory UserTripModel.fromJson(Map<String, dynamic> json) => UserTripModel(
    message: json["message"],
    content: Content.fromJson(json["content"]),
  );

  Map<String, dynamic> toJson() => {
    "message": message,
    "content": content.toJson(),
  };
}

class Content {
  Content({
    required this.passengerTripMasterId,
    required this.otp,
    required this.driver,
  });

  String passengerTripMasterId;
  String otp;
  List<Driver> driver;

  factory Content.fromJson(Map<String, dynamic> json) => Content(
    passengerTripMasterId: json["passengerTripMasterId"],
    otp: json["otp"],
    driver: List<Driver>.from(json["driver"].map((x) => Driver.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "passengerTripMasterId": passengerTripMasterId,
    "otp": otp,
    "driver": List<dynamic>.from(driver.map((x) => x.toJson())),
  };
}

class Driver {
  Driver({
    required this.usertype,
    required this.status,
    required this.ratingCount,
    required this.isArcheived,
    required this.isTestUser,
    required this.isFirstTripCompleted,
    required this.role,
    required this.id,
    required this.driverId,
    required this.name,
    required this.countrycode,
    required this.phone,
    required this.mailid,
    required this.gender,
    required this.propic,
    required this.createdon,
    required this.fcmToken,
    required this.deviceId,
    required this.v,
    required this.rating,
  });

  int usertype;
  int status;
  int ratingCount;
  bool isArcheived;
  bool isTestUser;
  int isFirstTripCompleted;
  String role;
  String id;
  String driverId;
  String name;
  String countrycode;
  String phone;
  String mailid;
  String gender;
  String propic;
  DateTime createdon;
  String fcmToken;
  String deviceId;
  int v;
  double rating;

  factory Driver.fromJson(Map<String, dynamic> json) => Driver(
    usertype: json["usertype"],
    status: json["status"],
    ratingCount: json["ratingCount"],
    isArcheived: json["isArcheived"],
    isTestUser: json["isTestUser"],
    isFirstTripCompleted: json["isFirstTripCompleted"],
    role: json["role"],
    id: json["_id"],
    driverId: json["id"],
    name: json["name"],
    countrycode: json["countrycode"],
    phone: json["phone"],
    mailid: json["mailid"],
    gender: json["gender"],
    propic: json["propic"],
    createdon: DateTime.parse(json["createdon"]),
    fcmToken: json["FcmToken"],
    deviceId: json["deviceId"],
    v: json["__v"],
    rating: json["rating"].toDouble(),
  );

  Map<String, dynamic> toJson() => {
    "usertype": usertype,
    "status": status,
    "ratingCount": ratingCount,
    "isArcheived": isArcheived,
    "isTestUser": isTestUser,
    "isFirstTripCompleted": isFirstTripCompleted,
    "role": role,
    "_id": id,
    "id": driverId,
    "name": name,
    "countrycode": countrycode,
    "phone": phone,
    "mailid": mailid,
    "gender": gender,
    "propic": propic,
    "createdon": createdon.toIso8601String(),
    "FcmToken": fcmToken,
    "deviceId": deviceId,
    "__v": v,
    "rating": rating,
  };
}
