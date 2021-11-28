import 'package:dartz/dartz.dart';
import 'package:numtrivia/core/errors/exceptions.dart';
import 'package:numtrivia/core/errors/failures.dart';
import 'package:numtrivia/core/platform/network_info.dart';
import 'package:numtrivia/features/number_trivia/data/datasources/number_trivia_local_data_source.dart';
import 'package:numtrivia/features/number_trivia/data/datasources/number_trivia_remote_data_source.dart';
import 'package:numtrivia/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:numtrivia/features/number_trivia/domain/repositories/number_trivia_repository.dart';

// Repository is brain of the data layer
// all data management is done here
// Repository in data layer is implementation of repos in domain layer

class NumberTriviaRepositoryImpl implements NumberTriviaRepository {
  final NumberTriviaRemoteDataSource remoteDataSource;
  final NumberTriviaLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  NumberTriviaRepositoryImpl(
      {required this.remoteDataSource,
      required this.localDataSource,
      required this.networkInfo});

  @override
  Future<Either<Failure, NumberTrivia>> getConcreteNumberTrivia(
      int number) async {
    if (await networkInfo.isConnected) {
      try {
        final result = await remoteDataSource.getConcreteNumberTrivia(number);
        await localDataSource.cacheNumberTrivia(result);
        return Right(result);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      try {
        final localTrivia = await localDataSource.getLastNumberTrivia();
        return Right(localTrivia);
      } on CacheException {
        return Left(CacheFailure());
      }
    }
  }

  @override
  Future<Either<Failure, NumberTrivia>> getRandomNumberTrivia() async {
    if (await networkInfo.isConnected) {
      try {
        final result = await remoteDataSource.getRandomNumberTrivia();
        await localDataSource.cacheNumberTrivia(result);
        return Right(result);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      try {
        final localTrivia = await localDataSource.getLastNumberTrivia();
        return Right(localTrivia);
      } on CacheException {
        return Left(CacheFailure());
      }
    }
  }
}
