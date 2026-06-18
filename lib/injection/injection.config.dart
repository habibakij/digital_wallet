// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:connectivity_plus/connectivity_plus.dart' as _i895;
import 'package:digital_wallet/core/network/api_client.dart' as _i273;
import 'package:digital_wallet/core/network/environment/api_environment.dart'
    as _i144;
import 'package:digital_wallet/core/network/environment/dev_environment.dart'
    as _i249;
import 'package:digital_wallet/core/network/environment/prod_environment.dart'
    as _i916;
import 'package:digital_wallet/core/network/interceptor/auth_interceptor.dart'
    as _i532;
import 'package:digital_wallet/core/network/interceptor/connectivity_interceptor.dart'
    as _i877;
import 'package:digital_wallet/core/network/interceptor/custom_baseurl_interceptor.dart'
    as _i657;
import 'package:digital_wallet/core/network/interceptor/response_interceptor.dart'
    as _i1050;
import 'package:digital_wallet/core/network/interceptor/retry_interceptor.dart'
    as _i665;
import 'package:digital_wallet/core/network/interceptor/token_refresh_interceptor.dart'
    as _i681;
import 'package:digital_wallet/core/service/local_storage_service.dart'
    as _i649;
import 'package:digital_wallet/core/service/secure_storage_service.dart'
    as _i854;
import 'package:digital_wallet/features/auth/sign_in/data/repository_impl/sign_in_repository_impl.dart'
    as _i894;
import 'package:digital_wallet/features/auth/sign_in/data/sources/sign_in_remote_datasource.dart'
    as _i113;
import 'package:digital_wallet/features/auth/sign_in/domain/repositories/sign_in_repository.dart'
    as _i439;
import 'package:digital_wallet/features/auth/sign_in/domain/use_cases/sign_in_use_case.dart'
    as _i8;
import 'package:digital_wallet/features/auth/sign_in/domain/use_cases/sign_out_use_case.dart'
    as _i874;
import 'package:digital_wallet/features/auth/sign_in/presentation/bloc/sign_in_bloc.dart'
    as _i230;
import 'package:digital_wallet/features/dashboard/data/repository_impl/dashboard_repository_impl.dart'
    as _i69;
import 'package:digital_wallet/features/dashboard/data/sources/dashboard_remote_data_source.dart'
    as _i1050;
import 'package:digital_wallet/features/dashboard/domain/repository/dashboard_repository.dart'
    as _i384;
import 'package:digital_wallet/features/dashboard/domain/use_cases/dashboard_use_case.dart'
    as _i981;
import 'package:digital_wallet/features/dashboard/presentation/bloc/dashboard_bloc.dart'
    as _i252;
import 'package:digital_wallet/features/otp_verification/data/repository_impl/otp_verification_repository_impl.dart'
    as _i662;
import 'package:digital_wallet/features/otp_verification/data/sources/local/otp_verification_local_data_source.dart'
    as _i877;
import 'package:digital_wallet/features/otp_verification/data/sources/remote/otp_verification_remote_source.dart'
    as _i399;
import 'package:digital_wallet/features/otp_verification/domain/repository/otp_verification_repository.dart'
    as _i383;
import 'package:digital_wallet/features/otp_verification/domain/use_case/otp_verification_use_case.dart'
    as _i176;
import 'package:digital_wallet/features/otp_verification/presentation/bloc/otp_verification_bloc.dart'
    as _i889;
import 'package:digital_wallet/features/send_money/data/repository_impl/send_money_repository_impl.dart'
    as _i394;
import 'package:digital_wallet/features/send_money/data/sources/send_money_remote_datasource.dart'
    as _i297;
import 'package:digital_wallet/features/send_money/domain/repository/send_money_repository.dart'
    as _i32;
import 'package:digital_wallet/features/send_money/domain/use_case/send_money_use_case.dart'
    as _i381;
import 'package:digital_wallet/features/send_money/presentation/bloc/send_money_bloc.dart'
    as _i303;
import 'package:digital_wallet/features/splash/presentation/bloc/splash_cubit.dart'
    as _i499;
