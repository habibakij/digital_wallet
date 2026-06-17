import 'package:digital_wallet/core/network/api_endpoints.dart';
import 'package:injectable/injectable.dart';

import 'api_environment.dart';

@dev
@LazySingleton(as: ApiEnvironment)
class DevEnvironment implements ApiEnvironment {
  @override
  String get baseUrl => ApiEndpoints.baseUrl;

  @override
  bool get enableLogging => true;

  @override
  bool get enableCertificatePinning => false;

  @override
  Duration get connectTimeout => const Duration(seconds: 30);

  @override
  Duration get receiveTimeout => const Duration(seconds: 30);

  @override
  Duration get sendTimeout => const Duration(seconds: 30);
}
