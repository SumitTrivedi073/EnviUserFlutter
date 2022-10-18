// To parse this JSON data, do
//
//     final scheduleTripModel = scheduleTripModelFromJson(jsonString);

import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

ScheduleTrip scheduleTripModelFromJson(String str) => ScheduleTrip.fromJson(json.decode(str));

String scheduleTripModelToJson(ScheduleTrip data) => json.encode(data.toJson());

class ScheduleTrip {
  ScheduleTrip({
    required this.driverName,
    required this.driverPhone,
    required this.fromAddress,
    required this.initialDistance,
    required this.initialPrice,
    required this.passengerName,
    required this.passengerPhone,
    required this.scheduledAt,
    required this.status,
    required this.toAddress,
  });

  String driverName;
  String driverPhone;
  String fromAddress;
  double initialDistance;
  double initialPrice;
  String passengerName;
  String passengerPhone;
  String scheduledAt;
  String status;
  String toAddress;

  factory ScheduleTrip.fromJson(Map<String, dynamic> json) => ScheduleTrip(
    driverName: json["driverName"],
    driverPhone: json["driverPhone"],
    fromAddress: json["fromAddress"],
    initialDistance: json["initialDistance"].toDouble(),
    initialPrice: json["initialPrice"].toDouble(),
    passengerName: json["passengerName"],
    passengerPhone: json["passengerPhone"],
    scheduledAt: json["scheduledAt"],
    status: json["status"],
    toAddress: json["toAddress"],
  );

  Map<String, dynamic> toJson() => {
    "driverName": driverName,
    "driverPhone": driverPhone,
    "fromAddress": fromAddress,
    "initialDistance": initialDistance,
    "initialPrice": initialPrice,
    "passengerName": passengerName,
    "passengerPhone": passengerPhone,
    "scheduledAt": scheduledAt,
    "status": status,
    "toAddress": toAddress,
  };
}