import 'package:digital_wallet/features/transaction_details/data/repository_impl/tr_details_repo_impl.dart'
    as _i593;
import 'package:digital_wallet/features/transaction_details/data/sources/tr_details_remote_source.dart'
    as _i699;
import 'package:digital_wallet/features/transaction_details/domain/repository/tr_details_repository.dart'
    as _i959;
import 'package:digital_wallet/features/transactions/data/repository_impl/transaction_repository_impl.dart'
    as _i155;
import 'package:digital_wallet/features/transactions/data/sources/transaction_remote_datasource.dart'
    as _i357;
import 'package:digital_wallet/features/transactions/domain/repository/transaction_repository.dart'
    as _i504;
import 'package:digital_wallet/features/transactions/domain/use_cases/transaction_use_case.dart'
    as _i440;
import 'package:digital_wallet/features/transactions/presentation/bloc/transaction_bloc.dart'
    as _i118;
import 'package:digital_wallet/injection/register_module.dart' as _i446;
import 'package:flutter_secure_storage/flutter_secure_storage.dart' as _i558;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;
import 'package:shared_preferences/shared_preferences.dart' as _i460;

const String _dev = 'dev';
const String _prod = 'prod';

extension GetItInjectableX on _i174.GetIt {
// initializes the registration of main-scope dependencies inside of GetIt
  Future<_i174.GetIt> init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) async {
    final gh = _i526.GetItHelper(
      this,
      environment,
      environmentFilter,
    );
    final registerModule = _$RegisterModule();
    gh.factory<_i499.SplashCubit>(() => _i499.SplashCubit());
    await gh.factoryAsync<_i460.SharedPreferences>(
      () => registerModule.prefs,
      preResolve: true,
    );
    gh.lazySingleton<_i657.CustomBaseUrlInterceptor>(
        () => _i657.CustomBaseUrlInterceptor());
    gh.lazySingleton<_i1050.ResponseInterceptor>(
        () => _i1050.ResponseInterceptor());
    gh.lazySingleton<_i649.LocalStorageService>(
        () => _i649.LocalStorageService());
    gh.lazySingleton<_i558.FlutterSecureStorage>(
        () => registerModule.flutterSecureStorage);
    gh.lazySingleton<_i895.Connectivity>(() => registerModule.connectivity);
    gh.lazySingleton<_i877.OtpVerificationLocalDataSource>(
        () => _i877.OtpVerificationLocalDataSourceImpl());
    gh.lazySingleton<_i699.TrDetailsRemoteDataSource>(
        () => _i699.TrDetailsRemoteDataSourceImpl());
    gh.lazySingleton<_i144.ApiEnvironment>(
      () => _i249.DevEnvironment(),
      registerFor: {_dev},
    );
    gh.lazySingleton<_i854.SecureStorageService>(
        () => _i854.SecureStorageService(gh<_i558.FlutterSecureStorage>()));
    gh.lazySingleton<_i959.TrDetailsRepository>(() =>
        _i593.TrDetailsRepositoryImpl(gh<_i699.TrDetailsRemoteDataSource>()));
    gh.lazySingleton<_i877.ConnectivityInterceptor>(
        () => _i877.ConnectivityInterceptor(gh<_i895.Connectivity>()));
    gh.lazySingleton<_i144.ApiEnvironment>(
      () => _i916.ProdEnvironment(),
      registerFor: {_prod},
    );
    gh.lazySingleton<_i681.TokenRefreshInterceptor>(
        () => _i681.TokenRefreshInterceptor(
              gh<_i854.SecureStorageService>(),
              gh<_i144.ApiEnvironment>(),
            ));
    gh.lazySingleton<_i532.AuthInterceptor>(() => _i532.AuthInterceptor(
          gh<_i144.ApiEnvironment>(),
          gh<_i854.SecureStorageService>(),
        ));
    gh.lazySingleton<_i665.RetryInterceptor>(
        () => _i665.RetryInterceptor(gh<_i144.ApiEnvironment>()));
    gh.lazySingleton<_i273.ApiClient>(() => _i273.ApiClient(
          gh<_i144.ApiEnvironment>(),
          gh<_i877.ConnectivityInterceptor>(),
          gh<_i532.AuthInterceptor>(),
          gh<_i1050.ResponseInterceptor>(),
          gh<_i681.TokenRefreshInterceptor>(),
          gh<_i665.RetryInterceptor>(),
          gh<_i657.CustomBaseUrlInterceptor>(),
        ));
    gh.lazySingleton<_i297.SendMoneyRemoteDataSource>(
        () => _i297.SendMoneyRemoteDataSourceImpl(gh<_i273.ApiClient>()));
    gh.lazySingleton<_i113.SignInRemoteDatasource>(
        () => _i113.SignInRemoteDatasourceImpl(
              gh<_i273.ApiClient>(),
              gh<_i854.SecureStorageService>(),
            ));
    gh.lazySingleton<_i399.OtpVerificationRemoteDataSource>(
        () => _i399.OtpVerificationRemoteDataSourceImpl(gh<_i273.ApiClient>()));
    gh.lazySingleton<_i1050.DashboardRemoteDataSource>(
        () => _i1050.DashboardRemoteDataSourceImpl(gh<_i273.ApiClient>()));
    gh.lazySingleton<_i357.TransactionRemoteDataSource>(
        () => _i357.TransactionRemoteDataSourceImpl(gh<_i273.ApiClient>()));
    gh.lazySingleton<_i439.SignInRepository>(() => _i894.SignInRepositoryImpl(
          gh<_i113.SignInRemoteDatasource>(),
          gh<_i854.SecureStorageService>(),
        ));
    gh.lazySingleton<_i32.SendMoneyRepository>(() =>
        _i394.SendMoneyRepositoryImpl(gh<_i297.SendMoneyRemoteDataSource>()));
    gh.lazySingleton<_i383.OtpVerificationRepository>(() =>
        _i662.OtpVerificationRepositoryImpl(
            gh<_i399.OtpVerificationRemoteDataSource>()));
    gh.lazySingleton<_i384.DashboardRepository>(() =>
        _i69.DashboardRepositoryImpl(gh<_i1050.DashboardRemoteDataSource>()));
    gh.lazySingleton<_i8.SignInUseCase>(
        () => _i8.SignInUseCase(gh<_i439.SignInRepository>()));
    gh.lazySingleton<_i381.SendMoneyUseCase>(
        () => _i381.SendMoneyUseCase(gh<_i32.SendMoneyRepository>()));
    gh.lazySingleton<_i504.TransactionRepository>(() =>
        _i155.TransactionRepositoryImpl(
            gh<_i357.TransactionRemoteDataSource>()));
    gh.factory<_i303.SendMoneyBloc>(
        () => _i303.SendMoneyBloc(gh<_i381.SendMoneyUseCase>()));
    gh.lazySingleton<_i176.OtpVerificationUseCase>(() =>
        _i176.OtpVerificationUseCase(gh<_i383.OtpVerificationRepository>()));
    gh.lazySingleton<_i874.SignOutUseCase>(
        () => _i874.SignOutUseCase(gh<_i439.SignInRepository>()));
    gh.factory<_i230.SignInBloc>(
        () => _i230.SignInBloc(loginUseCase: gh<_i8.SignInUseCase>()));
    gh.lazySingleton<_i981.DashboardUseCase>(
        () => _i981.DashboardUseCase(gh<_i384.DashboardRepository>()));
    gh.factory<_i252.DashboardBloc>(
        () => _i252.DashboardBloc(gh<_i981.DashboardUseCase>()));
    gh.lazySingleton<_i440.TransactionUseCase>(
        () => _i440.TransactionUseCase(gh<_i504.TransactionRepository>()));
    gh.factory<_i889.OtpVerificationBloc>(
        () => _i889.OtpVerificationBloc(gh<_i176.OtpVerificationUseCase>()));
    gh.factory<_i118.TransactionBloc>(
        () => _i118.TransactionBloc(gh<_i440.TransactionUseCase>()));
    return this;
  }
}

class _$RegisterModule extends _i446.RegisterModule {}
