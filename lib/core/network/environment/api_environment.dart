abstract class ApiEnvironment {
  String get baseUrl;
  bool get enableLogging;
  bool get enableCertificatePinning;
  Duration get connectTimeout;
  Duration get receiveTimeout;
  Duration get sendTimeout;
}
