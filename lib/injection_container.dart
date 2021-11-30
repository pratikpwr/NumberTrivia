import 'package:get_it/get_it.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../core/network/network_info.dart';
import '../core/utils/input_convertor.dart';
import '../features/number_trivia/data/datasources/number_trivia_local_data_source.dart';
import '../features/number_trivia/data/datasources/number_trivia_remote_data_source.dart';
import '../features/number_trivia/data/repositories/number_trivia_repository_impl.dart';
import '../features/number_trivia/domain/repositories/number_trivia_repository.dart';
import '../features/number_trivia/domain/usecases/get_concrete_number_trivia.dart';
import '../features/number_trivia/domain/usecases/get_random_number_trivia.dart';
import '../features/number_trivia/presentation/bloc/number_trivia_bloc.dart';

// sl - service locator
final sl = GetIt.instance;

Future<void> init() async {
  //! Features - Number trivia
  // Bloc
  sl.registerFactory(() => NumberTriviaBloc(
        randomNT: sl(),
        concreteNT: sl(),
        inputConvertor: sl(),
      ));

  //Usecases
  sl.registerLazySingleton(() => GetConcreteNumberTrivia(sl()));
  sl.registerLazySingleton(() => GetRandomNumberTrivia(sl()));

  //Repository
  sl.registerLazySingleton<NumberTriviaRepository>(() =>
      NumberTriviaRepositoryImpl(
          remoteDataSource: sl(), localDataSource: sl(), networkInfo: sl()));

  // Data Sources
  sl.registerLazySingleton<NumberTriviaRemoteDataSource>(
      () => NumberTriviaRemoteDataSourceImpl(sl()));
  sl.registerLazySingleton<NumberTriviaLocalDataSource>(
      () => NumberTriviaLocalDataSourceImpl(sl()));

  //! Core
  sl.registerLazySingleton(() => InputConvertor());
  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(sl()));

  //! External
  final sharedPrefs = await SharedPreferences.getInstance();
  sl.registerLazySingleton<SharedPreferences>(() => sharedPrefs);

  sl.registerLazySingleton(() => http.Client());
  sl.registerLazySingleton(() => InternetConnectionChecker());
}
