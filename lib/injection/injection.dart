import 'package:digital_wallet/core/network/api_client.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';

import '../core/utils/helper/token_storage.dart';
import '../features/auth/data/datasources/auth_remote_datasource.dart';
import '../features/auth/data/repositories/auth_repository_impl.dart';
import '../features/auth/domain/repositories/auth_repository.dart';
import '../features/auth/domain/usecases/login_usecase.dart';
import '../features/auth/domain/usecases/logout_usecase.dart';
import '../features/auth/presentation/bloc/auth_bloc.dart';
import '../features/dashboard/presentation/bloc/dashboard_bloc.dart';
import '../features/send_money/data/datasources/send_money_remote_datasource.dart';
import '../features/send_money/data/repository/send_money_repository_impl.dart';
import '../features/send_money/domain/repository/send_money_repository.dart';
import '../features/send_money/domain/usecase/send_money_usecase.dart';
import '../features/send_money/presentation/bloc/send_money_bloc.dart';
import '../features/transactions/data/datasources/transaction_remote_datasource.dart';
import '../features/transactions/data/repository/transaction_repository_impl.dart';
import '../features/transactions/domain/repositories/transaction_repository.dart';
import '../features/transactions/presentation/bloc/transaction_bloc.dart';

final sl = GetIt.instance;

Future<void> configureDependencies() async {
  // ─── Core ──────────────────────────────────────────────────────────────────
  sl.registerLazySingleton<FlutterSecureStorage>(
      () => const FlutterSecureStorage());

  sl.registerLazySingleton<TokenStorage>(
      () => TokenStorage(sl<FlutterSecureStorage>()));

  sl.registerLazySingleton<ApiClient>(() => ApiClient());

  // ─── Auth ──────────────────────────────────────────────────────────────────
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(sl<ApiClient>(), sl<TokenStorage>()),
  );

  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(sl<AuthRemoteDataSource>(), sl<TokenStorage>()),
  );

  sl.registerLazySingleton(() => LoginUseCase(sl<AuthRepository>()));
  sl.registerLazySingleton(() => LogoutUseCase(sl<AuthRepository>()));

  sl.registerFactory<AuthBloc>(
    () => AuthBloc(
        loginUseCase: sl<LoginUseCase>(), logoutUseCase: sl<LogoutUseCase>()),
  );

  // ─── Dashboard ─────────────────────────────────────────────────────────────
  sl.registerFactory<DashboardBloc>(() => DashboardBloc(sl<AuthRepository>()));

  // ─── Transactions ──────────────────────────────────────────────────────────
  sl.registerLazySingleton<TransactionRemoteDataSource>(
    () => TransactionRemoteDataSourceImpl(sl<ApiClient>()),
  );

  sl.registerLazySingleton<TransactionRepository>(
    () => TransactionRepositoryImpl(sl<TransactionRemoteDataSource>()),
  );

  sl.registerFactory<TransactionBloc>(
    () => TransactionBloc(sl<TransactionRepository>()),
  );

  // ─── Send Money ────────────────────────────────────────────────────────────
  sl.registerLazySingleton<SendMoneyRemoteDataSource>(
    () => SendMoneyRemoteDataSourceImpl(sl<ApiClient>()),
  );

  sl.registerLazySingleton<SendMoneyRepository>(
    () => SendMoneyRepositoryImpl(sl<SendMoneyRemoteDataSource>()),
  );

  sl.registerLazySingleton(() => SendMoneyUseCase(sl<SendMoneyRepository>()));

  sl.registerFactory<SendMoneyBloc>(
      () => SendMoneyBloc(sl<SendMoneyUseCase>()));
}
