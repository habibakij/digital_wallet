import 'package:dartz/dartz.dart';
import 'package:digital_wallet/core/exception_handler/app_exception.dart';
import 'package:digital_wallet/core/exception_handler/failures.dart';
import 'package:digital_wallet/features/send_money_otp_verification/data/sources/remote/otp_verification_remote_source.dart';
import 'package:digital_wallet/features/send_money_otp_verification/domain/entities/otp_verification_entity.dart';
import 'package:digital_wallet/features/send_money_otp_verification/domain/repository/otp_verification_repository.dart';
import 'package:digital_wallet/features/send_money_otp_verification/domain/use_case/otp_verification_use_case.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: OtpVerificationRepository)
class OtpVerificationRepositoryImpl implements OtpVerificationRepository {
  final OtpVerificationRemoteDataSource _remoteDataSource;
  const OtpVerificationRepositoryImpl(this._remoteDataSource);

  @override
  Future<Either<Failure, OtpVerificationEntity>> verificationOtp(OtpParams params) async {
    try {
      final model = await _remoteDataSource.otpVerification(params);
      return Right(model.toEntity());
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on NetworkException {
      return const Left(NetworkFailure());
    }
  }
}
