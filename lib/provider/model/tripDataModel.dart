//tripDataModel
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
List<TripDataModel> userFromJson(String str) =>
    List<TripDataModel>.from(
        json.decode(str).map((x) => TripDataModel.fromJson(x)));

String userToJson(List<TripDataModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class TripDataModel {
  late String? paymentMode,
      tripStatus;

  TripInfo driverTripDetails;
  PassengerInfo passengerInfo;
  double? tollAmount,totalFare;
  DriverInfo driverInfo;
  DriverLocation driverLocation;

  TripDataModel(
      {
        required this.paymentMode,
        required this.tripStatus,
        required this.tollAmount,
        required this.totalFare,

        required this.driverTripDetails,
        required this.passengerInfo,
        required this.driverInfo,
        required this.driverLocation,
       });

  static dynamic myEncode1(dynamic item) {
    if (item is Timestamp) {
      var dt = item.toDate();
      // var d12 = DateFormat('yyyy-MM-ddThh:mm a').add_jm().format(dt);
      // var d12 = DateFormat.yMd().add_jm().format(dt);
      return dt.toIso8601String();
    }

    return item;
  }

  factory TripDataModel.fromJson(Map<String, dynamic> json) {
    return TripDataModel(

      
      paymentMode:
      json["paymentMode"] != null ? json["paymentMode"].toString() : "NA",
      tripStatus: json["tripStatus"] != null ? json["status"]?.toString() : "NA",

      driverTripDetails: (json["tripInfo"] != null)
          ? TripInfo.fromJson(json["tripInfo"])
          : TripInfo.fromJson({}),

      passengerInfo: (json["passengerInfo"] != null)
          ? PassengerInfo.fromJson(json["passengerInfo"])
          : PassengerInfo(countryCode: "NA", name: "NA", phone: "NA"),

      driverInfo: (json["driverInfo"] != null)
          ? DriverInfo.fromJson(json["driverInfo"])
          : DriverInfo.fromJson({}),
      driverLocation: (json["driverLocation"] != null)
          ? DriverLocation.fromJson(json["driverLocation"])
          : DriverLocation.fromJson({}),
      tollAmount:
      (json["tollAmount"] != 0) ? json["tollAmount"] : 0.0,
      totalFare:
      json["totalFare"] != 0 ? json["totalFare"] : 0.0,

    );
  }

  Map<String, dynamic> toJson() => {

    "paymentMode": paymentMode,
    "status": tripStatus,

    "driverTripDetails": driverTripDetails.toJson(),
    "customer": passengerInfo.toJson(),
    "driverInfo": driverInfo.toJson(),
    "tollAmount":tollAmount,
    "totalFare":totalFare,
    "driverLocation":driverLocation.toJson(),

  };
}

class TripInfo {
  late String? passengerTripMasterId;
  PickupLocation pickupLocation;
  DropLocation dropLocation;
  TripInfo({
    required this.passengerTripMasterId,
    required this.dropLocation,required this.pickupLocation,
  });

  factory TripInfo.fromJson(Map<String, dynamic> json) =>
      TripInfo(
        passengerTripMasterId: json["passengerTripMasterId"] != null
            ? json["passengerTripMasterId"]
            : "NA",
        pickupLocation: (json["pickupLocation"] != null)
            ? PickupLocation.fromJson(json["pickupLocation"])
            : PickupLocation.fromJson({}),
        dropLocation: (json["dropLocation"] != null)
            ? DropLocation.fromJson(json["dropLocation"])
            : DropLocation.fromJson({}),
      );

  Map<String, dynamic> toJson() => {
    "driverTripMasterId": passengerTripMasterId,
    "dropLocation": dropLocation.toJson(),
    "pickupLocation":pickupLocation.toJson(),
  };
}
class DropLocation {
  late String? dropAddress;
  String longitude,latitude;

  DropLocation({
    required this.dropAddress,
    required this.longitude,required this.latitude,
  });

  factory DropLocation.fromJson(Map<String, dynamic> json) =>
      DropLocation(
        dropAddress: json["dropAddress"] != null
            ? json["dropAddress"]
            : "NA",
        latitude:
        json["latitude"] != null ? json["latitude"] : "0",
        longitude:
        json["longitude"] != null ? json["longitude"] : "0",
      );

  Map<String, dynamic> toJson() => {
    "dropAddress": dropAddress,
    "latitude": latitude,
    "longitude":longitude,
  };
}
class PickupLocation {
  late String? pickupAddress;
  String longitude,latitude;

  PickupLocation({
    required this.pickupAddress,
    required this.latitude,required this.longitude,
  });

  factory PickupLocation.fromJson(Map<String, dynamic> json) =>
      PickupLocation(
        pickupAddress: json["pickupAddress"] != null
            ? json["pickupAddress"]
            : "NA",
        latitude:
        json["latitude"] != null ? json["latitude"] : "0",
        longitude:
        json["longitude"] != null ? json["longitude"] : "0",
      );

  Map<String, dynamic> toJson() => {
    "pickupAddress": pickupAddress,
    "latitude": latitude,
    "longitude":longitude,
  };
}
class PassengerInfo {
  late String? countryCode, name, phone;

  PassengerInfo({
    required this.countryCode,
    required this.name,
    required this.phone,
  });

  factory PassengerInfo.fromJson(Map<String, dynamic> json) => PassengerInfo(
    countryCode: json != null && json["id"] != null ? json["countryCode"] : 'NA',
    name: json != null && json["name"] != null ? json["name"] : "NA",
    phone: json != null && json["phone"] != null ? json["phone"] : "NA",
  );

  Map<String, dynamic> toJson() => {
    "countryCode": countryCode,
    "name": name,
    "phone": phone,
  };
}

class DriverLocation {

String longitude,latitude;
DriverLocation({
    required this.latitude,
    required this.longitude,

  });

  factory DriverLocation.fromJson(Map<String, dynamic> json) => DriverLocation(
    latitude: json["latitude"] != null ? json["latitude"] : "0.0",
    longitude: json["longitude"] != null ? json["longitude"] : "0.0",
  );

  Map<String, dynamic> toJson() => {
    "longitude": longitude,
    "latitude": latitude,

  };
}


class DriverInfo {
  late String? countryCode, name, phone;

  DriverInfo({
    required this.countryCode,
    required this.name,
    required this.phone,
  });

  factory DriverInfo.fromJson(Map<String, dynamic> json) => DriverInfo(
    countryCode: json["countryCode"] != null ? json["countryCode"] : 'NA',
    name: json["name"] != null ? json["name"] : "NA",
    phone: json["phone"] != null ? json["phone"] : "NA",
  );

  Map<String, dynamic> toJson() => {
    "countryCode": countryCode,
    "name": name,
    "phone": phone,
  };
}


