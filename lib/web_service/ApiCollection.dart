// import 'dart:ffi';

import '../../../../web_service/HTTP.dart' as HTTP;
import 'APIDirectory.dart';

class ApiCollection {
  static Future<dynamic> FavoriateDataAdd(
      userid, title, fulladdress, lat, long, isFavourite) async {
    Map location = {
      "longitude": long,
      "latitude": lat,
    };
    Map address = {
      "address": fulladdress,
      "name": title,
      "location": location,
      "isFavourite": isFavourite
    };
    Map data = {
      "userid": userid,
      "address": address,
    };
    print(data);
    dynamic res = await HTTP.post(AddFavouriteAddressdata(), data);
    return res;
  }

  static Future<dynamic> FavoriateDataUpdate(
      userid, title, fulladdress, lat, long, isFavourite, id) async {
    Map location = {
      "longitude": long,
      "latitude": lat,
    };
    Map address = {
      "address": fulladdress,
      "name": title,
      "location": location,
      "id": id,
      "isFavourite": isFavourite
    };
    Map data = {
      "userid": userid,
      "address": address,
    };
    print(data);
    dynamic res = await HTTP.post(EditFavouriteAddressdata(), data);
    return res;
  }

  static Future<dynamic> FavoriateDataDelete(userid, id) async {
    Map address = {
      "id": id,
    };
    Map data = {
      "userid": userid,
      "address": address,
    };
    print(data);
    dynamic res = await HTTP.post(DeleteFavouriteAddressdata(), data);
    return res;
  }

  static Future<dynamic> getScheduleEstimationdata(from_latitude,
      from_longitude, to_latitude, to_longitude, scheduledAt) async {
    Map data = {};
    if (scheduledAt.toString().isNotEmpty) {
      data = {
        "from_latitude": from_latitude,
        "from_longitude": from_longitude,
        "to_latitude": to_latitude,
        "to_longitude": to_longitude,
      };
    } else {
      data = {
        "from_latitude": from_latitude,
        "from_longitude": from_longitude,
        "to_latitude": to_latitude,
        "to_longitude": to_longitude,
        "scheduledAt": scheduledAt
      };
    }
    print("SheduleEstimationdata==========>$data");
    dynamic res = await HTTP.post(getScheduleEstimation(), data);
    return res;
  }

  static Future<dynamic> AddnewSchedualeTrip(fromLocation, toLocation,
      scheduledAt, estimatedPrice, estimatedDistance, sku_id) async {
    Map data = {
      "from_address": fromLocation.address,
      "from_latitude": fromLocation.latLng.latitude,
      "from_longitude": fromLocation.latLng.longitude,
      "to_address": toLocation.address,
      "to_latitude": toLocation.latLng.latitude,
      "to_longitude": toLocation.latLng.longitude,
      "scheduledAt": scheduledAt,
      "estimatedPrice": estimatedPrice,
      "estimatedDistance": estimatedDistance,
      "sku_id": sku_id,
    };
    print(data);
    dynamic res = await HTTP.post(AddSchedualeTrip(), data);
    return res;
  }

  static Future<dynamic> cancelSchedualeTrip(passengerTripMasterId) async {
    dynamic res = await HTTP.get(cancleSchedule(passengerTripMasterId));
    return res;
  }
}
