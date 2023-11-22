import 'dart:convert';

import 'package:ditonton/domain/entities/genre_entity.dart';
import 'package:flutter_test/flutter_test.dart';
import '../../json_reader.dart';

void main() {
  final String response = readJson('dummy_data/tvseries/tv_detail.json');
  //From manual mapping
  final Map<String, dynamic> maping = jsonDecode(response);
  final Map<String, dynamic> mappingDataIdAndName = {
    "id" : maping["id"],
    "name" : maping["name"],
  };

  //From object mapping
  final result = GenreEntity.fromJson(jsonDecode(response));

  group("test genre entity all", () {
    test('should get GenreEntity FromJson and toJson', () async {
      expect(jsonEncode(mappingDataIdAndName), jsonEncode(result.toJson()));
    });
  });
}
