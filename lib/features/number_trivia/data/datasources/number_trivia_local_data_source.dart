import 'dart:convert';

import 'package:numtrivia/core/errors/exceptions.dart';
import 'package:numtrivia/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class NumberTriviaLocalDataSource {
  /// Gets the cached [NumberTriviaModel] which was gotten the last time
  /// the user had an internet connection.
  ///
  /// Throws [CacheException] if no cached data is present.
  Future<NumberTriviaModel> getLastNumberTrivia();

  Future<void> cacheNumberTrivia(NumberTriviaModel model);
}

const cachedNumberTrivia = 'CACHED_NUMBER_TRIVIA';

class NumberTriviaLocalDataSourceImpl implements NumberTriviaLocalDataSource {
  SharedPreferences prefs;

  NumberTriviaLocalDataSourceImpl(this.prefs);

  @override
  Future<NumberTriviaModel> getLastNumberTrivia() {
    final cachedString = prefs.getString(cachedNumberTrivia);
    if (cachedString != null) {
      final numTrivia = NumberTriviaModel.fromJson(jsonDecode(cachedString));
      return Future.value(numTrivia);
    } else {
      throw CacheException();
    }
  }

  @override
  Future<bool> cacheNumberTrivia(NumberTriviaModel model) async {
    final numberTriviaJsonString = jsonEncode(model.toJson());
    return await prefs.setString(cachedNumberTrivia, numberTriviaJsonString);
  }
}
