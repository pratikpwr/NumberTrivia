import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:numtrivia/core/errors/failures.dart';
import 'package:numtrivia/core/usecases/usecase.dart';
import 'package:numtrivia/core/utils/input_convertor.dart';

import 'package:numtrivia/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:numtrivia/features/number_trivia/domain/usecases/get_concrete_number_trivia.dart';
import 'package:numtrivia/features/number_trivia/domain/usecases/get_random_number_trivia.dart';

part 'number_trivia_event.dart';

part 'number_trivia_state.dart';

const serverFailure = 'Server Failure';
const cacheFailure = 'CacheFailure';
const invalidInput =
    'Invalid Input - number must be a positive integer or zero.';

class NumberTriviaBloc extends Bloc<NumberTriviaEvent, NumberTriviaState> {
  final GetConcreteNumberTrivia concreteNT;
  final GetRandomNumberTrivia randomNT;
  final InputConvertor inputConvertor;

  NumberTriviaBloc(
      {required this.randomNT,
      required this.concreteNT,
      required this.inputConvertor})
      : super(Empty()) {
    on<GetTriviaForConcreteNumber>(_onGetTriviaForConcreteNumber);
    on<GetTriviaForRandomNumber>(_onGetTriviaForRandomNumber);
  }

  void _onGetTriviaForConcreteNumber(
    GetTriviaForConcreteNumber event,
    Emitter<NumberTriviaState> emit,
  ) {
    if (event.numberString == null) {
      emit(const Error(message: invalidInput));
    }
    final inputEither =
        inputConvertor.stringToUnsignedInteger(event.numberString!);

    inputEither.fold(
      (failure) => emit(const Error(message: invalidInput)),
      (integer) async {
        emit(Loading());

        final failureOrTrivia = await concreteNT(Params(number: integer));

        failureOrTrivia.fold(
          (failure) => emit(Error(message: _mapFailureToMessage(failure))),
          (trivia) => emit(Success(trivia: trivia)),
        );
      },
    );
  }

  void _onGetTriviaForRandomNumber(
    GetTriviaForRandomNumber event,
    Emitter<NumberTriviaState> emit,
  ) async {
    emit(Loading());

    final failureOrTrivia = await randomNT(NoParams());

    failureOrTrivia.fold(
      (failure) => emit(Error(message: _mapFailureToMessage(failure))),
      (trivia) => emit(Success(trivia: trivia)),
    );
  }

  String _mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case ServerFailure:
        return serverFailure;
      case CacheFailure:
        return cacheFailure;
      default:
        return 'Unexpected Error';
    }
  }
}
