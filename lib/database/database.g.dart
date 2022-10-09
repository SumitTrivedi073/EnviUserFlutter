// GENERATED CODE - DO NOT MODIFY BY HAND
part of 'database.dart';

// **************************************************************************
// FloorGenerator
// **************************************************************************

// ignore: avoid_classes_with_only_static_members

class $FloorFlutterDatabase {
  /// Creates a database builder for a persistent database.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static _$FlutterDatabaseBuilder databaseBuilder(String name) =>
      _$FlutterDatabaseBuilder(name);

  /// Creates a database builder for an in memory database.
  /// Information stored in an in memory database disappears when the process is killed.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static _$FlutterDatabaseBuilder inMemoryDatabaseBuilder() =>
      _$FlutterDatabaseBuilder(null);
}

class _$FlutterDatabaseBuilder {
  _$FlutterDatabaseBuilder(this.name);

  final String? name;

  final List<Migration> _migrations = [];

  Callback? _callback;

  /// Adds migrations to the builder.
  _$FlutterDatabaseBuilder addMigrations(List<Migration> migrations) {
    _migrations.addAll(migrations);
    return this;
  }

  /// Adds a database [Callback] to the builder.
  _$FlutterDatabaseBuilder addCallback(Callback callback) {
    _callback = callback;
    return this;
  }

  /// Creates the database and initializes it.
  Future<FlutterDatabase> build() async {
    final path = name != null
        ? await sqfliteDatabaseFactory.getDatabasePath(name!)
        : ':memory:';
    final database = _$FlutterDatabase();
    database.database = await database.open(
      path,
      _migrations,
      _callback,
    );
    return database;
  }
}

class _$FlutterDatabase extends FlutterDatabase {
  _$FlutterDatabase([StreamController<String>? listener]) {
    changeListener = listener ?? StreamController<String>.broadcast();
  }

  FavoritesDataDao? _taskDaoInstance;

  Future<sqflite.Database> open(String path, List<Migration> migrations,
      [Callback? callback]) async {
    final databaseOptions = sqflite.OpenDatabaseOptions(
      version: 1,
      onConfigure: (database) async {
        await database.execute('PRAGMA foreign_keys = ON');
        await callback?.onConfigure?.call(database);
      },
      onOpen: (database) async {
        await callback?.onOpen?.call(database);
      },
      onUpgrade: (database, startVersion, endVersion) async {
        await MigrationAdapter.runMigrations(
            database, startVersion, endVersion, migrations);

        await callback?.onUpgrade?.call(database, startVersion, endVersion);
      },
      onCreate: (database, version) async {
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `FavoritesData` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `identifier` TEXT NOT NULL, `address` TEXT NOT NULL, `isFavourite` TEXT NOT NULL, `latitude` TEXT NOT NULL, `longitude` TEXT NOT NULL, `title` TEXT NOT NULL,`timestamp` INTEGER NOT NULL)');

        await callback?.onCreate?.call(database, version);
      },
    );
    return sqfliteDatabaseFactory.openDatabase(path, options: databaseOptions);
  }

  @override
  FavoritesDataDao get taskDao {
    return _taskDaoInstance ??= _$FavoritesDataDao(database, changeListener);
  }
}

class _$FavoritesDataDao extends FavoritesDataDao {
  _$FavoritesDataDao(this.database, this.changeListener)
      : _queryAdapter = QueryAdapter(database, changeListener),
        _taskInsertionAdapter = InsertionAdapter(
            database,
            'FavoritesData',
            (FavoritesData item) => <String, Object?>{
                  'id': item.id,
                  'identifier': item.identifier,
                  'address': item.address,
                  'isFavourite': item.isFavourite,
                  'latitude': item.latitude,
                  'longitude': item.longitude,
                  'title': item.title,
                  'timestamp': _dateTimeConverter.encode(item.timestamp),
                },
            changeListener),
        _taskUpdateAdapter = UpdateAdapter(
            database,
            'FavoritesData',
            ['id'],
            (FavoritesData item) => <String, Object?>{
                  'id': item.id,
                  'identifier': item.identifier,
                  'address': item.address,
                  'isFavourite': item.isFavourite,
                  'latitude': item.latitude,
                  'longitude': item.longitude,
                  'title': item.title,
                  'timestamp': _dateTimeConverter.encode(item.timestamp),
                },
            changeListener),
        _taskDeletionAdapter = DeletionAdapter(
            database,
            'FavoritesData',
            ['id'],
            (FavoritesData item) => <String, Object?>{
                  'id': item.id,
                  'identifier': item.identifier,
                  'address': item.address,
                  'isFavourite': item.isFavourite,
                  'latitude': item.latitude,
                  'longitude': item.longitude,
                  'title': item.title,
                  'timestamp': _dateTimeConverter.encode(item.timestamp),
                },
            changeListener);

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<FavoritesData> _taskInsertionAdapter;

  final UpdateAdapter<FavoritesData> _taskUpdateAdapter;

  final DeletionAdapter<FavoritesData> _taskDeletionAdapter;

  @override
  Future<FavoritesData?> findTaskById(int id) async {
    return _queryAdapter.query('SELECT * FROM FavoritesData WHERE id = ?1',
        mapper: (Map<String, Object?> row) => FavoritesData(
            row['id'] as int?,
            row['identifier'] as String,
            row['address'] as String,
            row['isFavourite'] as String,
            row['latitude'] as String,
            row['longitude'] as String,
            row['title'] as String,
            _dateTimeConverter.decode(row['timestamp'] as int)),
        arguments: [id]);
  }

