import 'dart:convert';

import 'package:ditonton/common/exception.dart';
import 'package:ditonton/data/models/tv_detail_response_model.dart';
import 'package:http/http.dart' as http;
import 'package:ditonton/data/models/tv_series_response_model.dart';

abstract class TvRemoteDataSource {
  Future<TvSeriesResponseModel> getPopularTvSeries();
  Future<TvSeriesResponseModel> getOnTheAirTvSeries();
  Future<TvSeriesResponseModel> getTopRatedTvSeries();
  Future<TvSeriesResponseModel> searchTvSeries(String keyword);
  Future<TvDetailResponseModel> getTvSeriesDetail(int id);
  Future<TvSeriesResponseModel> getTvSeriesRecommendation(int id);
}

class TvRemoteDataSourceImpl extends TvRemoteDataSource {
  // ignore: constant_identifier_names
  static const API_KEY = 'api_key=2174d146bb9c0eab47529b2e77d6b526';
  // ignore: constant_identifier_names
  static const BASE_URL = 'https://api.themoviedb.org/3';

  final http.Client client;

  TvRemoteDataSourceImpl({required this.client});

  @override
  Future<TvSeriesResponseModel> getOnTheAirTvSeries() async {
    final response = await client.get(Uri.parse('$BASE_URL/tv/on_the_air?$API_KEY'));

    if (response.statusCode == 200) {
      return TvSeriesResponseModel.fromJson(json.decode(response.body));
    } else {
      throw ServerException();
    }
  }

  @override
  Future<TvSeriesResponseModel> getPopularTvSeries() async {
    final response = await client.get(Uri.parse('$BASE_URL/tv/popular?$API_KEY'));

    if (response.statusCode == 200) {
      return TvSeriesResponseModel.fromJson(json.decode(response.body));
    } else {
      throw ServerException();
    }
  }

  @override
  Future<TvSeriesResponseModel> getTopRatedTvSeries() async {
    final response = await client.get(Uri.parse('$BASE_URL/tv/top_rated?$API_KEY'));

    if (response.statusCode == 200) {
      return TvSeriesResponseModel.fromJson(json.decode(response.body));
    } else {
      throw ServerException();
    }
  }

  @override
  Future<TvDetailResponseModel> getTvSeriesDetail(int id) async {
    final response = await client.get(Uri.parse('$BASE_URL/tv/$id?$API_KEY'));

    if (response.statusCode == 200) {
      return TvDetailResponseModel.fromJson(json.decode(response.body));
    } else {
      throw ServerException();
    }
  }

  @override
  Future<TvSeriesResponseModel> getTvSeriesRecommendation(int id) async {
    final response = await client.get(Uri.parse('$BASE_URL/tv/$id/recommendations?$API_KEY'));

    if (response.statusCode == 200) {
      return TvSeriesResponseModel.fromJson(json.decode(response.body));
    } else {
      throw ServerException();
    }
  }

  @override
  Future<TvSeriesResponseModel> searchTvSeries(String keyword) async {
    final response = await client.get(Uri.parse('$BASE_URL/search/tv?$API_KEY&query=$keyword'));

    if (response.statusCode == 200) {
      return TvSeriesResponseModel.fromJson(json.decode(response.body));
    } else {
      throw ServerException();
    }
  }
}
