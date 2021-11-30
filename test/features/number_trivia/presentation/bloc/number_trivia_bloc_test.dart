import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:numtrivia/core/errors/failures.dart';
import 'package:numtrivia/core/usecases/usecase.dart';
import 'package:numtrivia/core/utils/input_convertor.dart';
import 'package:numtrivia/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:numtrivia/features/number_trivia/domain/usecases/get_concrete_number_trivia.dart';
import 'package:numtrivia/features/number_trivia/domain/usecases/get_random_number_trivia.dart';
import 'package:numtrivia/features/number_trivia/presentation/bloc/number_trivia_bloc.dart';

import 'number_trivia_bloc_test.mocks.dart';

@GenerateMocks([GetRandomNumberTrivia, GetConcreteNumberTrivia, InputConvertor])
void main() {
  late MockGetRandomNumberTrivia mockRandomNT;
  late MockGetConcreteNumberTrivia mockConcreteNT;
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

  const tNumberString = '1';
  const tNumberParsed = 1;
  const tNumberTrivia = NumberTrivia(text: 'Test', number: tNumberParsed);

  void setUpMockInputConvertor() =>
      when(mockInputConvertor.stringToUnsignedInteger(any))
          .thenReturn(const Right(tNumberParsed));

  test('initial test should be empty', () {
    // assert
    expect(bloc.state, equals(Empty()));
  });

  group('get concrete number trivia', () {
    test('should call InputConvertor to validate and convert string to int',
        () async {
      // arrange
      setUpMockInputConvertor();
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
      bloc.add(const GetTriviaForConcreteNumber('ada'));
      // assert later

      final expectedStates = [const Error(message: invalidInput)];
      expectLater(bloc.stream, emitsInOrder(expectedStates));
    });

    test('should get data from concrete use case', () async {
      // arrange
      setUpMockInputConvertor();
      when(mockConcreteNT(any))
          .thenAnswer((_) async => const Right(tNumberTrivia));
      // act
      bloc.add(const GetTriviaForConcreteNumber(tNumberString));
      await untilCalled(mockConcreteNT(any));
      // assert
      verify(mockConcreteNT(const Params(number: tNumberParsed)));
    });

    test('should emit [Loading, Success] when data is getting successfully',
        () async {
      // arrange
      setUpMockInputConvertor();
      when(mockConcreteNT(any))
          .thenAnswer((_) async => const Right(tNumberTrivia));
      // assert later
      final expectedStates = [
        // Empty(),
        Loading(),
        const Success(trivia: tNumberTrivia)
      ];
      expectLater(bloc.stream, emitsInOrder(expectedStates));
      // act
      bloc.add(const GetTriviaForConcreteNumber(tNumberString));
    });

    test('should emit [Loading, Error] when getting data is unsuccessful',
        () async {
      // arrange
      setUpMockInputConvertor();
      when(mockConcreteNT(any)).thenAnswer((_) async => Left(ServerFailure()));
      // assert later
      final expectedStates = [
        Loading(),
        const Error(message: serverFailure),
      ];
      expectLater(bloc.stream, emitsInOrder(expectedStates));
      // act
      bloc.add(const GetTriviaForConcreteNumber(tNumberString));
    });

    test('should emit [Loading, Error] with proper message for the error',
        () async {
      // arrange
      setUpMockInputConvertor();
      when(mockConcreteNT(any)).thenAnswer((_) async => Left(CacheFailure()));
      // assert later
      final expectedStates = [
        Loading(),
        const Error(message: cacheFailure),
      ];
      expectLater(bloc.stream, emitsInOrder(expectedStates));
      // act
      bloc.add(const GetTriviaForConcreteNumber(tNumberString));
    });
  });

  group('get random number trivia', () {
    test('should get data from random use case', () async {
      // arrange
      setUpMockInputConvertor();
      when(mockRandomNT(any))
          .thenAnswer((_) async => const Right(tNumberTrivia));
      // act
      bloc.add(GetTriviaForRandomNumber());
      await untilCalled(mockRandomNT(any));
      // assert
      verify(mockRandomNT(NoParams()));
    });

    test('should emit [Loading, Success] when data is getting successfully',
        () async {
      // arrange
      setUpMockInputConvertor();
      when(mockRandomNT(any))
          .thenAnswer((_) async => const Right(tNumberTrivia));
      // assert later
      final expectedStates = [
        // Empty(),
        Loading(),
        const Success(trivia: tNumberTrivia)
      ];
      expectLater(bloc.stream, emitsInOrder(expectedStates));
      // act
      bloc.add(GetTriviaForRandomNumber());
    });

    test('should emit [Loading, Error] when getting data is unsuccessful',
        () async {
      // arrange
      setUpMockInputConvertor();
      when(mockRandomNT(any)).thenAnswer((_) async => Left(ServerFailure()));
      // assert later
      final expectedStates = [
        Loading(),
        const Error(message: serverFailure),
      ];
      expectLater(bloc.stream, emitsInOrder(expectedStates));
      // act
      bloc.add(GetTriviaForRandomNumber());
    });

    test('should emit [Loading, Error] with proper message for the error',
        () async {
      // arrange
      setUpMockInputConvertor();
      when(mockRandomNT(any)).thenAnswer((_) async => Left(CacheFailure()));
      // assert later
      final expectedStates = [
        Loading(),
        const Error(message: cacheFailure),
      ];
      expectLater(bloc.stream, emitsInOrder(expectedStates));
      // act
      bloc.add(GetTriviaForRandomNumber());
    });
  });
}
