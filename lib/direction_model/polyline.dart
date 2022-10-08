
class Polyline {
  Polyline({
    required this.points,
  });

  String points;

  factory Polyline.fromJson(Map<String, dynamic> json) => Polyline(
    points: json["points"],
  );

  Map<String, dynamic> toJson() => {
    "points": points,
  };
}