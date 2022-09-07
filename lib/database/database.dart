import 'dart:async';

import 'package:envi/database/type_converter.dart';
import 'package:floor/floor.dart';
import 'package:sqflite/sqflite.dart' as sqflite;

import 'favoritesData.dart';
import 'favoritesDataDao.dart';

part 'database.g.dart';

@Database(version: 1, entities: [FavoritesData])
@TypeConverters([DateTimeConverter])
abstract class FlutterDatabase extends FloorDatabase {
  FavoritesDataDao get taskDao;
}
