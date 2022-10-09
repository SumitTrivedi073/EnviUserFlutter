class vehiclePriceClassesModel {
  late String sku_id,type,subcategory,bootSpace;
  late int minFare,perKMFare,passengerCapacity,maxKmRange;
  double? total_fare,seller_discount,distance;
  String? discountPercent;

  double? amount_to_be_collected;
  vehiclePriceClassesModel(this.sku_id, this.type, this.subcategory, this.amount_to_be_collected, this.bootSpace, this.distance, this.minFare,this.perKMFare,
      this.passengerCapacity,this.maxKmRange,this.total_fare,this.seller_discount,this.discountPercent

  );

  vehiclePriceClassesModel.fromJson(Map<String, dynamic> json) {
    sku_id = json['sku_id'];
    type = json['type'];
    subcategory = json['subcategory'];
    amount_to_be_collected = double.parse(json["amount_to_be_collected"].toString());
    bootSpace = json["bootSpace"];
    distance = double.parse(json["distance"].toString());
    minFare= json["minFare"];
    perKMFare = json["perKMFare"];
   passengerCapacity = json['perKMFare'];
    maxKmRange = json['maxKmRange'];
    total_fare = double.parse(json['total_fare'].toString());
    seller_discount = double.parse(json['seller_discount'].toString());
    discountPercent = json['discountPercent'].toString();
  }
  Map<String, dynamic> toJson() => {
    "sku_id": sku_id,
    "type": type,
    "subcategory": subcategory,
    "amount_to_be_collected": amount_to_be_collected,
    "bootSpace": bootSpace,
    "distance": distance,
"total_fare":total_fare,
    "minFare":minFare,
    "perKMFare":perKMFare,
    "passengerCapacity":passengerCapacity,
    "maxKmRange":maxKmRange,
    "seller_discount":seller_discount,
"discountPercent":discountPercent,
  };
}
