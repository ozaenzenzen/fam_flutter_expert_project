import 'package:ditonton/domain/entities/poster_3_entity.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../dummy_data/dummy_objects.dart';

void main() {
  final testPoster3EntityFromPoster5Entity = Poster3Entity.fromPoster5Entity(testPoster5EntityBaseData);

  group("test poster 3 entity", () {
    test('should get Poster3Entity from the fromPoster5Entity', () async {
      final result = testPoster3EntityFromPoster5Entity;
      expect(testPoster3EntityFromPoster5Entity.toString(), result.toString());
    });
  });
}
