import 'package:digital_wallet/core/network/api_client.dart';
import 'package:digital_wallet/core/service/secure_storage_service.dart';
import 'package:digital_wallet/features/auth/sign_in/data/repositories_impl/auth_repository_impl.dart';
import 'package:digital_wallet/features/auth/sign_in/data/sources/auth_remote_datasource.dart';
import 'package:digital_wallet/features/auth/sign_in/domain/repositories/auth_repository.dart';
import 'package:digital_wallet/features/auth/sign_in/domain/use_cases/login_use_case.dart';
import 'package:digital_wallet/features/auth/sign_in/domain/use_cases/logout_use_case.dart';
import 'package:digital_wallet/features/auth/sign_in/presentation/bloc/sign_in_bloc.dart';
import 'package:digital_wallet/features/dashboard/presentation/bloc/dashboard_bloc.dart';
import 'package:digital_wallet/features/send_money/data/repository/send_money_repository_impl.dart';
import 'package:digital_wallet/features/send_money/data/sources/send_money_remote_datasource.dart';
import 'package:digital_wallet/features/send_money/domain/repository/send_money_repository.dart';
import 'package:digital_wallet/features/send_money/domain/use_case/send_money_use_case.dart';
import 'package:digital_wallet/features/send_money/presentation/bloc/send_money_bloc.dart';
import 'package:digital_wallet/features/splash/presentation/bloc/splash_cubit.dart';
import 'package:digital_wallet/features/transactions/data/repository/transaction_repository_impl.dart';
import 'package:digital_wallet/features/transactions/data/sources/transaction_remote_datasource.dart';
import 'package:digital_wallet/features/transactions/domain/repository/transaction_repository.dart';
import 'package:digital_wallet/features/transactions/presentation/bloc/transaction_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';

final sl = GetIt.instance;

Future<void> configureDependencies() async {
  // ─── Core ──────────────────────────────────────────────────────────────────
  sl.registerLazySingleton<FlutterSecureStorage>(() => const FlutterSecureStorage());
  sl.registerLazySingleton<SecureStorageService>(() => SecureStorageService(sl<FlutterSecureStorage>()));
  sl.registerLazySingleton<ApiClient>(() => ApiClient());

  // ─── Splash ──────────────────────────────────────────────────────────────────
  sl.registerFactory<SplashCubit>(() => SplashCubit());

  // ─── Auth ──────────────────────────────────────────────────────────────────
  sl.registerLazySingleton<AuthRemoteDataSource>(() => AuthRemoteDataSourceImpl(sl<ApiClient>(), sl<SecureStorageService>()));
  sl.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl(sl<AuthRemoteDataSource>(), sl<SecureStorageService>()));
  sl.registerLazySingleton(() => LoginUseCase(sl<AuthRepository>()));
  sl.registerLazySingleton(() => LogoutUseCase(sl<AuthRepository>()));
  sl.registerFactory<SignInBloc>(() => SignInBloc(loginUseCase: sl<LoginUseCase>(), logoutUseCase: sl<LogoutUseCase>()));

  // ─── Dashboard ─────────────────────────────────────────────────────────────
  sl.registerFactory<DashboardBloc>(() => DashboardBloc(sl<AuthRepository>()));

  // ─── Transactions ──────────────────────────────────────────────────────────
  sl.registerLazySingleton<TransactionRemoteDataSource>(() => TransactionRemoteDataSourceImpl(sl<ApiClient>()));
  sl.registerLazySingleton<TransactionRepository>(() => TransactionRepositoryImpl(sl<TransactionRemoteDataSource>()));
  sl.registerFactory<TransactionBloc>(() => TransactionBloc(sl<TransactionRepository>()));

  // ─── Send Money ────────────────────────────────────────────────────────────
  sl.registerLazySingleton<SendMoneyRemoteDataSource>(() => SendMoneyRemoteDataSourceImpl(sl<ApiClient>()));
  sl.registerLazySingleton<SendMoneyRepository>(() => SendMoneyRepositoryImpl(sl<SendMoneyRemoteDataSource>()));
  sl.registerLazySingleton(() => SendMoneyUseCase(sl<SendMoneyRepository>()));
  sl.registerFactory<SendMoneyBloc>(() => SendMoneyBloc(sl<SendMoneyUseCase>()));
}
