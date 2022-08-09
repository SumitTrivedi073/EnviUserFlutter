// To parse this JSON data, do
//
//     final searchPlaceModel = searchPlaceModelFromJson(jsonString);

import 'dart:convert';

SearchPlaceModel searchPlaceModelFromJson(String str) => SearchPlaceModel.fromJson(json.decode(str));

String searchPlaceModelToJson(SearchPlaceModel data) => json.encode(data.toJson());

class SearchPlaceModel {
  SearchPlaceModel({
    required this.id,
    required this.address,
    required this.title,
    required this.count,
    required this.location,
  });

  String id;
  String address;
  String title;
  int count;
  Location location;

  factory SearchPlaceModel.fromJson(Map<String, dynamic> json) => SearchPlaceModel(
    id: json["_id"],
    address: json["address"],
    title: json["title"],
    count: json["count"],
    location: Location.fromJson(json["location"]),
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "address": address,
    "title": title,
    "count": count,
    "location": location.toJson(),
  };
}

class Location {
  Location({
     required this.coordinates,
  });

 List<double> coordinates;

  factory Location.fromJson(Map<String, dynamic> json) => Location(
    coordinates: List<double>.from(json["coordinates"].map((x) => x.toDouble())),
  );

  Map<String, dynamic> toJson() => {

    "coordinates": List<dynamic>.from(coordinates.map((x) => x)),
  };
}

