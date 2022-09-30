// To parse  required this.JSON data, do
//
//     final tripDataModel = tripDataModelFromJson(jsonString);

import 'dart:convert';

TripDataModel tripDataModelFromJson(String str) =>
    TripDataModel.fromJson(json.decode(str));

String tripDataModelToJson(TripDataModel data) => json.encode(data.toJson());

class TripDataModel {
  TripDataModel({
    required this.driverInfo,
    required this.driverLocation,
    required this.passengerInfo,
    required this.tripInfo,
  });

  DriverInfo driverInfo;
  DriverLocation driverLocation;
  PassengerInfo passengerInfo;
  TripInfo tripInfo;

  factory TripDataModel.fromJson(Map<String, dynamic> json) => TripDataModel(
        driverInfo: DriverInfo.fromJson(json["driverInfo"]),
        driverLocation: DriverLocation.fromJson(json["driverLocation"]),
        passengerInfo: PassengerInfo.fromJson(json["passengerInfo"]),
        tripInfo: TripInfo.fromJson(json["tripInfo"]),
      );

  Map<String, dynamic> toJson() => {
        "driverInfo": driverInfo.toJson(),
        "driverLocation": driverLocation.toJson(),
        "passengerInfo": passengerInfo.toJson(),
        "tripInfo": tripInfo.toJson(),
      };
}

class DriverInfo {
  DriverInfo({
    required this.driverImgUrl,
    required this.phone,
    required this.countryCode,
    required this.name,
    required this.vehicleNumber,
    required this.driverId,
  });

  String driverImgUrl;
  String phone;
  String countryCode;
  String name;
  String vehicleNumber;
  String driverId;

  factory DriverInfo.fromJson(Map<String, dynamic> json) => DriverInfo(
        driverImgUrl: json["driverImgUrl"]??'',
        phone: json["phone"]??'',
        countryCode: json["countryCode"]??'',
        name: json["name"]??'',
        vehicleNumber: json["vehicleNumber"]??'',
        driverId: json["driverId"]??'',
      );

  Map<String, dynamic> toJson() => {
        "driverImgUrl": driverImgUrl,
        "phone": phone,
        "countryCode": countryCode,
        "name": name,
        "vehicleNumber": vehicleNumber,
        "driverId": driverId,
      };
}

class DriverLocation {
  DriverLocation({
    required this.latitude,
    required this.longitude,
  });

  double latitude;
  double longitude;

  factory DriverLocation.fromJson(Map<String, dynamic> json) => DriverLocation(
        latitude: json["latitude"].toDouble(),
        longitude: json["longitude"].toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "latitude": latitude,
        "longitude": longitude,
      };
}

class PassengerInfo {
  PassengerInfo({
    required this.phone,
    required this.countryCode,
    required this.name,
  });

  String phone;
  String countryCode;
  String name;

  factory PassengerInfo.fromJson(Map<String, dynamic> json) => PassengerInfo(
        phone: json["phone"],
        countryCode: json["countryCode"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "phone": phone,
        "countryCode": countryCode,
        "name": name,
      };
}

class TripInfo {
  TripInfo({
    required this.priceClass,
    required this.specialRemarks,
    required this.paymentMode,
    required this.passengerTripMasterId,
    required this.tripStatus,
    required this.scheduledTrip,
    required this.otp,
    required this.dropLocation,
    required this.pickupLocation,
  });

  PriceClass priceClass;
  String specialRemarks;
  String paymentMode;
  String passengerTripMasterId;
  String tripStatus;
  bool scheduledTrip;
  String otp;
  DropLocation dropLocation;
  PickupLocation pickupLocation;

  factory TripInfo.fromJson(Map<String, dynamic> json) => TripInfo(
        priceClass: PriceClass.fromJson(json["priceClass"]),
        specialRemarks: json["specialRemarks"],
        paymentMode: json["paymentMode"],
        passengerTripMasterId: json["passengerTripMasterId"],
        tripStatus: json["tripStatus"],
        scheduledTrip: json["scheduledTrip"],
        otp: json["otp"],
        dropLocation: DropLocation.fromJson(json["dropLocation"]),
        pickupLocation: PickupLocation.fromJson(json["pickupLocation"]),
      );

