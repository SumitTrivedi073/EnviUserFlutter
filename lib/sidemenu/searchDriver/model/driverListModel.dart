// To parse this JSON data, do
//
//     final driverListModel = driverListModelFromJson(jsonString);

import 'dart:convert';

DriverListModel driverListModelFromJson(String str) => DriverListModel.fromJson(json.decode(str));

String driverListModelToJson(DriverListModel data) => json.encode(data.toJson());

class DriverListModel {
  DriverListModel({
   required this.location,
   required this.priceClass,
   required this.ekm,
   required this.details,
   required this.mmtReferenceNumber,
   required this.id,
   required this.driverId,
   required this.v,
   required this.createdAt,
   required this.driverName,
   required this.driverPhoto,
   required this.driverRating,
   required this.driverTripMasterId,
   required this.gender,
   required this.isTestDriver,
   required this.soc,
   required this.status,
   required this.updatedAt,
   required this.vehicleColor,
   required this.vehicleId,
   required this.vehicleModel,
   required this.vehicleNumber,
   required this.vin,
   required this.locationUpdateTime,
   required this.passengerTripMasterId,
   required this.ptmStatus,
   required this.distanceBwDriverAndPickUpLoc,
   required this.durationToPickUpLocation,
  });

  Location? location;
  ContentPriceClass? priceClass;
  int? ekm;
  List<dynamic> details;
  String? mmtReferenceNumber;
  String? id;
  String? driverId;
  int? v;
  DateTime? createdAt;
  String? driverName;
  String? driverPhoto;
  int? driverRating;
  String? driverTripMasterId;
  String? gender;
  bool? isTestDriver;
  int? soc;
  String? status;
  DateTime? updatedAt;
  String? vehicleColor;
  String? vehicleId;
  String? vehicleModel;
  String? vehicleNumber;
  String? vin;
  DateTime? locationUpdateTime;
  String? passengerTripMasterId;

  String? ptmStatus;
  double? distanceBwDriverAndPickUpLoc;
  int? durationToPickUpLocation;

  factory DriverListModel.fromJson(Map<String, dynamic> json) => DriverListModel(
    location: Location.fromJson(json["location"]),
    priceClass: ContentPriceClass.fromJson(json["priceClass"]),
    ekm: json["ekm"],
    details: List<dynamic>.from(json["details"].map((x) => x)),
    mmtReferenceNumber: json["mmtReferenceNumber"],
    id: json["_id"],
    driverId: json["driverId"],
    v: json["__v"],
    createdAt: DateTime.parse(json["createdAt"]),
    driverName: json["driverName"],
    driverPhoto: json["driverPhoto"],
    driverRating: json["driverRating"],
    driverTripMasterId: json["driverTripMasterId"],
    gender: json["gender"],
    isTestDriver: json["isTestDriver"],
    soc: json["soc"],
    status: json["status"],
    updatedAt: DateTime.parse(json["updatedAt"]),
    vehicleColor: json["vehicleColor"],
    vehicleId: json["vehicleId"],
    vehicleModel: json["vehicleModel"],
    vehicleNumber: json["vehicleNumber"],
    vin: json["vin"],
    locationUpdateTime: DateTime.parse(json["locationUpdateTime"]),
    passengerTripMasterId: json["passengerTripMasterId"],
    ptmStatus: json["ptmStatus"],
    distanceBwDriverAndPickUpLoc: json["distanceBWDriverAndPickUpLoc"].toDouble(),
    durationToPickUpLocation: json["durationToPickUpLocation"] ?? 1,
  );

  Map<String, dynamic> toJson() => {
    "location": location!.toJson(),
    "priceClass": priceClass!.toJson(),
    "ekm": ekm,
    "details": List<dynamic>.from(details.map((x) => x)),
    "mmtReferenceNumber": mmtReferenceNumber,
    "_id": id,
    "driverId": driverId,
    "__v": v,
    "createdAt": createdAt!.toIso8601String(),
    "driverName": driverName,
    "driverPhoto": driverPhoto,
    "driverRating": driverRating,
    "driverTripMasterId": driverTripMasterId,
    "gender": gender,
    "isTestDriver": isTestDriver,
    "soc": soc,
    "status": status,
    "updatedAt": updatedAt!.toIso8601String(),
    "vehicleColor": vehicleColor,
    "vehicleId": vehicleId,
    "vehicleModel": vehicleModel,
    "vehicleNumber": vehicleNumber,
    "vin": vin,
    "locationUpdateTime": locationUpdateTime!.toIso8601String(),
    "passengerTripMasterId": passengerTripMasterId,
    "ptmStatus": ptmStatus,
    "distanceBWDriverAndPickUpLoc": distanceBwDriverAndPickUpLoc,
    "durationToPickUpLocation": durationToPickUpLocation,
  };
}

class Location {
  Location({
   required this.type,
   required this.coordinates,
  });

  String? type;
  List<double> coordinates;

  factory Location.fromJson(Map<String, dynamic> json) => Location(
    type: json["type"],
    coordinates: List<double>.from(json["coordinates"].map((x) => x.toDouble())),
  );

  Map<String, dynamic> toJson() => {
    "type": type,
    "coordinates": List<dynamic>.from(coordinates.map((x) => x)),
  };
}

class ContentPriceClass {
  ContentPriceClass({
   required this.skuId,
   required this.type,
   required this.subcategory,
   required this.perKmFare,
   required this.minFare,
   required this.passengerCapacity,
   required this.bootSpace,
   required this.maxKmRange,
  });

  String? skuId;
  String? type;
  String? subcategory;
  int? perKmFare;
  int? minFare;
  int? passengerCapacity;
  String? bootSpace;
  int? maxKmRange;

  factory ContentPriceClass.fromJson(Map<String, dynamic> json) => ContentPriceClass(
    skuId: json["sku_id"],
    type: json["type"],
    subcategory: json["subcategory"],
    perKmFare: json["perKMFare"],
    minFare: json["minFare"],
    passengerCapacity: json["passengerCapacity"] ?? 0,
    bootSpace: json["bootSpace"] ?? "MEDIUM",
    maxKmRange: json["maxKmRange"] ?? 150,
  );

  Map<String, dynamic> toJson() => {
    "sku_id": skuId,
    "type": type,
    "subcategory": subcategory,
    "perKMFare": perKmFare,
    "minFare": minFare,
    "passengerCapacity": passengerCapacity,
    "bootSpace": bootSpace,
    "maxKmRange": maxKmRange,
  };
}


