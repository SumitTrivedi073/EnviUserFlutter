import 'dart:convert';

class SearchLocationModel {
  SearchLocationModel({
    required this.id,
    required this.address,
    required this.title,
    required this.lat,
    required this.lng
  });

  String id;
  String address;
  String title;
  double lat;
  double lng;


}