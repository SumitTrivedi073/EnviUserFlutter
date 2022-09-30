class PaymentType {
  final String paymentMode;
  final String passengerTripMasterId;

  PaymentType({required this.paymentMode, required this.passengerTripMasterId});

  factory PaymentType.fromJson(Map<String, dynamic> json) {
    return PaymentType(
        paymentMode: json["paymentMode"],
        passengerTripMasterId: json["passengerTripMasterId"]);
  }
  Map<String, dynamic> toJson() => {
    "paymentMode": paymentMode,
    "passengerTripMasterId": passengerTripMasterId
  };
}
