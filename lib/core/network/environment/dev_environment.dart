import 'package:injectable/injectable.dart';

import 'api_environment.dart';

@dev
@LazySingleton(as: ApiEnvironment)
class DevEnvironment implements ApiEnvironment {
  @override
  String get baseUrl => "https://api.escuelajs.co/api/v1";

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
