// To parse this JSON data, do
//
//     final directionModel = directionModelFromJson(jsonString);

import 'dart:convert';

import 'geocodeWayPoint.dart';
import 'route.dart';

DirectionModel directionModelFromJson(String str) => DirectionModel.fromJson(json.decode(str));

String directionModelToJson(DirectionModel data) => json.encode(data.toJson());

class DirectionModel {
  DirectionModel({
    required this.geocodedWaypoints,
    required this.routes,
    required this.status,
  });

  List<GeocodedWaypoint> geocodedWaypoints;
  List<Route> routes;
  String status;

  factory DirectionModel.fromJson(Map<String, dynamic> json) => DirectionModel(
    geocodedWaypoints: List<GeocodedWaypoint>.from(json["geocoded_waypoints"].map((x) => GeocodedWaypoint.fromJson(x))),
    routes: List<Route>.from(json["routes"].map((x) => Route.fromJson(x))),
    status: json["status"],
  );

  Map<String, dynamic> toJson() => {
    "geocoded_waypoints": List<dynamic>.from(geocodedWaypoints.map((x) => x.toJson())),
    "routes": List<dynamic>.from(routes.map((x) => x.toJson())),
    "status": status,
  };
}















