

import 'distance.dart';
import '../direction_model/northeast.dart';
import '../direction_model/polyline.dart';

class Step {
  Step({
    required this.distance,
    required this.duration,
    required this.endLocation,
    required this.htmlInstructions,
    required this.polyline,
    required this.startLocation,
    required this.maneuver,
  });

  Distance distance;
  Distance duration;
  Northeast endLocation;
  String htmlInstructions;
  Polyline polyline;
  Northeast startLocation;
  String maneuver;

  factory Step.fromJson(Map<String, dynamic> json) => Step(
    distance: Distance.fromJson(json["distance"]),
    duration: Distance.fromJson(json["duration"]),
    endLocation: Northeast.fromJson(json["end_location"]),
    htmlInstructions: json["html_instructions"],
    polyline: Polyline.fromJson(json["polyline"]),
    startLocation: Northeast.fromJson(json["start_location"]),
    maneuver: json["maneuver"]??"",
  );

  Map<String, dynamic> toJson() => {
    "distance": distance.toJson(),
    "duration": duration.toJson(),
    "end_location": endLocation.toJson(),
    "html_instructions": htmlInstructions,
    "polyline": polyline.toJson(),
    "start_location": startLocation.toJson(),
    "maneuver": maneuver,
  };
}