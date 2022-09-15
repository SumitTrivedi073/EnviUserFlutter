
import 'package:floor/floor.dart';

import 'favoritesData.dart';

@dao
abstract class FavoritesDataDao {
  @Query('SELECT * FROM FavoritesTable WHERE id = :id')
  Future<FavoritesData?> findTaskById(int id);

  @Query('SELECT * FROM FavoritesTable')
  Future<List<FavoritesData>> findAllTasks();

  @Query('SELECT * FROM FavoritesTable')
  Stream<List<FavoritesData>> findAllTasksAsStream();

  @Query('SELECT * FROM FavoritesTable WHERE type = :type')
  Stream<List<FavoritesData>> findAllTasksByTypeAsStream(String type);

  @insert
  Future<void> insertTask(FavoritesData task);

  @insert
  Future<void> insertTasks(List<FavoritesData> tasks);

  @update
  Future<void> updateTask(FavoritesData task);

  @update
  Future<void> updateTasks(List<FavoritesData> task);

  @delete
  Future<void> deleteTask(FavoritesData task);

  @delete
  Future<void> deleteTasks(List<FavoritesData> tasks);
  @Query('SELECT * FROM FavoritesData WHERE identifier = :identifier')
  Future<FavoritesData?> findByIdentifier(String identifier);

  @Query('SELECT * FROM FavoritesData WHERE title != \'Work\' and title != \'Home\' and isFavourite = \'Y\'')
  Future<List<FavoritesData>> getFavoriate();
  @Query('SELECT * FROM FavoritesTable WHERE title = :title')
  Future<FavoritesData?> findTaskByTitle(String title);

}
