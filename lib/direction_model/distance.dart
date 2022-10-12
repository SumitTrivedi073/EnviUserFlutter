
class Distance {
  Distance({
    required this.text,
    required this.value,
  });

  String text;
  double value;

  factory Distance.fromJson(Map<String, dynamic> json) => Distance(
    text: json["text"],
    value: json["value"].toDouble(),
  );

  Map<String, dynamic> toJson() => {
    "text": text,
    "value": value,
  };
}