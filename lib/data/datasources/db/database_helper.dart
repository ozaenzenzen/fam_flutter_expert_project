import 'dart:async';

import 'package:ditonton/data/models/watchlist_table.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static DatabaseHelper? _databaseHelper;
  DatabaseHelper._instance() {
    _databaseHelper = this;
  }

  factory DatabaseHelper() => _databaseHelper ?? DatabaseHelper._instance();

  static Database? _database;

  Future<Database?> get database async {
    _database ??= await _initDb();
    return _database;
  }

  static const String _tblWatchlist = 'watchlist';

  Future<Database> _initDb() async {
    final path = await getDatabasesPath();
    final databasePath = '$path/ditonton.db';

    var db = await openDatabase(databasePath, version: 1, onCreate: _onCreate);
    return db;
  }

  void _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE  $_tblWatchlist (
        id INTEGER,
        title TEXT,
        overview TEXT,
        posterPath TEXT,
        dataType INTEGER,
        PRIMARY KEY (id, dataType)
      );
    ''');
  }

  Future<int> insertWatchlist(WatchlistTable movie) async {
    final db = await database;
    return await db!.insert(_tblWatchlist, movie.toJson());
  }

  Future<int> removeWatchlist(int id, int dataType) async {
    final db = await database;
    return await db!.delete(
      _tblWatchlist,
      // where: 'id = ?',
      where: 'id = ? and dataType = ?',
      // whereArgs: [movie.id],
      whereArgs: [id, dataType],
    );
  }

  Future<Map<String, dynamic>?> getMovieById(int id, int dataType) async {
    final db = await database;
    final results = await db!.query(
      _tblWatchlist,
      // where: 'id = ?',
      where: 'id = ? and dataType = ?',
      // whereArgs: [id],
      whereArgs: [id, dataType],
    );

    if (results.isNotEmpty) {
      return results.first;
    } else {
      return null;
    }
  }

  Future<List<Map<String, dynamic>>> getWatchlistMovies() async {
    final db = await database;
    final List<Map<String, dynamic>> results = await db!.query(_tblWatchlist);

    return results;
  }
}
