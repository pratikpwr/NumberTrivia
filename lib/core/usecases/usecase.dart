// dart doesn't support interfaces
// interface - methods and fields that are public and exposed by classes
// use case should expose a call method
// to forcefully implement this in dart through abstract classes

import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:numtrivia/core/errors/failures.dart';

// this has type of data and param passes to call method
// we can need params so we do following
abstract class UseCase<Type, Params> {
  Future<Either<Failure, Type>> call(Params params);
}

class NoParams extends Equatable {
  @override
  List<Object?> get props => [];
}
