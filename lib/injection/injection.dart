import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';

import 'injection.config.dart';

final sl = GetIt.instance;

@InjectableInit()
Future<void> configureDependencies(String environment) async => sl.init(environment: environment);

/*
Future<void> configureDependencies() async {
  sl.registerLazySingleton<FlutterSecureStorage>(() => const FlutterSecureStorage());
  sl.registerLazySingleton<SecureStorageService>(() => SecureStorageService(sl<FlutterSecureStorage>()));
  sl.registerLazySingleton<ApiClient>(() => ApiClient());

  sl.registerFactory<SplashCubit>(() => SplashCubit());

  sl.registerLazySingleton<SignInRemoteDatasource>(() => SignInRemoteDatasourceImpl(sl<ApiClient>(), sl<SecureStorageService>()));
  sl.registerLazySingleton<SignInRepository>(() => SignInRepositoryImpl(sl<SignInRemoteDatasource>(), sl<SecureStorageService>()));
  sl.registerLazySingleton(() => SignInUseCase(sl<SignInRepository>()));
  sl.registerLazySingleton(() => SignOutUseCase(sl<SignInRepository>()));
  sl.registerFactory<SignInBloc>(() => SignInBloc(loginUseCase: sl<SignInUseCase>()));

  sl.registerLazySingleton<DashboardRemoteDataSource>(() => DashboardRemoteDataSourceImpl(sl<ApiClient>()));
  sl.registerLazySingleton<DashboardRepository>(() => DashboardRepositoryImpl(sl<DashboardRemoteDataSource>()));
  sl.registerLazySingleton(() => DashboardUseCase(sl<DashboardRepository>()));
  sl.registerFactory<DashboardBloc>(() => DashboardBloc(sl<DashboardUseCase>()));

  sl.registerLazySingleton<TransactionRemoteDataSource>(() => TransactionRemoteDataSourceImpl(sl<ApiClient>()));
  sl.registerLazySingleton<TransactionRepository>(() => TransactionRepositoryImpl(sl<TransactionRemoteDataSource>()));
  sl.registerFactory(() => TransactionUseCase(sl<TransactionRepository>()));
  sl.registerFactory<TransactionBloc>(() => TransactionBloc(sl<TransactionUseCase>()));

  sl.registerLazySingleton<SendMoneyRemoteDataSource>(() => SendMoneyRemoteDataSourceImpl(sl<ApiClient>()));
  sl.registerLazySingleton<SendMoneyRepository>(() => SendMoneyRepositoryImpl(sl<SendMoneyRemoteDataSource>()));
  sl.registerLazySingleton(() => SendMoneyUseCase(sl<SendMoneyRepository>()));
  sl.registerFactory<SendMoneyBloc>(() => SendMoneyBloc(sl<SendMoneyUseCase>()));

  sl.registerLazySingleton<OtpVerificationRemoteDataSource>(() => OtpVerificationRemoteDataSourceImpl(sl<ApiClient>()));
  sl.registerLazySingleton<OtpVerificationRepository>(() => OtpVerificationRepositoryImpl(sl<OtpVerificationRemoteDataSource>()));
  sl.registerLazySingleton(() => OtpVerificationUseCase(sl<OtpVerificationRepository>()));
  sl.registerFactory<OtpVerificationBloc>(() => OtpVerificationBloc(sl<OtpVerificationUseCase>()));
}*/
