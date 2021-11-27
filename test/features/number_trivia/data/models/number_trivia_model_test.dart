import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:numtrivia/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:numtrivia/features/number_trivia/domain/entities/number_trivia.dart';

import '../../../../fixtures/fixture_reader.dart';

void main() {
  const tNumberTriviaModel = NumberTriviaModel(number: 1, text: 'Test');

  test('should be subclass of NumberTrivia entity', () {
    //assert
    expect(tNumberTriviaModel, isA<NumberTrivia>());
  });

  group('fromJson', () {
    test('should return a valid model when JSON number is Integer', () async {
      // arrange
      Map<String, dynamic> jsonMap = json.decode(fixture('trivia.json'));
      // act
      final result = NumberTriviaModel.fromJson(jsonMap);
      // assert
      expect(result, tNumberTriviaModel);
    });
    test('should return a valid model when JSON number is regarded as Double',
        () async {
      // arrange
      Map<String, dynamic> jsonMap = json.decode(fixture('trivia_double.json'));
      // act
      final result = NumberTriviaModel.fromJson(jsonMap);
      // assert
      expect(result, tNumberTriviaModel);
    });
  });

  group('toJson', () {
    test('should return a Json Map containing proper data', () async {
      //assert
      Map<String, dynamic> jsonMap = {
        "text": "Test",
        "number": 1,
      };
      // act
      final result = tNumberTriviaModel.toJson();
      // assert
      expect(result, jsonMap);
    });
  });
}
