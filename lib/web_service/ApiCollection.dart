import 'dart:convert';
// import 'dart:ffi';

import '../../../../web_service/HTTP.dart' as HTTP;
import 'APIDirectory.dart';


class ApiCollection {


  static Future<dynamic> FavoriateDataAdd(
      userid, title, fulladdress, lat,long,isFavourite) async {
    Map location = {
      "longitude":long,"latitude":lat,
    };
    Map address = {
"address":fulladdress,"name":title,"location":location,"isFavourite":isFavourite
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
      userid, title, fulladdress, lat,long,isFavourite,id) async {
    Map location = {
      "longitude":long,"latitude":lat,
    };
    Map address = {
      "address":fulladdress,"name":title,"location":location,"id" :id,"isFavourite":isFavourite
    };
    Map data = {
      "userid": userid,
      "address": address,

    };
    print(data);
    dynamic res = await HTTP.post(EditFavouriteAddressdata(), data);
    return res;
  }
  static Future<dynamic> FavoriateDataDelete(
      userid,id) async {
  static Future<dynamic> FavoriateDataDelete(
      userid,id) async {

    Map address = {
      "id" :id,
    };
    Map data = {
      "userid": userid,
      "address": address,

    };
    print(data);
    dynamic res = await HTTP.post(DeleteFavouriteAddressdata(), data);
    return res;
  }


    Map address = {
     "id" :id,
    };
    Map data = {
      "userid": userid,
      "address": address,

    };
    print(data);
    dynamic res = await HTTP.post(DeleteFavouriteAddressdata(), data);
    return res;
  }

}
