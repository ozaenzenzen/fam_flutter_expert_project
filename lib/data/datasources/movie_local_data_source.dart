import 'package:ditonton/common/exception.dart';
import 'package:ditonton/data/datasources/db/database_helper.dart';
import 'package:ditonton/data/models/watchlist_table.dart';

abstract class WatchlistLocalDataSource {
  Future<String> insertWatchlist(WatchlistTable movie);
  Future<String> removeWatchlist(int id, int dataType);
  Future<WatchlistTable?> getMovieById(int id, int dataType);
  Future<List<WatchlistTable>> getWatchlistMovies();
}

class WatchlistLocalDataSourceImpl implements WatchlistLocalDataSource {
  final DatabaseHelper databaseHelper;

  WatchlistLocalDataSourceImpl({required this.databaseHelper});

  @override
  Future<String> insertWatchlist(WatchlistTable tv) async {
    try {
      await databaseHelper.insertWatchlist(tv);
      return 'Added to Watchlist';
    } catch (e) {
      throw DatabaseException(e.toString());
    }
  }

  @override
  Future<String> removeWatchlist(int id, int dataType) async {
    try {
      await databaseHelper.removeWatchlist(id, dataType);
      return 'Removed from Watchlist';
    } catch (e) {
      throw DatabaseException(e.toString());
    }
  }

  @override
  Future<WatchlistTable?> getMovieById(int id, int dataType) async {
    final result = await databaseHelper.getMovieById(id, dataType);
    if (result != null) {
      return WatchlistTable.fromMap(result);
    } else {
      return null;
    }
  }

  @override
  Future<List<WatchlistTable>> getWatchlistMovies() async {
    List<WatchlistTable> dataWatchlist = [];
    try {
      final result = await databaseHelper.getWatchlistMovies();
      dataWatchlist = result.map((data) {
        return WatchlistTable.fromMap(data);
      }).toList();
      return dataWatchlist;
    } catch (e) {
      return dataWatchlist;
    }
  }
}
