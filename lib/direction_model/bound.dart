
import 'package:envi/direction_model/northeast.dart';
class Bounds {
  Bounds({
    required this.northeast,
    required this.southwest,
  });

  Northeast northeast;
  Northeast southwest;

  factory Bounds.fromJson(Map<String, dynamic> json) => Bounds(
    northeast: Northeast.fromJson(json["northeast"]),
    southwest: Northeast.fromJson(json["southwest"]),
  );

  Map<String, dynamic> toJson() => {
    "northeast": northeast.toJson(),
    "southwest": southwest.toJson(),
  };
}