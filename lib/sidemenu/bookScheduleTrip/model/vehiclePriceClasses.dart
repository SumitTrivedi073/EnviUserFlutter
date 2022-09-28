class vehiclePriceClassesModel {
  late String sku_id,type,subcategory,bootSpace;
  late int minFare,perKMFare,passengerCapacity,maxKmRange;
  double? total_fare,seller_discount,distance;
  int? discountPercent;

  double? amount_to_be_collected;
  vehiclePriceClassesModel(this.sku_id, this.type, this.subcategory, this.amount_to_be_collected, this.bootSpace, this.distance, this.minFare,this.perKMFare,
      this.passengerCapacity,this.maxKmRange,this.total_fare,this.seller_discount,this.discountPercent

  );

  vehiclePriceClassesModel.fromJson(Map<String, dynamic> json) {
    sku_id = json['sku_id'];
    type = json['type'];
    subcategory = json['subcategory'];
    amount_to_be_collected = json["amount_to_be_collected"];
    bootSpace = json["bootSpace"];
    distance = json["distance"];
    minFare= json["minFare"];
    perKMFare = json["perKMFare"];
   passengerCapacity = json['perKMFare'];
    maxKmRange = json['maxKmRange'];
    total_fare = json['total_fare'];
    seller_discount = json['seller_discount'];
    discountPercent = json['discountPercent'];
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
