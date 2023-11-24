import 'dart:convert';

import 'package:ditonton/common/exception.dart';
import 'package:ditonton/common/firebase_analytics_service.dart';
import 'package:ditonton/data/models/tv_detail_response_model.dart';
import 'package:ditonton/common/http_custom_client.dart';
import 'package:ditonton/data/models/tv_series_response_model.dart';

abstract class TvRemoteDataSource {
  Future<List<ResultTvSeries>> getPopularTvSeries();
  Future<List<ResultTvSeries>> getOnTheAirTvSeries();
  Future<List<ResultTvSeries>> getTopRatedTvSeries();
  Future<List<ResultTvSeries>> searchTvSeries(String keyword);
  Future<TvDetailResponseModel> getTvSeriesDetail(int id);
  Future<TvDetailResponseModel> getTvSeriesDetailForTest(int id);
  Future<List<ResultTvSeries>> getTvSeriesRecommendation(int id);
}

class TvRemoteDataSourceImpl extends TvRemoteDataSource {
  // ignore: constant_identifier_names
  static const API_KEY = 'api_key=2174d146bb9c0eab47529b2e77d6b526';
  // ignore: constant_identifier_names
  static const BASE_URL = 'https://api.themoviedb.org/3';

  final HttpCustomClient client;

  TvRemoteDataSourceImpl({required this.client});

  @override
  Future<List<ResultTvSeries>> getOnTheAirTvSeries() async {
    final response = await client.get(Uri.parse('$BASE_URL/tv/on_the_air?$API_KEY'));

    if (response.statusCode == 200) {
      return TvSeriesResponseModel.fromJson(json.decode(response.body)).results!;
    } else {
      throw ServerException();
    }
  }

  @override
  Future<List<ResultTvSeries>> getPopularTvSeries() async {
    final response = await client.get(Uri.parse('$BASE_URL/tv/popular?$API_KEY'));

    if (response.statusCode == 200) {
      return TvSeriesResponseModel.fromJson(json.decode(response.body)).results!;
    } else {
      throw ServerException();
    }
  }

  @override
  Future<List<ResultTvSeries>> getTopRatedTvSeries() async {
    final response = await client.get(Uri.parse('$BASE_URL/tv/top_rated?$API_KEY'));

    if (response.statusCode == 200) {
      return TvSeriesResponseModel.fromJson(json.decode(response.body)).results!;
    } else {
      throw ServerException();
    }
  }

  @override
  Future<TvDetailResponseModel> getTvSeriesDetail(int id) async {
    final response = await client.get(Uri.parse('$BASE_URL/tv/$id?$API_KEY'));

    if (response.statusCode == 200) {
      TvDetailResponseModel dataMapping = TvDetailResponseModel.fromJson(json.decode(response.body));
      FirebaseAnalyticsService().sendAnalyticsEvent('getTvSeriesDetail', {
        'id': dataMapping.id,
        'name': dataMapping.name,
      });
      return dataMapping;
    } else {
      throw ServerException();
    }
  }

  @override
  Future<TvDetailResponseModel> getTvSeriesDetailForTest(int id) async {
    final response = await client.get(Uri.parse('$BASE_URL/tv/$id?$API_KEY'));

    if (response.statusCode == 200) {
      TvDetailResponseModel dataMapping = TvDetailResponseModel.fromJson(json.decode(response.body));
      return dataMapping;
    } else {
      throw ServerException();
    }
  }

  @override
  Future<List<ResultTvSeries>> getTvSeriesRecommendation(int id) async {
    final response = await client.get(Uri.parse('$BASE_URL/tv/$id/recommendations?$API_KEY'));

    if (response.statusCode == 200) {
      return TvSeriesResponseModel.fromJson(json.decode(response.body)).results!;
    } else {
      throw ServerException();
    }
  }

  @override
  Future<List<ResultTvSeries>> searchTvSeries(String keyword) async {
    final response = await client.get(Uri.parse('$BASE_URL/search/tv?$API_KEY&query=$keyword'));

    if (response.statusCode == 200) {
      return TvSeriesResponseModel.fromJson(json.decode(response.body)).results!;
    } else {
      throw ServerException();
    }
  }
}
