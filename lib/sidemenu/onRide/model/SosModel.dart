// To parse this JSON data, do
//
//     final sosModel = sosModelFromJson(jsonString);

import 'dart:convert';

SosModel sosModelFromJson(String str) => SosModel.fromJson(json.decode(str));

String sosModelToJson(SosModel data) => json.encode(data.toJson());

class SosModel {
  SosModel({
    required this.message,
  });

  String message;

  factory SosModel.fromJson(Map<String, dynamic> json) => SosModel(
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "message": message,
  };
}
