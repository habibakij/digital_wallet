import 'dart:async';

import 'package:dio/dio.dart';

class PendingRequest {
  final RequestOptions options;
  final Completer<Response> completer;
  PendingRequest(this.options, this.completer);
}
