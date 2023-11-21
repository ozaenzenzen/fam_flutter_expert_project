import 'package:ditonton/common/enum/enum_data_type.dart';
import 'package:ditonton/domain/entities/item_data_entity.dart';
import 'package:ditonton/domain/entities/movie_entity.dart';
import 'package:ditonton/domain/entities/movie_detail_entity.dart';
import 'package:ditonton/domain/entities/poster_5_entity.dart';
import 'package:equatable/equatable.dart';

class WatchlistTable extends Equatable {
  final int id;
  final String? title;
  final String? posterPath;
  final String? overview;
  final int dataType;

  const WatchlistTable({
    required this.id,
    required this.title,
    required this.posterPath,
    required this.overview,
    required this.dataType,
  });

  factory WatchlistTable.fromMovieDetail(MovieDetailEntity movie) => WatchlistTable(
        id: movie.id,
        title: movie.title,
        posterPath: movie.posterPath,
        overview: movie.overview,
        dataType: DataType.movie.index,
      );

  factory WatchlistTable.fromMap(Map<String, dynamic> map) => WatchlistTable(
        id: map['id'],
        title: map['title'],
        posterPath: map['posterPath'],
        overview: map['overview'],
        dataType: map['dataType'],
      );

  factory WatchlistTable.fromContentData(ItemDataEntity data) => WatchlistTable(
        id: data.id,
        title: data.title,
        posterPath: data.posterPath,
        overview: data.overview,
        dataType: data.dataType.index,
      );

  factory WatchlistTable.fromPoster5Entity(Poster5Entity poster5Entity) => WatchlistTable(
        id: poster5Entity.id,
        title: poster5Entity.title,
        posterPath: poster5Entity.poster,
        overview: poster5Entity.overview,
        dataType: poster5Entity.dataType.index,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'posterPath': posterPath,
        'overview': overview,
        'dataType': dataType,
      };

  MovieEntity toEntity() => MovieEntity.watchlist(
        id: id,
        overview: overview,
        posterPath: posterPath,
        title: title,
      );

  Poster5Entity toPoster5Entity() => Poster5Entity(
        id: id,
        poster: posterPath ?? "",
        title: title ?? "No Title",
        overview: overview ?? "No Overview",
        dataType: dataType == DataType.tvSeries.index ? DataType.tvSeries : DataType.movie,
      );

  @override
  List<Object?> get props => [
        id,
        title,
        posterPath,
        overview,
        dataType,
      ];
}
