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
    final addresses =
        await InternetAddress.lookup('google.com').timeout(const Duration(seconds: 5));
    if (result.contains(ConnectivityResult.none) ||
        addresses.isEmpty ||
        addresses.first.rawAddress.isEmpty) {
      return handler.reject(
        DioException(
            requestOptions: options,
            error: "No internet connection, Please connect your internet and try again"),
      );
    }
    handler.next(options);
  }

  Future<bool> _isOffline() async {
    // Step 1: connectivity_plus দিয়ে quick check
    // এটা [none] দিলে নিশ্চিতভাবে offline
    final result = await _connectivity.checkConnectivity();
    if (result.contains(ConnectivityResult.none)) return true;

    // Step 2: connectivity_plus [wifi/mobile] দেখালেও
    // actual internet নাও থাকতে পারে (captive portal, weak signal)।
    // তাই real DNS lookup দিয়ে verify করো।
    try {
      final addresses =
          await InternetAddress.lookup('google.com').timeout(const Duration(seconds: 5));
      // lookup সফল হলে এবং address পেলে online
      return addresses.isEmpty || addresses.first.rawAddress.isEmpty;
    } on SocketException {
      return true; // DNS fail = offline
    } catch (_) {
      // timeout বা অন্য error — safe side এ online ধরো
      // request fail হলে DioException আসবে
      return false;
    }
  }
}
