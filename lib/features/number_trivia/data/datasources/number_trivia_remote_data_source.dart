// this will be like NumberTrivia Repository but will have exceptions
// rather than failures
import 'dart:convert';

import 'package:numtrivia/core/errors/exceptions.dart';
import 'package:numtrivia/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:http/http.dart' as http;

abstract class NumberTriviaRemoteDataSource {
  /// Calls the http://numbersapi.com/{number} endpoint.
  ///
  /// Throws a [ServerException] for all error codes.
  Future<NumberTriviaModel> getConcreteNumberTrivia(int number);

  /// Calls the http://numbersapi.com/random endpoint.
  ///
  /// Throws a [ServerException] for all error codes.
  Future<NumberTriviaModel> getRandomNumberTrivia();
}

class NumberTriviaRemoteDataSourceImpl implements NumberTriviaRemoteDataSource {
  http.Client client;

  NumberTriviaRemoteDataSourceImpl(this.client);

  static const baseUrl = 'http://numbersapi.com';

  @override
  Future<NumberTriviaModel> getConcreteNumberTrivia(int number) =>
      _getNumberTrivia('$baseUrl/$number');

  @override
  Future<NumberTriviaModel> getRandomNumberTrivia() =>
      _getNumberTrivia('$baseUrl/random');

  Future<NumberTriviaModel> _getNumberTrivia(String url) async {
    try {
      final response = await client
          .get(Uri.parse(url), headers: {'Content-Type': 'application/json'});
      if (response.statusCode == 200) {
        final numTrivia = NumberTriviaModel.fromJson(jsonDecode(response.body));
        return numTrivia;
      } else {
        throw ServerException();
      }
    } on ServerException {
      throw ServerException();
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
