

import '../direction_model/distance.dart';
import 'northeast.dart';
import '../direction_model/step.dart';

class Leg {
  Leg({
    required this.distance,
    required this.duration,
    required this.endAddress,
    required this.endLocation,
    required this.startAddress,
    required this.startLocation,
    required this.steps,
    required this.trafficSpeedEntry,
    required this.viaWaypoint,
  });

  Distance distance;
  Distance duration;
  String endAddress;
  Northeast endLocation;
  String startAddress;
  Northeast startLocation;
  List<Step> steps;
  List<dynamic> trafficSpeedEntry;
  List<dynamic> viaWaypoint;

  factory Leg.fromJson(Map<String, dynamic> json) => Leg(
    distance: Distance.fromJson(json["distance"]),
    duration: Distance.fromJson(json["duration"]),
    endAddress: json["end_address"],
    endLocation: Northeast.fromJson(json["end_location"]),
    startAddress: json["start_address"],
    startLocation: Northeast.fromJson(json["start_location"]),
    steps: List<Step>.from(json["steps"].map((x) => Step.fromJson(x))),
    trafficSpeedEntry: List<dynamic>.from(json["traffic_speed_entry"].map((x) => x)),
    viaWaypoint: List<dynamic>.from(json["via_waypoint"].map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "distance": distance.toJson(),
    "duration": duration.toJson(),
    "end_address": endAddress,
    "end_location": endLocation.toJson(),
    "start_address": startAddress,
    "start_location": startLocation.toJson(),
    "steps": List<dynamic>.from(steps.map((x) => x.toJson())),
    "traffic_speed_entry": List<dynamic>.from(trafficSpeedEntry.map((x) => x)),
    "via_waypoint": List<dynamic>.from(viaWaypoint.map((x) => x)),
  };
}
