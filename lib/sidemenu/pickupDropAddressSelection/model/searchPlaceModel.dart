// To parse this JSON data, do
//
//     final searchPlaceModel = searchPlaceModelFromJson(jsonString);

import 'dart:convert';

import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

SearchPlaceModel searchPlaceModelFromJson(String str) =>
    SearchPlaceModel.fromJson(json.decode(str));

String searchPlaceModelToJson(SearchPlaceModel data) =>
    json.encode(data.toJson());

class SearchPlaceModel {
  SearchPlaceModel(
      {required this.id,
      required this.address,
      required this.title,
      this.latLng
      });

  String id;
  String address;
  String title;
  LatLng? latLng;

  factory SearchPlaceModel.fromJson(Map<String, dynamic> json) =>
      SearchPlaceModel(
          id: json["_id"],
          address: json["address"],
          title: json["title"],
          // lat: json['location']['coordinates'][1],
          // lang: json['location']['coordinates'][0]
          latLng: LatLng(json['location']['coordinates'][1],json['location']['coordinates'][0]),
          );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "address": address,
        "title": title,
      };
}
