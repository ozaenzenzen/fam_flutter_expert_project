import 'package:cached_network_image/cached_network_image.dart';
import 'package:ditonton/common/constants.dart';
import 'package:ditonton/domain/entities/movie_detail_entity.dart';
import 'package:ditonton/domain/entities/poster_5_entity.dart';
import 'package:ditonton/presentation/widgets/poster_item_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../dummy_data/dummy_objects.dart';

void main() {
  Widget makeTestableWidget(Widget body) {
    return MaterialApp(
      home: Scaffold(
        body: body,
      ),
    );
  }

  const MovieDetailEntity movie = testMovieDetail;
  final Poster5Entity poster5Entity = Poster5Entity.fromMovieDetail(movie);
  final String imageUrl = '$baseImageUrl${poster5Entity.poster}';

  testWidgets(
    'PosterItemWidget should show right data',
    (WidgetTester tester) async {
      await tester.pumpWidget(makeTestableWidget(PosterItemWidget(poster5Entity)));

      expect(find.text(poster5Entity.overview), findsOneWidget);
      expect(find.text(poster5Entity.title), findsOneWidget);
      final image = find.byType(CachedNetworkImage).evaluate().single.widget as CachedNetworkImage;

      expect(image.imageUrl, imageUrl);
    },
  );
}
