import 'package:injectable/injectable.dart';

import 'api_environment.dart';

@prod
@LazySingleton(as: ApiEnvironment)
class ProdEnvironment implements ApiEnvironment {
  @override
  String get baseUrl => 'https://api.yourapp.com/v1';

  @override
  bool get enableLogging => false;

  @override
  bool get enableCertificatePinning => true;

  @override
  Duration get connectTimeout => const Duration(seconds: 15);

  @override
  Duration get receiveTimeout => const Duration(seconds: 15);

  @override
  Duration get sendTimeout => const Duration(seconds: 15);
}
