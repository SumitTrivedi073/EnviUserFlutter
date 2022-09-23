import 'dart:async';
import 'dart:math';

import '../database/database.dart';
import '../database/favoritesData.dart';
import '../database/favoritesDataDao.dart';

class AutocompleteService {
  late final FavoritesDataDao dao;
  Future<void> loadData() async {
    //List<FavoritesData>  temparr =  await dao.getFavoriate() ;
    // setState(() {
    //
    // });
    //findTaskByidentifier("5bf57942-b1be-4df2-a9a9-1e588bf8e1dd");
  }

  List<FavoritesData> arraddress = [];
  List<String> title = [];
  Future<dynamic> getdata() async {
    final database =
        await $FloorFlutterDatabase.databaseBuilder('envi_user.db').build();
    dao = database.taskDao;
    // homeDetail = await dao.findTaskByTitle("Home");
    // workDetail = await dao.findTaskByTitle("Work");
    List<FavoritesData> temparr = await dao.getFavoriate();
    if (temparr.isNotEmpty) {
      for (var i = 0; i < temparr.length; i++) {
        title.add(temparr[i].address);
      }
    }
  }

  Future<List<String>> getSuggestions(String query) async {
    List<String> matches = <String>[];
    await loadData();
    await getdata();
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