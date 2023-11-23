import 'dart:convert';
import 'dart:io';

import 'package:ditonton/common/exception.dart';
import 'package:ditonton/data/models/tv_detail_response_model.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:ditonton/data/models/tv_series_response_model.dart';
import 'package:http/io_client.dart';

abstract class TvRemoteDataSource {
  Future<List<ResultTvSeries>> getPopularTvSeries();
  Future<List<ResultTvSeries>> getOnTheAirTvSeries();
  Future<List<ResultTvSeries>> getTopRatedTvSeries();
  Future<List<ResultTvSeries>> searchTvSeries(String keyword);
  Future<TvDetailResponseModel> getTvSeriesDetail(int id);
  Future<List<ResultTvSeries>> getTvSeriesRecommendation(int id);
}

class TvRemoteDataSourceImpl extends TvRemoteDataSource {
  // ignore: constant_identifier_names
  static const API_KEY = 'api_key=2174d146bb9c0eab47529b2e77d6b526';
  // ignore: constant_identifier_names
  static const BASE_URL = 'https://api.themoviedb.org/3';

  final http.Client client;

  TvRemoteDataSourceImpl({required this.client});

  Future<SecurityContext> get globalContext async {
    final sslCert = await rootBundle.load('assets/certificates/SSLthemoviedb.pem');
    SecurityContext securityContext = SecurityContext(withTrustedRoots: false);
    securityContext.setTrustedCertificatesBytes(sslCert.buffer.asInt8List());
    return securityContext;
  }

  Future<IOClient> ioClientFunc() async {
    HttpClient client = HttpClient(context: await globalContext);
    client.badCertificateCallback = (X509Certificate cert, String host, int port) => false;
    IOClient ioClient = IOClient(client);
    return ioClient;
  }

  @override
  Future<List<ResultTvSeries>> getOnTheAirTvSeries() async {
    IOClient client = await ioClientFunc();
    final response = await client.get(Uri.parse('$BASE_URL/tv/on_the_air?$API_KEY'));

    if (response.statusCode == 200) {
      return TvSeriesResponseModel.fromJson(json.decode(response.body)).results!;
    } else {
      throw ServerException();
    }
  }

  @override
  Future<List<ResultTvSeries>> getPopularTvSeries() async {
    IOClient client = await ioClientFunc();
    final response = await client.get(Uri.parse('$BASE_URL/tv/popular?$API_KEY'));

    if (response.statusCode == 200) {
      return TvSeriesResponseModel.fromJson(json.decode(response.body)).results!;
    } else {
      throw ServerException();
    }
  }

  @override
  Future<List<ResultTvSeries>> getTopRatedTvSeries() async {
    IOClient client = await ioClientFunc();
    final response = await client.get(Uri.parse('$BASE_URL/tv/top_rated?$API_KEY'));

    if (response.statusCode == 200) {
      return TvSeriesResponseModel.fromJson(json.decode(response.body)).results!;
    } else {
      throw ServerException();
    }
  }

  @override
  Future<TvDetailResponseModel> getTvSeriesDetail(int id) async {
    IOClient client = await ioClientFunc();
    final response = await client.get(Uri.parse('$BASE_URL/tv/$id?$API_KEY'));

    if (response.statusCode == 200) {
      return TvDetailResponseModel.fromJson(json.decode(response.body));
    } else {
      throw ServerException();
    }
  }

  @override
  Future<List<ResultTvSeries>> getTvSeriesRecommendation(int id) async {
    IOClient client = await ioClientFunc();
    final response = await client.get(Uri.parse('$BASE_URL/tv/$id/recommendations?$API_KEY'));

    if (response.statusCode == 200) {
      return TvSeriesResponseModel.fromJson(json.decode(response.body)).results!;
    } else {
      throw ServerException();
    }
  }

  @override
  Future<List<ResultTvSeries>> searchTvSeries(String keyword) async {
    IOClient client = await ioClientFunc();
    final response = await client.get(Uri.parse('$BASE_URL/search/tv?$API_KEY&query=$keyword'));

    if (response.statusCode == 200) {
      return TvSeriesResponseModel.fromJson(json.decode(response.body)).results!;
    } else {
      throw ServerException();
    }
  }
}
