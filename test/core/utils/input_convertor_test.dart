import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:numtrivia/core/utils/input_convertor.dart';

void main() {
  late InputConvertor inputConvertor;

  setUp(() {
    inputConvertor = InputConvertor();
  });

  group('string to Unsigned Integer', () {
    test('should return an integer when string represents an unsigned integer',
        () async {
      // arrange
      const str = '123';
      // act
      final result = inputConvertor.stringToUnsignedInteger(str);
      // assert
      expect(result, const Right(123));
    });

    test(
        'should return an InvalidInputFailure when string represents is not unsigned integer',
        () async {
      // arrange
      const str = 'ugd';
      // act
      final result = inputConvertor.stringToUnsignedInteger(str);
      // assert
      expect(result, Left(InvalidInputFailure()));
    });

    test(
        'should return an Failure when string represents a negetive integer',
        () async {
      // arrange
      const str = '-12';
      // act
      final result = inputConvertor.stringToUnsignedInteger(str);
      // assert
      expect(result, Left(InvalidInputFailure()));
    });
  });
}
