import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:numtrivia/core/errors/exceptions.dart';
import 'package:numtrivia/features/number_trivia/data/datasources/number_trivia_remote_data_source.dart';
import 'package:numtrivia/features/number_trivia/data/models/number_trivia_model.dart';

import '../../../../fixtures/fixture_reader.dart';
import 'number_trivia_remote_data_source_test.mocks.dart';

@GenerateMocks([http.Client])
void main() {
  late NumberTriviaRemoteDataSourceImpl remoteDataSource;
  late MockClient mockClient;

  setUp(() {
    mockClient = MockClient();
    remoteDataSource = NumberTriviaRemoteDataSourceImpl(mockClient);
  });

  const tNumber = 1;
  final tNumberTriviaModel =
      NumberTriviaModel.fromJson(jsonDecode(fixture('trivia.json')));

  void setUpMockHTTPClient200() {
    when(mockClient.get(any, headers: anyNamed('headers')))
        .thenAnswer((_) async => http.Response(fixture('trivia.json'), 200));
  }

  void setUpMockHTTPClient404() {
    when(mockClient.get(any, headers: anyNamed('headers')))
        .thenAnswer((_) async => http.Response('Something Went Wrong!', 404));
  }

  group('get concrete NumberTrivia', () {
    test('''should perform a GET request on a URL with number being
         endpoint and with application/json header''', () async {
      // arrange
      setUpMockHTTPClient200();
      // act
      await remoteDataSource.getConcreteNumberTrivia(tNumber);
      // assert
      verify(mockClient.get(Uri.parse('http://numbersapi.com/$tNumber'),
          headers: {'Content-Type': 'application/json'}));
    });

    test('should return NumberTriviaModel when response code is 200 (success)',
        () async {
      // arrange
      setUpMockHTTPClient200();
      // act
      final result = await remoteDataSource.getConcreteNumberTrivia(tNumber);
      // assert
      verify(mockClient.get(Uri.parse('http://numbersapi.com/$tNumber'),
          headers: {'Content-Type': 'application/json'}));
      expect(result, equals(tNumberTriviaModel));
    });

    test('should return ServerException when network call is unsuccessful',
        () async {
      // arrange
      setUpMockHTTPClient404();
      // act
      final call = remoteDataSource.getConcreteNumberTrivia(tNumber);
      // assert
      verify(mockClient.get(Uri.parse('http://numbersapi.com/$tNumber'),
          headers: {'Content-Type': 'application/json'}));
      expect(() => call, throwsA(const TypeMatcher<ServerException>()));
    });
  });

  group('get random NumberTrivia', () {
    test('''should perform a GET request on a URL with number being
         endpoint and with application/json header''', () async {
      // arrange
      setUpMockHTTPClient200();
      // act
      await remoteDataSource.getRandomNumberTrivia();
      // assert
      verify(mockClient.get(Uri.parse('http://numbersapi.com/random'),
          headers: {'Content-Type': 'application/json'}));
    });

    test('should return NumberTriviaModel when response code is 200 (success)',
        () async {
      // arrange
      setUpMockHTTPClient200();
      // act
      final result = await remoteDataSource.getRandomNumberTrivia();
      // assert
      verify(mockClient.get(Uri.parse('http://numbersapi.com/random'),
          headers: {'Content-Type': 'application/json'}));
      expect(result, equals(tNumberTriviaModel));
    });

    test('should return ServerException when network call is unsuccessful',
        () async {
      // arrange
      setUpMockHTTPClient404();
      // act
      final call = remoteDataSource.getRandomNumberTrivia;
      // assert
      expect(() => call(), throwsA(const TypeMatcher<ServerException>()));
    });
  });
}
