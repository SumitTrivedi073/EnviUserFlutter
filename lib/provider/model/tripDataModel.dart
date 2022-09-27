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
    required this.tripStatus,
  });

  ErInfo? driverInfo;
  int? tollAmount;
  int? totalFare;
  DriverLocation? driverLocation;
  String? paymentMode;
  ErInfo? passengerInfo;
  TripInfo? tripInfo;
  String? tripStatus;
  UpdatedAt? updatedAt;

  factory TripDataModel.fromJson(Map<String, dynamic> json) => TripDataModel(
        driverInfo: ErInfo.fromJson(json["driverInfo"]) != null
            ? ErInfo.fromJson(json['driverInfo'])
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
        "tripStatus": tripStatus,
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
