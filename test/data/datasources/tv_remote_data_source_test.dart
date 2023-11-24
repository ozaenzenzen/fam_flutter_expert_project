import 'dart:io';

import 'package:ditonton/common/exception.dart';
import 'package:ditonton/data/datasources/tv_remote_data_source.dart';
import 'package:ditonton/data/models/tv_detail_response_model.dart';
import 'package:ditonton/data/models/tv_series_response_model.dart';
import 'package:ditonton/domain/entities/tvseries_entity.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:mockito/mockito.dart';

import '../../helpers/test_helper.mocks.dart';
import '../../json_reader.dart';

void main() {
  late TvRemoteDataSource dataSource;
  late MockHttpClient client;
  // ignore: constant_identifier_names
  const API_KEY = 'api_key=2174d146bb9c0eab47529b2e77d6b526';
  // ignore: constant_identifier_names
  const BASE_URL = 'https://api.themoviedb.org/3';

  const String urlPopularTvSeries = '$BASE_URL/tv/popular?$API_KEY';
  const String urlOnTheAirTvSeries = '$BASE_URL/tv/on_the_air?$API_KEY';
  const String urlTopRatedTvSeries = '$BASE_URL/tv/top_rated?$API_KEY';

  setUp(() async {
    // TestWidgetsFlutterBinding.ensureInitialized();
    // await Firebase.initializeApp();
    client = MockHttpClient();
    dataSource = TvRemoteDataSourceImpl(client: client);
  });

  void arrangeApiCall(Uri uri, String response, int statusCode) {
    when(client.get(uri)).thenAnswer(
      (_) async => http.Response(
        response,
        statusCode,
        headers: {
          HttpHeaders.contentTypeHeader: 'application/json; charset=utf-8',
        },
      ),
    );
  }

  group('get popular tv action', () {
    const String dummyTvPopular = 'dummy_data/tvseries/tv_popular.json';
    final decoded = json.decode(readJson(dummyTvPopular));
    // final TvSeriesResponseModel tSerialTvList = TvSeriesResponseModel.fromJson(decoded);
    final List<TvSeriesEntity> tSerialTvList = TvSeriesResponseModel.fromJson(decoded).toEntity();

    test("should return class of Tv Response Model when the response code is 200", () async {
      //arrange
      const mockPath = dummyTvPopular;
      final matcher = tSerialTvList;

      const url = urlPopularTvSeries;
      final uri = Uri.parse(url);
      final response = readJson(mockPath);
      const statusCode = 200;

      arrangeApiCall(uri, response, statusCode);

      //act
      final actual = await dataSource.getPopularTvSeries();

      //assert
      expect(actual.map((e) => e.toEntity()).toList(), matcher);
    });

    test("should throw ServerException when the response code is not 200", () async {
      //arrange
      const mockPath = dummyTvPopular;
      final matcher = throwsA(isA<ServerException>());

      const url = urlPopularTvSeries;
      final uri = Uri.parse(url);
      final response = readJson(mockPath);

      arrangeApiCall(uri, response, 500);

      //act
      // ignore: prefer_function_declarations_over_variables
      final actual500 = () => dataSource.getPopularTvSeries();

      //assert
      expect(actual500, matcher);

      //arrange
      arrangeApiCall(uri, response, 404);

      //act
      // ignore: prefer_function_declarations_over_variables
      final actual404 = () => dataSource.getPopularTvSeries();

      //assert
      expect(actual404, matcher);
    });
  });

  group('get top rated tv series action', () {
    const dummyTvTopRated = 'dummy_data/tvseries/tv_top_rated.json';
    final decoded = json.decode(readJson(dummyTvTopRated));
    // final tSerialTvList = TvSeriesResponseModel.fromJson(decoded);
    final List<TvSeriesEntity> tSerialTvList = TvSeriesResponseModel.fromJson(decoded).toEntity();

    test("should return Top Rated Tv Series when the response code is 200", () async {
      //arrange
      const mockPath = dummyTvTopRated;
      final matcher = tSerialTvList;

      const url = urlTopRatedTvSeries;
      final uri = Uri.parse(url);
      final response = readJson(mockPath);
      const statusCode = 200;

      arrangeApiCall(uri, response, statusCode);

      //act
      final actual = await dataSource.getTopRatedTvSeries();

      //assert
      expect(actual.map((e) => e.toEntity()).toList(), matcher);
    });

    test("should throw ServerException when the response code is not 200", () async {
      //arrange
      const mockPath = dummyTvTopRated;
      final matcher = throwsA(isA<ServerException>());

      const url = urlTopRatedTvSeries;
      final uri = Uri.parse(url);
      final response = readJson(mockPath);

      arrangeApiCall(uri, response, 500);

      //act
      actual() => dataSource.getTopRatedTvSeries();

      //assert
      expect(actual, matcher);

      //arrange
      arrangeApiCall(uri, response, 404);

      actual404() => dataSource.getTopRatedTvSeries();

      expect(actual404, matcher);
    });
  });

  group('get on the air tv series action', () {
    const dummyTvOnTheAir = 'dummy_data/tvseries/tv_on_the_air.json';
    final decoded = json.decode(readJson(dummyTvOnTheAir));
    // final tSearialTvList = TvSeriesResponseModel.fromJson(decoded);
    final List<TvSeriesEntity> tSerialTvList = TvSeriesResponseModel.fromJson(decoded).toEntity();

    test("should return List of Tv when the response code is 200", () async {
      //arrange
      const mockPath = dummyTvOnTheAir;
      final matcher = tSerialTvList;

      const url = urlOnTheAirTvSeries;
      final uri = Uri.parse(url);
      final response = readJson(mockPath);
      const statusCode = 200;

      arrangeApiCall(uri, response, statusCode);

      //act
      final actual = await dataSource.getOnTheAirTvSeries();

      //assert
      expect(actual.map((e) => e.toEntity()).toList(), matcher);
    });

    test("should throw ServerException when the response code is not 200", () async {
      //arrange
      const mockPath = dummyTvOnTheAir;
      final matcher = throwsA(isA<ServerException>());

      const url = urlOnTheAirTvSeries;
      final uri = Uri.parse(url);
      final response = readJson(mockPath);

      arrangeApiCall(uri, response, 500);

      //act
      actual() => dataSource.getOnTheAirTvSeries();

      //assert
      expect(actual, matcher);

      //arrange
      arrangeApiCall(uri, response, 404);

      actual404() => dataSource.getOnTheAirTvSeries();

      expect(actual404, matcher);
    });
  });

  group('search tv series action', () {
    const dummySearchTvSeries = 'dummy_data/tvseries/search_phoenix_tv_series.json';
    final decoded = json.decode(readJson(dummySearchTvSeries));

    final List<TvSeriesEntity> tSerialTvList = TvSeriesResponseModel.fromJson(decoded).toEntity();
    // final tSerialTvList = TvSeriesResponseModel.fromJson(decoded);
    const tQuery = 'phoenix';

    // final url = TvRemoteDataSourceImpl.generateUrlTvSeries(tQuery);
    const url = '$BASE_URL/search/tv?$API_KEY&query=$tQuery';
    final uri = Uri.parse(url);

    test('should return list of tv series when response code is 200', () async {
      const mockPath = dummySearchTvSeries;
      final matcher = tSerialTvList;

      final response = readJson(mockPath);
      const statusCode = 200;
      // arrange

      arrangeApiCall(uri, response, statusCode);

      // act
      final result = await dataSource.searchTvSeries(tQuery);
      // assert
      expect(result.map((e) => e.toEntity()).toList(), matcher);
    });

    test('should throw ServerException when response code is other than 200', () async {
      // arrange
      const response = 'Not found';
      const statusCode = 404;

      arrangeApiCall(uri, response, statusCode);
      // act
      final call = dataSource.searchTvSeries(tQuery);
      // assert
      expect(() => call, throwsA(isA<ServerException>()));
    });
  });

  group('get tv detail action', () {
    const int testId = 93842;
    final String response = readJson('dummy_data/tvseries/tv_detail.json');
    final TvDetailResponseModel tTvDetail = TvDetailResponseModel.fromJson(json.decode(response));
    const String url = '$BASE_URL/tv/$testId?$API_KEY';
    final Uri uri = Uri.parse(url);

    test('should return tv detail when the response code is 200', () async {
      // arrange
      const statusCode = 200;

      arrangeApiCall(uri, response, statusCode);
      // act
      final result = await dataSource.getTvSeriesDetail(testId);
      // assert
      expect(result.toJson(), tTvDetail.toJson());
    });

    test('should throw Server Exception when the response code is 404 or other', () async {
      // arrange
      const statusCode = 404;

      arrangeApiCall(uri, response, statusCode);
      // act
      final call = dataSource.getTvSeriesDetail(testId);
      // assert
      expect(() => call, throwsA(isA<ServerException>()));
    });
  });

  group('get tv series recommendations action', () {
    const int testId = 213713;
    final data = readJson('dummy_data/tvseries/tv_recommendations.json');
    // final tTvRecommendation = TvSeriesResponseModel.fromJson(json.decode(data));
    final List<TvSeriesEntity> tTvRecommendation = TvSeriesResponseModel.fromJson(jsonDecode(data)).toEntity();
    const String url = '$BASE_URL/tv/$testId/recommendations?$API_KEY';
    final uri = Uri.parse(url);

    test('should return list of Movie Model when the response code is 200', () async {
      // arrange
      final response = data;
      const statusCode = 200;
      arrangeApiCall(uri, response, statusCode);
      // act
      final result = await dataSource.getTvSeriesRecommendation(testId);
      // assert
      expect(result.map((e) => e.toEntity()).toList(), tTvRecommendation);
    });

    test('should throw Server Exception when the response code is 404 or other', () async {
      // arrange
      const response = 'Not Found';
      const statusCode = 404;
      arrangeApiCall(uri, response, statusCode);
      // act
      final call = dataSource.getTvSeriesRecommendation(testId);
      // assert
      expect(() => call, throwsA(isA<ServerException>()));
    });
  });
}