  Map<String, dynamic> toJson() => {
        "priceClass": priceClass.toJson(),
        "specialRemarks": specialRemarks,
        "paymentMode": paymentMode,
        "passengerTripMasterId": passengerTripMasterId,
        "tripStatus": tripStatus,
        "scheduledTrip": scheduledTrip,
        "otp": otp,
        "dropLocation": dropLocation.toJson(),
        "pickupLocation": pickupLocation.toJson(),
      };
}

class DropLocation {
  DropLocation({
    required this.latitude,
    required this.longitude,
    required this.dropAddress,
  });

  double latitude;
  double longitude;
  String dropAddress;

  factory DropLocation.fromJson(Map<String, dynamic> json) => DropLocation(
        latitude: json["latitude"].toDouble(),
        longitude: json["longitude"].toDouble(),
        dropAddress: json["dropAddress"],
      );

  Map<String, dynamic> toJson() => {
        "latitude": latitude,
        "longitude": longitude,
        "dropAddress": dropAddress,
      };
}

class PickupLocation {
  PickupLocation({
    required this.latitude,
    required this.longitude,
    required this.pickupAddress,
  });

  double latitude;
  double longitude;
  String pickupAddress;

  factory PickupLocation.fromJson(Map<String, dynamic> json) => PickupLocation(
        latitude: json["latitude"].toDouble(),
        longitude: json["longitude"].toDouble(),
        pickupAddress: json["pickupAddress"],
      );

  Map<String, dynamic> toJson() => {
        "latitude": latitude,
        "longitude": longitude,
        "dropAddress": pickupAddress,
      };
}

class PriceClass {
  PriceClass({
    required this.passengerCapacity,
    required this.discountPercent,
    required this.minFare,
    required this.distance,
    required this.tollCharges,
    required this.sellerDiscount,
    required this.totalFare,
    required this.advancePaid,
    required this.baseFare,
    required this.skuId,
    required this.perKmFare,
    required this.type,
    required this.stateTax,
    required this.maxKmRange,
    required this.bootSpace,
    required this.gstp,
    required this.subcategory,
    required this.amountToBeCollected,
  });

  int passengerCapacity;
  int discountPercent;
  int minFare;
  int distance;
  int tollCharges;
  double sellerDiscount;
  double totalFare;
  int advancePaid;
  int baseFare;
  String skuId;
  double perKmFare;
  String type;
  double stateTax;
  int maxKmRange;
  String bootSpace;
  int gstp;
  String subcategory;
  double amountToBeCollected;

  factory PriceClass.fromJson(Map<String, dynamic> json) => PriceClass(
        passengerCapacity: json["passengerCapacity"],
        discountPercent: json["discountPercent"],
        minFare: json["minFare"],
        distance: json["distance"],
        tollCharges: json["toll_charges"],
        sellerDiscount: json["seller_discount"].toDouble(),
        totalFare: json["total_fare"].toDouble(),
        advancePaid: json["advancePaid"],
        baseFare: json["base_fare"],
        skuId: json["sku_id"],
        perKmFare: json["perKMFare"].toDouble(),
        type: json["type"],
        stateTax: json["state_tax"].toDouble(),
        maxKmRange: json["maxKmRange"],
        bootSpace: json["bootSpace"],
        gstp: json["gstp"],
        subcategory: json["subcategory"],
        amountToBeCollected: json["amount_to_be_collected"].toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "passengerCapacity": passengerCapacity,
        "discountPercent": discountPercent,
        "minFare": minFare,
        "distance": distance,
        "toll_charges": tollCharges,
        "seller_discount": sellerDiscount,
        "total_fare": totalFare,
        "advancePaid": advancePaid,
        "base_fare": baseFare,
        "sku_id": skuId,
        "perKMFare": perKmFare,
        "type": type,
        "state_tax": stateTax,
        "maxKmRange": maxKmRange,
        "bootSpace": bootSpace,
        "gstp": gstp,
        "subcategory": subcategory,
        "amount_to_be_collected": amountToBeCollected,
      };
}
