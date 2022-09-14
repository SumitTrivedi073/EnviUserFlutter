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
  });

  String id;
  String address;
  String title;



  factory SearchPlaceModel.fromJson(Map<String, dynamic> json) => SearchPlaceModel(
    id: json["_id"],
    address: json["address"],
    title: json["title"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "address": address,
    "title": title,
  };
}

