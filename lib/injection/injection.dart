import 'package:digital_wallet/core/network/api_client.dart';
import 'package:digital_wallet/core/service/secure_storage_service.dart';
import 'package:digital_wallet/features/auth/sign_in/data/repository_impl/sign_in_repository_impl.dart';
import 'package:digital_wallet/features/auth/sign_in/data/sources/sign_in_remote_datasource.dart';
import 'package:digital_wallet/features/auth/sign_in/domain/repositories/sign_in_repository.dart';
import 'package:digital_wallet/features/auth/sign_in/domain/use_cases/sign_in_use_case.dart';
import 'package:digital_wallet/features/auth/sign_in/domain/use_cases/sign_out_use_case.dart';
import 'package:digital_wallet/features/auth/sign_in/presentation/bloc/sign_in_bloc.dart';
import 'package:digital_wallet/features/dashboard/data/repository_impl/dashboard_repository_impl.dart';
import 'package:digital_wallet/features/dashboard/data/sources/dashboard_remote_data_source.dart';
import 'package:digital_wallet/features/dashboard/domain/repository/dashboard_repository.dart';
import 'package:digital_wallet/features/dashboard/domain/use_cases/dashboard_use_case.dart';
import 'package:digital_wallet/features/dashboard/presentation/bloc/dashboard_bloc.dart';
import 'package:digital_wallet/features/send_money/data/repository_impl/send_money_repository_impl.dart';
import 'package:digital_wallet/features/send_money/data/sources/send_money_remote_datasource.dart';
import 'package:digital_wallet/features/send_money/domain/repository/send_money_repository.dart';
import 'package:digital_wallet/features/send_money/domain/use_case/send_money_use_case.dart';
import 'package:digital_wallet/features/send_money/presentation/bloc/send_money_bloc.dart';
import 'package:digital_wallet/features/send_money_otp_verification/data/repository_impl/otp_verification_repository_impl.dart';
import 'package:digital_wallet/features/send_money_otp_verification/data/sources/remote/otp_verification_remote_source.dart';
import 'package:digital_wallet/features/send_money_otp_verification/domain/repository/otp_verification_repository.dart';
import 'package:digital_wallet/features/send_money_otp_verification/domain/use_case/otp_verification_use_case.dart';
import 'package:digital_wallet/features/send_money_otp_verification/presentation/bloc/otp_verification_bloc.dart';
import 'package:digital_wallet/features/splash/presentation/bloc/splash_cubit.dart';
import 'package:digital_wallet/features/transactions/data/repository_impl/transaction_repository_impl.dart';
import 'package:digital_wallet/features/transactions/data/sources/transaction_remote_datasource.dart';
import 'package:digital_wallet/features/transactions/domain/repository/transaction_repository.dart';
import 'package:digital_wallet/features/transactions/domain/use_cases/transaction_use_case.dart';
import 'package:digital_wallet/features/transactions/presentation/bloc/transaction_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';

final sl = GetIt.instance;

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
}
