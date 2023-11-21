import 'package:dartz/dartz.dart';
import 'package:ditonton/domain/repositories/tv_series_repository.dart';
import 'package:ditonton/domain/usecases/get_tv_series_detail.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../dummy_data/dummy_objects.dart';
import '../../../helpers/test_helper.mocks.dart';

void main() {
  late GetTvSeriesDetail usecase;
  late TvSeriesRepository repository;

  setUp(() {
    repository = MockTvSeriesRepository();
    usecase = GetTvSeriesDetail(repository);
  });

  final testId = testTvDetail.id;

  test('should get tv series detail from the repository', () async {
    // arrange
    final response = testTvDetail;

    when(repository.getTvSeriesDetail(testId!)).thenAnswer((_) async => Right(response));
    // act
    final result = await usecase.execute(testId);
    // assert
    expect(result, Right(response));
  });
}
