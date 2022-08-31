class ScheduleTripModel {
  late String fromAddress,toAddress;
  late String _id,scheduledAt,status,estimatedDistance;
  String estimatedPrice = "0.0" ;
  ScheduleTripModel(this.fromAddress, this._id, this.toAddress, this.estimatedDistance, this.status,this.scheduledAt,this.estimatedPrice

      );

  ScheduleTripModel.fromJson(Map<String, dynamic> json) {
    fromAddress = json['fromAddress'];
    _id = json['_id'];

    toAddress = json["toAddress"];
    estimatedDistance = json["estimatedDistance"].toString();
    status= json["status"];
    scheduledAt = json["scheduledAt"];
    estimatedPrice = json["estimatedPrice"].toString();
  }
  Map<String, dynamic> toJson() => {
    "fromAddress": fromAddress,
    "passengerTripMasterId": _id,
    "toAddress": toAddress,
    "estimatedDistance":estimatedDistance,
    "status": status,
    "scheduledAt":scheduledAt,
    "estimatedPrice":estimatedPrice,
  };
}
