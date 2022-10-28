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

  DriverInfo? driverInfo;
  DriverLocation? driverLocation;
  PassengerInfo? passengerInfo;
  TripInfo? tripInfo;

  factory TripDataModel.fromJson(Map<String, dynamic> json) => TripDataModel(
        driverInfo: json["driverInfo"]!=null ? DriverInfo.fromJson(json["driverInfo"]):null,
        driverLocation: json["driverLocation"]!=null ? DriverLocation.fromJson(json["driverLocation"]):null,
        passengerInfo: json["passengerInfo"]!=null ? PassengerInfo.fromJson(json["passengerInfo"]):null,
        tripInfo: json["tripInfo"]!=null ? TripInfo.fromJson(json["tripInfo"]):null,
      );

  Map<String, dynamic> toJson() => {
        "driverInfo": driverInfo!.toJson(),
        "driverLocation": driverLocation!.toJson(),
        "passengerInfo": passengerInfo!.toJson(),
        "tripInfo": tripInfo!.toJson(),
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
        driverImgUrl: json["driverImgUrl"] ?? '',
        phone: json["phone"] ?? '',
        countryCode: json["countryCode"] ?? '',
        name: json["name"] ?? '',
        vehicleNumber: json["vehicleNumber"] ?? '',
        driverId: json["driverId"] ?? '',
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
    required this.arrivalAtDestination,
  });

  PriceClass? priceClass;
  String? specialRemarks;
  String? paymentMode;
  String? passengerTripMasterId;
  String? tripStatus;
  bool? scheduledTrip;
  String? otp;
  DropLocation? dropLocation;
  PickupLocation? pickupLocation;
  ArrivalAtDestination? arrivalAtDestination;

  factory TripInfo.fromJson(Map<String, dynamic> json) => TripInfo(
        priceClass: json["priceClass"]!=null ? PriceClass.fromJson(json["priceClass"]):null,
        specialRemarks: json["specialRemarks"],
        paymentMode: json["paymentMode"],
        passengerTripMasterId: json["passengerTripMasterId"],
        tripStatus: json["tripStatus"],
        scheduledTrip: json["scheduledTrip"],
        otp: json["otp"],
        dropLocation: json["dropLocation"] !=null ? DropLocation.fromJson(json["dropLocation"]):null,
        pickupLocation: json["pickupLocation"]!=null ? PickupLocation.fromJson(json["pickupLocation"]):null,
        arrivalAtDestination: json["arrivalAtDestination"] != null ? ArrivalAtDestination.fromJson(json["arrivalAtDestination"]) : null,
      );

  Map<String, dynamic> toJson() => {
        "priceClass": priceClass!.toJson(),
        "specialRemarks": specialRemarks,
        "paymentMode": paymentMode,
        "passengerTripMasterId": passengerTripMasterId,
        "tripStatus": tripStatus,
        "scheduledTrip": scheduledTrip,
        "otp": otp,
        "dropLocation": dropLocation!.toJson(),
        "pickupLocation": pickupLocation!.toJson(),
        "arrivalAtDestination": arrivalAtDestination!.toJson(),
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

class ArrivalAtDestination {
  ArrivalAtDestination(
      {required this.advancePaid,
      required this.amountTobeCollected,
      required this.cgst,
      required this.discount,
      required this.discountedPrice,
      required this.distanceTravelled,
      required this.kmFare,
      required this.minuteFare,
      required this.paymentStatus,
      required this.perKMPrice,
      required this.priceInclusiveOfTax,
      required this.sgst,
      required this.tollAmount,
      required this.totalFare});

  dynamic advancePaid;
  dynamic amountTobeCollected;
  dynamic cgst;
  dynamic discount;
  dynamic discountedPrice;
  dynamic distanceTravelled;
  dynamic kmFare;
  dynamic minuteFare;
  String paymentStatus;
  dynamic perKMPrice;
  dynamic priceInclusiveOfTax;
  dynamic sgst;
  dynamic tollAmount;
  dynamic totalFare;

  factory ArrivalAtDestination.fromJson(Map<String, dynamic> json) =>
      ArrivalAtDestination(
        advancePaid: json["advancePaid"].toDouble(),
        amountTobeCollected: json["amountTobeCollected"].toDouble(),
        cgst: json["cgst"].toDouble(),
        discount: json["discount"].toDouble(),
        discountedPrice: json["discountedPrice"].toDouble(),
        distanceTravelled: json["distanceTravelled"].toDouble(),
        kmFare: json["kmFare"].toDouble(),
        minuteFare: json["minuteFare"].toDouble(),
        paymentStatus: json["paymentStatus"],
        perKMPrice: json["perKMPrice"].toDouble(),
        priceInclusiveOfTax: json["priceInclusiveOfTax"].toDouble(),
        sgst: json["sgst"].toDouble(),
        tollAmount: json["tollAmount"].toDouble(),
        totalFare: json["totalFare"].toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "advancePaid": advancePaid,
        "amountTobeCollected": amountTobeCollected,
        "cgst": cgst,
        "discount": discount,
        "discountedPrice": discountedPrice,
        "distanceTravelled": distanceTravelled,
        "kmFare": kmFare,
        "minuteFare": minuteFare,
        "paymentStatus": paymentStatus,
        "perKMPrice": perKMPrice,
        "priceInclusiveOfTax": priceInclusiveOfTax,
        "sgst": sgst,
        "tollAmount": tollAmount,
        "totalFare": totalFare,
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
  dynamic discountPercent;
  dynamic minFare;
  dynamic distance;
  dynamic tollCharges;
  dynamic sellerDiscount;
  dynamic totalFare;
  dynamic advancePaid;
  dynamic baseFare;
  String skuId;
  dynamic perKmFare;
  String type;
  dynamic stateTax;
  dynamic maxKmRange;
  String bootSpace;
  dynamic gstp;
  String subcategory;
  dynamic amountToBeCollected;

  factory PriceClass.fromJson(Map<String, dynamic> json) => PriceClass(
        passengerCapacity: json["passengerCapacity"],
        discountPercent: json["discountPercent"].toDouble(),
        minFare: json["minFare"].toDouble(),
        distance: json["distance"].toDouble(),
        tollCharges: json["toll_charges"].toDouble(),
        sellerDiscount: json["seller_discount"].toDouble(),
        totalFare: json["total_fare"].toDouble(),
        advancePaid: json["advancePaid"].toDouble(),
        baseFare: json["base_fare"].toDouble(),
        skuId: json["sku_id"],
        perKmFare: json["perKMFare"].toDouble(),
        type: json["type"],
        stateTax: json["state_tax"].toDouble(),
        maxKmRange: json["maxKmRange"].toDouble(),
        bootSpace: json["bootSpace"],
        gstp: json["gstp"].toDouble(),
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
