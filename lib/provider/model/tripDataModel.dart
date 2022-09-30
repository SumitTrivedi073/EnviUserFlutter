// To parse this JSON data, do
//
//     final tripDataModel = tripDataModelFromJson(jsonString);

import 'dart:convert';

TripDataModel tripDataModelFromJson(String str) =>
    TripDataModel.fromJson(json.decode(str));

String tripDataModelToJson(TripDataModel data) => json.encode(data.toJson());

class TripDataModel {
  TripDataModel({
    required this.driverInfo,
    required this.tollAmount,
    required this.totalFare,
    required this.driverLocation,
    required this.paymentMode,
    required this.passengerInfo,
    required this.tripInfo,
    this.priceClass,
    required this.tripStatus,
  });

  DriverInfo? driverInfo;
  int? tollAmount;
  int? totalFare;
  DriverLocation? driverLocation;
  String? paymentMode;
  ErInfo? passengerInfo;
  TripInfo? tripInfo;
  PriceClass? priceClass;
  String? tripStatus;

  factory TripDataModel.fromJson(Map<String, dynamic> json) => TripDataModel(
        driverInfo: DriverInfo.fromJson(json["driverInfo"]) != null
            ? DriverInfo.fromJson(json['driverInfo'])
            : null,
        tollAmount: json["tollAmount"] ?? 0,
        totalFare: json["totalFare"] ?? 0,
        driverLocation: DriverLocation.fromJson(json["driverLocation"]) != null
            ? DriverLocation.fromJson(json['driverLocation'])
            : null,
        paymentMode: json["paymentMode"] ?? '',
        passengerInfo: ErInfo.fromJson(json["passengerInfo"]) != null
            ? ErInfo.fromJson(json['passengerInfo'])
            : null,
        tripInfo: TripInfo.fromJson(json["tripInfo"]) != null
            ? TripInfo.fromJson(json['tripInfo'])
            : null,
        priceClass: PriceClass.fromJson(json["priceClass"]) != null
            ? PriceClass.fromJson(json['priceClass'])
            : null,
        tripStatus: json["tripStatus"] ?? '',
      );

  Map<String, dynamic> toJson() => {
        "driverInfo": driverInfo!.toJson(),
        "tollAmount": tollAmount,
        "totalFare": totalFare,
        "driverLocation": driverLocation!.toJson(),
        "paymentMode": paymentMode,
        "passengerInfo": passengerInfo!.toJson(),
        "tripInfo": tripInfo!.toJson(),
        "priceClass": priceClass!.toJson(),
        "tripStatus": tripStatus,
      };
}


class DriverInfo {
  DriverInfo({
    required this.phone,
    required this.countryCode,
    required this.name,
    required this.driverImgUrl,
    required this.driverId,
    required this.vehicleNumber,
  });

  String? phone;
  String? countryCode;
  String? name;
  String? driverImgUrl;
  String? driverId;
  String? vehicleNumber;

  factory DriverInfo.fromJson(Map<String, dynamic> json) => DriverInfo(
    phone: json["phone"] ?? '',
    countryCode: json["countryCode"] ?? '',
    name: json["name"] ?? '',
    driverImgUrl: json["driverImgUrl"] ?? '',
    driverId: json["driverId"] ?? '',
    vehicleNumber: json["vehicleNumber"] ?? '',
  );

  Map<String, dynamic> toJson() => {
    "phone": phone,
    "countryCode": countryCode,
    "name": name,
    "driverImgUrl": driverImgUrl,
    "driverId": driverId,
    "vehicleNumber": vehicleNumber,

  };
}
class ErInfo {
  ErInfo({
    required this.phone,
    required this.countryCode,
    required this.name,
  });

  String? phone;
  String? countryCode;
  String? name;

  factory ErInfo.fromJson(Map<String, dynamic> json) => ErInfo(
        phone: json["phone"] ?? '',
        countryCode: json["countryCode"] ?? '',
        name: json["name"] ?? '',
      );

  Map<String, dynamic> toJson() => {
        "phone": phone,
        "countryCode": countryCode,
        "name": name,
      };
}

class DriverLocation {
  DriverLocation({
    required this.latitude,
    required this.longitude,
  });

  double? latitude;
  double? longitude;

  factory DriverLocation.fromJson(Map<String, dynamic> json) => DriverLocation(
        latitude: json["latitude"].toDouble() ?? 0.0,
        longitude: json["longitude"].toDouble() ?? 0.0,
      );

  Map<String, dynamic> toJson() => {
        "latitude": latitude,
        "longitude": longitude,
      };
}
class PriceClass {
  PriceClass({
    required this.passengerCapacity,
    required this.minFare,
    required this.discountPercent,
    required this.distance,
    required this.tollCharges,
    required this.totalFare,
    required this.sellerDiscount,
    required this.advancePaid,
    required this.baseFare,
    required this.perKmFare,
    required this.skuId,
    required this.type,
    required this.stateTax,
    required this.maxKmRange,
    required this.bootSpace,
    required this.gstp,
    required this.amountToBeCollected,
    required this.subcategory,
  });

