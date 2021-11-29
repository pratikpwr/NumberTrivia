import 'package:dartz/dartz.dart';
import 'package:numtrivia/core/errors/failures.dart';

class InputConvertor {
  Either<Failure, int> stringToUnsignedInteger(String str) {
    try {
      final number = int.tryParse(str);
      if (number != null && number >= 0) {
        return Right(number);
      } else {
        throw const FormatException();
      }
    } on FormatException {
      return Left(InvalidInputFailure());
    }
  }
}

class InvalidInputFailure extends Failure {
  // final String message;
  //
  // const InputConvertorFailure(this.message);

  @override
  List<Object?> get props => [];
}
