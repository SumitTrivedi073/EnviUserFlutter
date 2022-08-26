class RideHistoryModel {
  late String fromAddress;
  late String passengerTripMasterId,name,driverPhoto,toAddress,status,start_time;
double distance=0.0;
 late PriceDetails price;
 late vehicleDetails vehicle;
  RideHistoryModel(this.fromAddress, this.passengerTripMasterId, this.name, this.driverPhoto, this.toAddress, this.distance, this.status,this.start_time,
      this.price,this.vehicle
      );

  RideHistoryModel.fromJson(Map<String, dynamic> json) {
    fromAddress = json['fromAddress'];
    passengerTripMasterId = json['passengerTripMasterId'];
    name = json['name'];
    driverPhoto = json["driverPhoto"];
    toAddress = json["toAddress"];
    distance = json["distance"];
    status= json["status"];
    start_time = json["start_time"];
    price = (json["price"] != null)
        ? PriceDetails.fromJson(json["price"])
        : PriceDetails.fromJson({});
    vehicle = (json["vehicle"] != null)
        ? vehicleDetails.fromJson(json["vehicle"])
        : vehicleDetails.fromJson({});
  }
  Map<String, dynamic> toJson() => {
    "fromAddress": fromAddress,
    "passengerTripMasterId": passengerTripMasterId,
    "name": name,
    "driverPhoto": driverPhoto,
    "toAddress": toAddress,
    "distance": distance,
    "status": status,
    "start_time":start_time,
  };
}
class PriceDetails {
  late String? tollAmount;
int totalFare = 0;
  PriceDetails({
    required this.tollAmount,
    required this.totalFare,
  });

  factory PriceDetails.fromJson(Map<String, dynamic> json) =>
      PriceDetails(
        tollAmount: json["tollAmount"] != null
            ? json["tollAmount"]
            : "NA",
        totalFare:
        json["totalFare"] != 0 ? json["totalFare"] : 0,
      );

  Map<String, dynamic> toJson() => {
    "tollAmount": tollAmount,
    "vehicleNumber": totalFare,
  };
}


class vehicleDetails {
  late String Vnumber,model;

  vehicleDetails({
    required this.Vnumber,
    required this.model,
  });

  factory vehicleDetails.fromJson(Map<String, dynamic> json) =>
      vehicleDetails(
        Vnumber: json["number"] != null
            ? json["number"]
            : "NA",
        model:
        json["model"] != null ? json["model"] : "N/A",
      );

  Map<String, dynamic> toJson() => {
    "number": Vnumber,
    "model": model,
  };
}