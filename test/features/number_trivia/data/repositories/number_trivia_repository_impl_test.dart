import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
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
      numberTriviaRepositoryImpl.getConcreteNumberTrivia(tNumber);
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
        final result =
            await numberTriviaRepositoryImpl.getConcreteNumberTrivia(tNumber);
        // assert
        verify(
            mockNumberTriviaRemoteDataSource.getConcreteNumberTrivia(tNumber));
        verify(mockNumberTriviaLocalDataSource
            .cacheNumberTrivia(tNumberTriviaModel));
      });
    });

    group('device is offline', () {
      setUp(() {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => false);
      });
    });
  });
}
