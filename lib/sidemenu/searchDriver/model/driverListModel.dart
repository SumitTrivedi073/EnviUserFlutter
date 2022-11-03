// To parse this JSON data, do
//
//     final driverListModel = driverListModelFromJson(jsonString);

import 'dart:convert';

// To parse this JSON data, do
//
//     final driverListModel = driverListModelFromJson(jsonString);

import 'dart:convert';

import '../../../utils/utility.dart';

DriverListModel driverListModelFromJson(String str) =>
    DriverListModel.fromJson(json.decode(str));

String driverListModelToJson(DriverListModel data) =>
    json.encode(data.toJson());

class DriverListModel {
  DriverListModel({
    required this.message,
    required this.content,
    required this.distance,
    required this.price,
    required this.vehiclePriceClasses,
  });

  String message;
  List<Content> content;
  Distance distance;
  Map<String, double> price;
  List<VehiclePriceClass> vehiclePriceClasses;

  factory DriverListModel.fromJson(Map<String, dynamic> json) =>
      DriverListModel(
        message: json["message"],
        content:
            List<Content>.from(json["content"].map((x) => Content.fromJson(x))),
        distance: Distance.fromJson(json["distance"]),
        price: Map.from(json["price"])
            .map((k, v) => MapEntry<String, double>(k, v.toDouble())),
        vehiclePriceClasses: List<VehiclePriceClass>.from(
            json["vehiclePriceClasses"]
                .map((x) => VehiclePriceClass.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "message": message,
        "content": List<dynamic>.from(content.map((x) => x.toJson())),
        "distance": distance.toJson(),
        "price": Map.from(price).map((k, v) => MapEntry<String, dynamic>(k, v)),
        "vehiclePriceClasses":
            List<dynamic>.from(vehiclePriceClasses.map((x) => x.toJson())),
      };
}

class Content {
  Content({
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
    required this.paymentInitiateTime,
    required this.ptmStatus,
    required this.distanceBwDriverAndPickUpLoc,
    required this.durationToPickUpLocation,
    required this.breakInitiateTime,
  });

  Location? location;
  ContentPriceClass? priceClass;
  double? ekm;
  List<dynamic> details;
  String? mmtReferenceNumber;
  String? id;
  String? driverId;
  int? v;
  DateTime? createdAt;
  String? driverName;
  String? driverPhoto;
  double? driverRating;
  String? driverTripMasterId;
  String? gender;
  bool? isTestDriver;
  double? soc;
  String? status;
  DateTime? updatedAt;
  String? vehicleColor;
  String? vehicleId;
  String? vehicleModel;
  String? vehicleNumber;
  String? vin;
  DateTime? locationUpdateTime;
  String? passengerTripMasterId;
  DateTime? paymentInitiateTime;
  String? ptmStatus;
  double? distanceBwDriverAndPickUpLoc;
  int? durationToPickUpLocation;
  DateTime? breakInitiateTime;

  factory Content.fromJson(Map<String, dynamic> json) => Content(
        location: Location.fromJson(json["location"]),
        priceClass: ContentPriceClass.fromJson(json["priceClass"]),
        ekm: json["ekm"].toDouble(),
        details: List<dynamic>.from(json["details"].map((x) => x)),
        mmtReferenceNumber: json["mmtReferenceNumber"],
        id: json["_id"],
        driverId: json["driverId"],
        v: json["__v"],
        createdAt: DateTime.parse(json["createdAt"]),
        driverName: json["driverName"],
        driverPhoto: json["driverPhoto"],
        driverRating: json["driverRating"].toDouble(),
        driverTripMasterId: json["driverTripMasterId"],
        gender: json["gender"],
        isTestDriver: json["isTestDriver"],
        soc: json["soc"].toDouble(),
        status: json["status"],
        updatedAt: DateTime.parse(json["updatedAt"]),
        vehicleColor: json["vehicleColor"],
        vehicleId: json["vehicleId"],
        vehicleModel: json["vehicleModel"],
        vehicleNumber: json["vehicleNumber"],
        vin: json["vin"],
        locationUpdateTime: DateTime.parse(json["locationUpdateTime"]),
        passengerTripMasterId: json["passengerTripMasterId"],
        paymentInitiateTime: json["paymentInitiateTime"] == null
            ? null
            : DateTime.parse(json["paymentInitiateTime"]),
        ptmStatus: json["ptmStatus"],
        distanceBwDriverAndPickUpLoc:
            json["distanceBWDriverAndPickUpLoc"].toDouble(),
        durationToPickUpLocation: json["durationToPickUpLocation"],
        breakInitiateTime: json["breakInitiateTime"] == null
            ? null
            : DateTime.parse(json["breakInitiateTime"]),
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
        "paymentInitiateTime": paymentInitiateTime == null
            ? null
            : paymentInitiateTime!.toIso8601String(),
        "ptmStatus": ptmStatus,
        "distanceBWDriverAndPickUpLoc": distanceBwDriverAndPickUpLoc,
        "durationToPickUpLocation": durationToPickUpLocation,
        "breakInitiateTime": breakInitiateTime == null
            ? null
            : breakInitiateTime!.toIso8601String(),
      };
}

class Location {
  Location({
    required this.type,
    required this.coordinates,
  });

  String type;
  List<double> coordinates;

  factory Location.fromJson(Map<String, dynamic> json) => Location(
        type: json["type"],
        coordinates:
            List<double>.from(json["coordinates"].map((x) => x.toDouble())),
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
  double? perKmFare;
  double? minFare;
  double? passengerCapacity;
  String? bootSpace;
  double? maxKmRange;

  factory ContentPriceClass.fromJson(Map<String, dynamic> json) =>
      ContentPriceClass(
        skuId: json["sku_id"]!=null?json["sku_id"]:"",
        type: json["type"]!=null?json["type"]:"",
        subcategory: json["subcategory"]!=null?json["subcategory"]:"",
        perKmFare: json["perKMFare"]!=null?json["perKMFare"].toDouble():0.0,
        minFare: json["minFare"]!=null?json["minFare"].toDouble():0.0,
        passengerCapacity: json["passengerCapacity"]!=null?json["passengerCapacity"].toDouble():0.0,
        bootSpace: json["bootSpace"]!=null?json["bootSpace"] : "MEDIUM",
        maxKmRange: json["maxKmRange"]!=null?json["maxKmRange"].toDouble():0.0,
      );

  Map<String, dynamic> toJson() => {
        "sku_id": skuId,
        "type": type,
        "subcategory": subcategory,
        "perKMFare": perKmFare,
        "minFare": minFare,
        "passengerCapacity": passengerCapacity ?? 0,
        "bootSpace": bootSpace ?? "MEDIUM",
        "maxKmRange": maxKmRange ?? 150,
      };
}

class Distance {
  Distance({
    required this.text,
    required this.value,
    required this.duration,
  });

  String? text;
  int? value;
  int? duration;

  factory Distance.fromJson(Map<String, dynamic> json) => Distance(
        text: json["text"],
        value: json["value"],
        duration: json["duration"],
      );

  Map<String, dynamic> toJson() => {
        "text": text,
        "value": value,
        "duration": duration,
      };
}

class VehiclePriceClass {
  VehiclePriceClass({
    required this.priceClass,
    required this.driverId,
    required this.driverName,
  });

  VehiclePriceClassPriceClass priceClass;
  String? driverId;
  String? driverName;

  factory VehiclePriceClass.fromJson(Map<String, dynamic> json) =>
      VehiclePriceClass(
        priceClass: VehiclePriceClassPriceClass.fromJson(json["priceClass"]),
        driverId: json["driverId"],
        driverName: json["driverName"],
      );

  Map<String, dynamic> toJson() => {
        "priceClass": priceClass.toJson(),
        "driverId": driverId,
        "driverName": driverName,
      };
}

class VehiclePriceClassPriceClass {
  VehiclePriceClassPriceClass({
    required this.skuId,
    required this.type,
    required this.subcategory,
    required this.perKmFare,
    required this.minFare,
    required this.distance,
    required this.discountPercent,
    required this.sellerDiscount,
    required this.baseFare,
    required this.tollCharges,
    required this.stateTax,
    required this.advancePaid,
    required this.amountToBeCollected,
    required this.totalFare,
  });

  String? skuId;
  String? type;
  String? subcategory;
  double? perKmFare;
  double? minFare;
  double? distance;
  double? discountPercent;
  double? sellerDiscount;
  double? baseFare;
  double? tollCharges;
  double? stateTax;
  double? advancePaid;
  double? amountToBeCollected;
  double? totalFare;

  factory VehiclePriceClassPriceClass.fromJson(Map<String, dynamic> json) =>
      VehiclePriceClassPriceClass(
        skuId: json["sku_id"]!=null?json["sku_id"]:"",
        type: json["type"]!=null?json["type"]:"",
        subcategory: json["subcategory"]!=null?json["subcategory"]:"",
        perKmFare: json["perKMFare"]!=null?json["perKMFare"].toDouble():0.0,
        minFare: json["minFare"]!=null?json["minFare"].toDouble():0.0,
        distance: json["distance"]!=null?json["distance"].toDouble():0.0,
        discountPercent: json["discountPercent"]!=null?json["discountPercent"].toDouble():0.0,
        sellerDiscount: json["seller_discount"]!=null?json["seller_discount"].toDouble():0.0,
        baseFare: json["base_fare"]!=null?json["base_fare"].toDouble():0.0,
        tollCharges: json["toll_charges"]!=null?json["toll_charges"].toDouble():0.0,
        stateTax:json["state_tax"]!=null? json["state_tax"].toDouble():0.0,
        advancePaid: json["advancePaid"]!=null?json["advancePaid"].toDouble():0.0,
        amountToBeCollected:json["amount_to_be_collected"]!=null? json["amount_to_be_collected"].toDouble():0.0,
        totalFare:json["total_fare"]!=null? json["total_fare"].toDouble():0.0,
      );

  Map<String, dynamic> toJson() => {
        "sku_id": skuId,
        "type": type,
        "subcategory": subcategory,
        "perKMFare": perKmFare,
        "minFare": minFare,
        "distance": distance,
        "discountPercent": discountPercent,
        "seller_discount": sellerDiscount,
        "base_fare": baseFare,
        "toll_charges": tollCharges,
        "state_tax": stateTax,
        "advancePaid": advancePaid,
        "amount_to_be_collected": amountToBeCollected,
        "total_fare": totalFare,
      };
}
