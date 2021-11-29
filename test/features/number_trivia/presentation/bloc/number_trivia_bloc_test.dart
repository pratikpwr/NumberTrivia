import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:numtrivia/core/utils/input_convertor.dart';
import 'package:numtrivia/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:numtrivia/features/number_trivia/domain/usecases/get_concrete_number_trivia.dart';
import 'package:numtrivia/features/number_trivia/domain/usecases/get_random_number_trivia.dart';
import 'package:numtrivia/features/number_trivia/presentation/bloc/number_trivia_bloc.dart';

import 'number_trivia_bloc_test.mocks.dart';

@GenerateMocks([GetRandomNumberTrivia, GetConcreteNumberTrivia, InputConvertor])
void main() {
  MockGetRandomNumberTrivia mockRandomNT;
  MockGetConcreteNumberTrivia mockConcreteNT;
  late MockInputConvertor mockInputConvertor;
  late NumberTriviaBloc bloc;

  setUp(() {
    mockConcreteNT = MockGetConcreteNumberTrivia();
    mockRandomNT = MockGetRandomNumberTrivia();
    mockInputConvertor = MockInputConvertor();
    bloc = NumberTriviaBloc(
        randomNT: mockRandomNT,
        concreteNT: mockConcreteNT,
        inputConvertor: mockInputConvertor);
  });

  test('initial test should be empty', () {
    // assert
    expect(bloc.state, equals(Empty()));
  });

  group('get concrete number trivia', () {
    const tNumberString = '1';
    const tNumberParsed = 1;
    const tNumberTrivia = NumberTrivia(text: 'Test', number: tNumberParsed);

    test('should call InputConvertor to validate and convert string to int',
        () async {
      // arrange
      when(mockInputConvertor.stringToUnsignedInteger(any))
          .thenReturn(const Right(1));
      // act
      bloc.add(const GetTriviaForConcreteNumber(tNumberString));
      // bloc takes times to perform so we can use below
      await untilCalled(mockInputConvertor.stringToUnsignedInteger(any));
      // assert
      verify(mockInputConvertor.stringToUnsignedInteger(tNumberString));
    });

    test('should emit [Error] when input is invalid', () async {
      // arrange
      when(mockInputConvertor.stringToUnsignedInteger(any))
          .thenReturn(Left(InvalidInputFailure()));

      // act
      bloc.add(const GetTriviaForConcreteNumber(tNumberString));
      // assert later
      final expectedStates = [Empty(), const Error(message: invalidInput)];
      expectLater(bloc.state, emitsInOrder(expectedStates));
    });
  });
}
