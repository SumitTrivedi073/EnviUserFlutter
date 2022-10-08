// To parse this JSON data, do
//
//     final searchPlaceModel = searchPlaceModelFromJson(jsonString);

import 'dart:convert';

import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';


class SearchPlaceModel {
  SearchPlaceModel(
      {required this.id,
      required this.address,
      required this.title,
        required this.isFavourite, required this.latLng

      });

   late String id;
  late String address;
  late String title;
  late LatLng latLng;
  late String isFavourite;
      factory SearchPlaceModel.fromJson(Map<String, dynamic> json) =>
      SearchPlaceModel(
          id: json["_id"] ?? "",
          address: json["address"] ?? "",
          title: json["title"] ?? "",
          latLng: LatLng(json['location']['coordinates'][1],json['location']['coordinates'][0]),
        isFavourite:json["isFavourite"] ?? "",
          );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "address": address,
        "title": title,
    "isFavourite":isFavourite,
      };
}