  int passengerCapacity;
  int minFare;
  int discountPercent;
  int distance;
  int tollCharges;
  double totalFare;
  double sellerDiscount;
  int advancePaid;
  double baseFare;
  double perKmFare;
  String skuId;
  String type;
  double stateTax;
  int maxKmRange;
  String bootSpace;
  int gstp;
  double amountToBeCollected;
  String subcategory;

  factory PriceClass.fromJson(Map<String, dynamic> json) => PriceClass(
    passengerCapacity: json["passengerCapacity"],
    minFare: json["minFare"],
    discountPercent: json["discountPercent"],
    distance: json["distance"],
    tollCharges: json["toll_charges"],
    totalFare: json["total_fare"].toDouble(),
    sellerDiscount: json["seller_discount"].toDouble(),
    advancePaid: json["advancePaid"],
    baseFare: json["base_fare"].toDouble(),
    perKmFare: json["perKMFare"].toDouble(),
    skuId: json["sku_id"],
    type: json["type"],
    stateTax: json["state_tax"].toDouble(),
    maxKmRange: json["maxKmRange"],
    bootSpace: json["bootSpace"],
    gstp: json["gstp"],
    amountToBeCollected: json["amount_to_be_collected"].toDouble(),
    subcategory: json["subcategory"],
  );

  Map<String, dynamic> toJson() => {
    "passengerCapacity": passengerCapacity,
    "minFare": minFare,
    "discountPercent": discountPercent,
    "distance": distance,
    "toll_charges": tollCharges,
    "total_fare": totalFare,
    "seller_discount": sellerDiscount,
    "advancePaid": advancePaid,
    "base_fare": baseFare,
    "perKMFare": perKmFare,
    "sku_id": skuId,
    "type": type,
    "state_tax": stateTax,
    "maxKmRange": maxKmRange,
    "bootSpace": bootSpace,
    "gstp": gstp,
    "amount_to_be_collected": amountToBeCollected,
    "subcategory": subcategory,
  };
}

class TripInfo {
  TripInfo({
    required this.passengerTripMasterId,
    required this.dropLocation,
    required this.pickupLocation,
  });

  String? passengerTripMasterId;
  DropLocation? dropLocation;
  PickupLocation? pickupLocation;

  factory TripInfo.fromJson(Map<String, dynamic> json) => TripInfo(
        passengerTripMasterId: json["passengerTripMasterId"] ?? '',
        dropLocation: DropLocation.fromJson(json["dropLocation"]) != null
            ? DropLocation.fromJson(json['dropLocation'])
            : null,
        pickupLocation: PickupLocation.fromJson(json["pickupLocation"]) != null
            ? PickupLocation.fromJson(json['pickupLocation'])
            : null,
      );

  Map<String, dynamic> toJson() => {
        "passengerTripMasterId": passengerTripMasterId,
        "dropLocation": dropLocation!.toJson(),
        "pickupLocation": pickupLocation!.toJson(),
      };
}

class DropLocation {
  DropLocation({
    required this.latitude,
    required this.dropAddress,
    required this.longitude,
  });

  double? latitude;
  String? dropAddress;
  double? longitude;

  factory DropLocation.fromJson(Map<String, dynamic> json) => DropLocation(
        latitude: json["latitude"].toDouble() ?? 0.0,
        dropAddress: json["dropAddress"] ?? '',
        longitude: json["longitude"].toDouble() ?? 0.0,
      );

  Map<String, dynamic> toJson() => {
        "latitude": latitude,
        "dropAddress": dropAddress,
        "longitude": longitude,
      };
}

class PickupLocation {
  PickupLocation({
    required this.pickupAddress,
    required this.latitude,
    required this.longitude,
  });

  String? pickupAddress;
  double? latitude;
  double? longitude;

  factory PickupLocation.fromJson(Map<String, dynamic> json) => PickupLocation(
        pickupAddress: json["pickupAddress"] ?? '',
        latitude: json["latitude"].toDouble() ?? 0.0,
        longitude: json["longitude"].toDouble() ?? 0.0,
      );

  Map<String, dynamic> toJson() => {
        "pickupAddress": pickupAddress,
        "latitude": latitude,
        "longitude": longitude,
      };
}

class UpdatedAt {
  UpdatedAt({
    required this.seconds,
    required this.nanoseconds,
  });

  int? seconds;
  int? nanoseconds;

  factory UpdatedAt.fromJson(Map<String, dynamic> json) => UpdatedAt(
        seconds: json["seconds"],
        nanoseconds: json["nanoseconds"],
      );

  Map<String, dynamic> toJson() => {
        "seconds": seconds,
        "nanoseconds": nanoseconds,
      };
}
