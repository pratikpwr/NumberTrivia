import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:numtrivia/core/errors/exceptions.dart';
import 'package:numtrivia/core/errors/failures.dart';
import 'package:numtrivia/core/platform/network_info.dart';
import 'package:numtrivia/features/number_trivia/data/datasources/number_trivia_local_data_source.dart';
import 'package:numtrivia/features/number_trivia/data/datasources/number_trivia_remote_data_source.dart';
import 'package:numtrivia/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:numtrivia/features/number_trivia/data/repositories/number_trivia_repository_impl.dart';
import 'package:numtrivia/features/number_trivia/domain/entities/number_trivia.dart';

import 'number_trivia_repository_impl_test.mocks.dart';

@GenerateMocks(
    [NumberTriviaRemoteDataSource, NumberTriviaLocalDataSource, NetworkInfo])
void main() {
  late MockNumberTriviaLocalDataSource mockNumberTriviaLocalDataSource;
  late MockNumberTriviaRemoteDataSource mockNumberTriviaRemoteDataSource;
  late MockNetworkInfo mockNetworkInfo;
  late NumberTriviaRepositoryImpl numberTriviaRepositoryImpl;

  setUp(() {
    mockNumberTriviaLocalDataSource = MockNumberTriviaLocalDataSource();
    mockNumberTriviaRemoteDataSource = MockNumberTriviaRemoteDataSource();
    mockNetworkInfo = MockNetworkInfo();
    numberTriviaRepositoryImpl = NumberTriviaRepositoryImpl(
        localDataSource: mockNumberTriviaLocalDataSource,
        remoteDataSource: mockNumberTriviaRemoteDataSource,
        networkInfo: mockNetworkInfo);
  });

  group('get concrete number trivia', () {
    const tNumber = 1;
    const tNumberTriviaModel = NumberTriviaModel(text: 'Test', number: tNumber);
    const NumberTrivia tNumberTrivia = tNumberTriviaModel;

    test('should check if device is Online', () async {
      // arrange
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      // act
      await numberTriviaRepositoryImpl.getConcreteNumberTrivia(tNumber);
      // assert
      verify(mockNetworkInfo.isConnected);
    });

    group('device is online', () {
      setUp(() {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      });

      test(
          'should return remote number trivia when the call to remote data source is Success',
          () async {
        // arrange
        when(mockNumberTriviaRemoteDataSource.getConcreteNumberTrivia(any))
            .thenAnswer((_) async => tNumberTriviaModel);
        // act
        final result =
            await numberTriviaRepositoryImpl.getConcreteNumberTrivia(tNumber);
        // assert
        verify(
            mockNumberTriviaRemoteDataSource.getConcreteNumberTrivia(tNumber));
        expect(result, equals(const Right(tNumberTrivia)));
        verifyNoMoreInteractions(mockNumberTriviaRemoteDataSource);
      });

      test(
          'should cached number trivia locally when the call to remote data source is Success',
          () async {
        // arrange
        when(mockNumberTriviaRemoteDataSource.getConcreteNumberTrivia(any))
            .thenAnswer((_) async => tNumberTriviaModel);
        // act
        await numberTriviaRepositoryImpl.getConcreteNumberTrivia(tNumber);
        // assert
        verify(
            mockNumberTriviaRemoteDataSource.getConcreteNumberTrivia(tNumber));
        verify(mockNumberTriviaLocalDataSource
            .cacheNumberTrivia(tNumberTriviaModel));
      });

      test(
          'should return server failure when the call to remote data source is unsuccessful',
          () async {
        // arrange
        when(mockNumberTriviaRemoteDataSource.getConcreteNumberTrivia(any))
            .thenThrow(ServerException());
        // act
        final result =
            await numberTriviaRepositoryImpl.getConcreteNumberTrivia(tNumber);
        // assert
        verify(
            mockNumberTriviaRemoteDataSource.getConcreteNumberTrivia(tNumber));
        verifyZeroInteractions(mockNumberTriviaLocalDataSource);
        expect(result, equals(Left(ServerFailure())));
        verifyNoMoreInteractions(mockNumberTriviaRemoteDataSource);
      });
    });

    group('device is offline', () {
      setUp(() {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => false);
      });

      test('should return last locally cached data when cache is present',
          () async {
        // arrange
        when(mockNumberTriviaLocalDataSource.getLastNumberTrivia())
            .thenAnswer((_) async => tNumberTriviaModel);
        // act
        final result =
            await numberTriviaRepositoryImpl.getConcreteNumberTrivia(tNumber);
        // assert
        verifyZeroInteractions(mockNumberTriviaRemoteDataSource);
        verify(mockNumberTriviaLocalDataSource.getLastNumberTrivia());
        expect(result, equals(const Right(tNumberTrivia)));
      });

      test('should return cached failure when cache is not present', () async {
        // arrange
        when(mockNumberTriviaLocalDataSource.getLastNumberTrivia())
            .thenThrow(CacheException());
        // act
        final result =
            await numberTriviaRepositoryImpl.getConcreteNumberTrivia(tNumber);
        // assert
        verifyZeroInteractions(mockNumberTriviaRemoteDataSource);
        verify(mockNumberTriviaLocalDataSource.getLastNumberTrivia());
        expect(result, equals(Left(CacheFailure())));
      });
    });
  });
}
