import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:numtrivia/core/errors/exceptions.dart';
import 'package:numtrivia/features/number_trivia/data/datasources/number_trivia_local_data_source.dart';
import 'package:numtrivia/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../fixtures/fixture_reader.dart';
import 'number_trivia_local_data_source_test.mocks.dart';

@GenerateMocks([SharedPreferences])
void main() {
  late MockSharedPreferences mockSharedPrefs;
  late NumberTriviaLocalDataSourceImpl localDataSource;

  setUp(() {
    mockSharedPrefs = MockSharedPreferences();
    localDataSource = NumberTriviaLocalDataSourceImpl(mockSharedPrefs);
  });

  group('get last Number Trivia', () {
    test('should return NumberTriviaModel from prefs when there is cached',
        () async {
      final tNumberTriviaModel =
          NumberTriviaModel.fromJson(jsonDecode(fixture('trivia_cached.json')));
      // arrange
      when(mockSharedPrefs.getString(any))
          .thenReturn(fixture('trivia_cached.json'));
      // act
      final result = await localDataSource.getLastNumberTrivia();
      // assert
      verify(mockSharedPrefs.getString(cachedNumberTrivia));
      expect(result, tNumberTriviaModel);
    });

    test('should throw CachedException when there is no cached', () async {
      // arrange
      when(mockSharedPrefs.getString(any)).thenReturn(null);
      // act
      final call = localDataSource.getLastNumberTrivia;
      // assert
      expect(() => call(), throwsA(const TypeMatcher<CacheException>()));
    });
  });

  group('cache NumberTrivia', () {
    const tNumberTriviaModel = NumberTriviaModel(text: 'Test', number: 1);
    final jsonString = jsonEncode(tNumberTriviaModel.toJson());
    test('should called sharedPrefs to cache the data', () async {
      // arrange
      // resoCoder didn't use arrange part
      // I have to use it because it generates stub error
      when(mockSharedPrefs.setString(cachedNumberTrivia, jsonString))
          .thenAnswer((_) async => true);
      // act
      await localDataSource.cacheNumberTrivia(tNumberTriviaModel);
      // assert
      verify(mockSharedPrefs.setString(cachedNumberTrivia, jsonString));
    });
  });
}
