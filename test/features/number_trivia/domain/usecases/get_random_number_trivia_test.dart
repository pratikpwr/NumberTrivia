import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:numtrivia/core/usecases/usecase.dart';
import 'package:numtrivia/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:numtrivia/features/number_trivia/domain/repositories/number_trivia_repository.dart';
import 'package:numtrivia/features/number_trivia/domain/usecases/get_random_number_trivia.dart';

import 'get_concrete_number_trivia_test.mocks.dart';

@GenerateMocks([NumberTriviaRepository])
void main() {
  late MockNumberTriviaRepository repository;
  late GetRandomNumberTrivia useCase;

  setUp(() {
    repository = MockNumberTriviaRepository();
    useCase = GetRandomNumberTrivia(repository);
  });

  const randomTrivia = NumberTrivia(text: 'test', number: 2);

  test('should get random number trivia from the repository', () async {
    // arrange
    when(repository.getRandomNumberTrivia())
        .thenAnswer((_) async => const Right(randomTrivia));

    // act
    final result = await useCase(NoParams());

    // assert
    expect(result, const Right(randomTrivia));
    verify(repository.getRandomNumberTrivia());
    verifyNoMoreInteractions(repository);
  });
}
