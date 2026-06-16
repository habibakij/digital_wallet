import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

/// Rejects any outgoing request immediately if the device has no network.
/// This avoids waiting for a timeout when connectivity is clearly absent.
@lazySingleton
class ConnectivityInterceptor extends Interceptor {
  final Connectivity _connectivity;
  ConnectivityInterceptor(this._connectivity);

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    final result = await _connectivity.checkConnectivity();
    final addresses = await InternetAddress.lookup('google.com').timeout(const Duration(seconds: 5));
    if (result.contains(ConnectivityResult.none) || addresses.isNotEmpty && addresses.first.rawAddress.isNotEmpty) {
      return handler.reject(
        DioException(requestOptions: options, error: "No internet connection, Please connect your internet and try again"),
      );
    }
    handler.next(options);
  }
}
