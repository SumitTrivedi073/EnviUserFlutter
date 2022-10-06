


import 'bound.dart';
import '../direction_model/leg.dart';
import '../direction_model/polyline.dart';

class Route {
  Route({
    required this.bounds,
    required this.copyrights,
    required this.legs,
    required this.overviewPolyline,
    required this.summary,
    required this.warnings,
    required this.waypointOrder,
  });

  Bounds bounds;
  String copyrights;
  List<Leg> legs;
  Polyline overviewPolyline;
  String summary;
  List<dynamic> warnings;
  List<dynamic> waypointOrder;

  factory Route.fromJson(Map<String, dynamic> json) => Route(
    bounds: Bounds.fromJson(json["bounds"]),
    copyrights: json["copyrights"],
    legs: List<Leg>.from(json["legs"].map((x) => Leg.fromJson(x))),
    overviewPolyline: Polyline.fromJson(json["overview_polyline"]),
    summary: json["summary"],
    warnings: List<dynamic>.from(json["warnings"].map((x) => x)),
    waypointOrder: List<dynamic>.from(json["waypoint_order"].map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "bounds": bounds.toJson(),
    "copyrights": copyrights,
    "legs": List<dynamic>.from(legs.map((x) => x.toJson())),
    "overview_polyline": overviewPolyline.toJson(),
    "summary": summary,
    "warnings": List<dynamic>.from(warnings.map((x) => x)),
    "waypoint_order": List<dynamic>.from(waypointOrder.map((x) => x)),
  };
}