  @override
  Future<FavoritesData?> findByIdentifier(String id) async {
    return _queryAdapter.query(
        'SELECT * FROM FavoritesData WHERE identifier = ?1',
        mapper: (Map<String, Object?> row) => FavoritesData(
            row['id'] as int?,
            row['identifier'] as String,
            row['address'] as String,
            row['isFavourite'] as String,
            row['latitude'] as String,
            row['longitude'] as String,
            row['title'] as String,
            _dateTimeConverter.decode(row['timestamp'] as int)),
        arguments: [id]);
  }

  @override
  Future<List<FavoritesData>> findAllTasks() async {
    return _queryAdapter.queryList(
      'SELECT * FROM FavoritesData',
      mapper: (Map<String, Object?> row) => FavoritesData(
          row['id'] as int?,
          row['identifier'] as String,
          row['address'] as String,
          row['isFavourite'] as String,
          row['latitude'] as String,
          row['longitude'] as String,
          row['title'] as String,
          _dateTimeConverter.decode(row['timestamp'] as int)),
    );
  }

  @override
  Future<List<FavoritesData>> getFavoriate() async {
    return _queryAdapter.queryList(
      'SELECT * FROM FavoritesData WHERE title != \'Work\' and title != \'Home\' and isFavourite = \'Y\'',
      mapper: (Map<String, Object?> row) => FavoritesData(
          row['id'] as int?,
          row['identifier'] as String,
          row['address'] as String,
          row['isFavourite'] as String,
          row['latitude'] as String,
          row['longitude'] as String,
          row['title'] as String,
          _dateTimeConverter.decode(row['timestamp'] as int)),
    );
  }

  @override
  Stream<List<FavoritesData>> findAllTasksAsStream() {
    return _queryAdapter.queryListStream('SELECT * FROM FavoritesData',
        mapper: (Map<String, Object?> row) => FavoritesData(
            row['id'] as int?,
            row['identifier'] as String,
            row['address'] as String,
            row['isFavourite'] as String,
            row['latitude'] as String,
            row['longitude'] as String,
            row['title'] as String,
            _dateTimeConverter.decode(row['timestamp'] as int)),
        queryableName: 'FavoritesData',
        isView: false);
  }

  @override
  Stream<List<FavoritesData>> findAllTasksByTypeAsStream(String type) {
    return _queryAdapter.queryListStream(
        'SELECT * FROM FavoritesData WHERE type = ?1',
        mapper: (Map<String, Object?> row) => FavoritesData(
            row['id'] as int?,
            row['identifier'] as String,
            row['address'] as String,
            row['isFavourite'] as String,
            row['latitude'] as String,
            row['longitude'] as String,
            row['title'] as String,
            _dateTimeConverter.decode(row['timestamp'] as int)),
        arguments: [type],
        queryableName: 'FavoritesData',
        isView: false);
  }

  @override
  Future<void> insertTask(FavoritesData task) async {
    await _taskInsertionAdapter.insert(task, OnConflictStrategy.abort);
  }

  @override
  Future<void> insertTasks(List<FavoritesData> tasks) async {
    await _taskInsertionAdapter.insertList(tasks, OnConflictStrategy.abort);
  }

  @override
  Future<void> updateTask(FavoritesData task) async {
    await _taskUpdateAdapter.update(task, OnConflictStrategy.abort);
  }

  @override
  Future<void> updateTasks(List<FavoritesData> task) async {
    await _taskUpdateAdapter.updateList(task, OnConflictStrategy.abort);
  }

  @override
  Future<void> deleteTask(FavoritesData task) async {
    await _taskDeletionAdapter.delete(task);
  }

  @override
  Future<void> deleteTasks(List<FavoritesData> tasks) async {
    await _taskDeletionAdapter.deleteList(tasks);
  }

  @override
  Future<FavoritesData?> findTaskByTitle(String title) async {
    return _queryAdapter.query('SELECT * FROM FavoritesData WHERE title = ?1',
        mapper: (Map<String, Object?> row) => FavoritesData(
              row['id'] as int?,
              row['identifier'] as String,
              row['address'] as String,
              row['isFavourite'] as String,
              row['latitude'] as String,
              row['longitude'] as String,
              row['title'] as String,
              _dateTimeConverter.decode(row['timestamp'] as int),
            ),
        arguments: [title]);
  }

  @override
  Future<FavoritesData?> findDataByaddressg(String address) async {
    return _queryAdapter.query('SELECT * FROM FavoritesData WHERE address = ?',
        mapper: (Map<String, Object?> row) => FavoritesData(
            row['id'] as int?,
            row['identifier'] as String,
            row['address'] as String,
            row['isFavourite'] as String,
            row['latitude'] as String,
            row['longitude'] as String,
            row['title'] as String,
            _dateTimeConverter.decode(row['timestamp'] as int)),
        arguments: [address]);
  }

 

  @override
  Future<List<FavoritesData?>> displayAscByAddress(String address) async{
     return _queryAdapter.queryList(
      'SELECT * FROM FavoritesData WHERE  address LIKE ? ORDER BY timestamp ASC',
      mapper: (Map<String, Object?> row) => FavoritesData(
          row['id'] as int?,
          row['identifier'] as String,
          row['address'] as String,
          row['isFavourite'] as String,
          row['latitude'] as String,
          row['longitude'] as String,
          row['title'] as String,
          _dateTimeConverter.decode(row['timestamp'] as int)),
         arguments: ['%$address%']
          );
    
  }
}

// ignore_for_file: unused_element
final _dateTimeConverter = DateTimeConverter();
