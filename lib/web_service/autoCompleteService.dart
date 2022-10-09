import 'dart:async';
import 'dart:math';

import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../database/database.dart';
import '../database/favoritesData.dart';
import '../database/favoritesDataDao.dart';
import '../sidemenu/pickupDropAddressSelection/model/searchPlaceModel.dart';

class AutocompleteService {
  late final FavoritesDataDao dao;
  Future<void> loadData() async {
    //List<FavoritesData>  temparr =  await dao.getFavoriate() ;
    // setState(() {
    //
    // });
    //findTaskByidentifier("5bf57942-b1be-4df2-a9a9-1e588bf8e1dd");
  }

  
  List<String> title = [];
      List<SearchPlaceModel> favPlaceList = [];
  Future<dynamic> getdata(String pat) async {
    final database =
        await $FloorFlutterDatabase.databaseBuilder('envi_user.db').build();
    dao = database.taskDao;
    // homeDetail = await dao.findTaskByTitle("Home");
    // workDetail = await dao.findTaskByTitle("Work");
    // List<FavoritesData> temparr = await dao.getFavoriate();
    // if (temparr.isNotEmpty) {
    //   for (var i = 0; i < temparr.length; i++) {
    //     title.add(temparr[i].address);
    //   }
    // }
    List<FavoritesData?> favData = await dao.displayAscByAddress(pat);

    if (favData.isNotEmpty) {
      for (var element in favData) {
        favPlaceList.add(SearchPlaceModel(
            id: element!.id.toString(),
            address: element.address,
            title: element.title,
            latLng: LatLng(
                double.parse(element.latitude), double.parse(element.longitude)),isFavourite: element.isFavourite));
          title.add(element.address);
      }
      favPlaceList..sort((a, b) => a.isFavourite.toLowerCase().compareTo(b.isFavourite.toLowerCase()));
    }

    return favPlaceList;
  }

  Future<List<String>> getSuggestions(String query) async {
    List<String> matches = <String>[];
    await loadData();
    await getdata(query);
    matches.addAll(title);
    matches.retainWhere((s) => s.toLowerCase().contains(query.toLowerCase()));
    return matches;
  }
}


//  static List<String> getSuggestions(String query) {
//     List<String> matches = <String>[];
//     matches.addAll(cities);

//     matches.retainWhere((s) => s.toLowerCase().contains(query.toLowerCase()));
//     return matches;
//   }
// }