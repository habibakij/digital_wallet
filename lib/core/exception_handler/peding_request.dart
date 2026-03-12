import 'dart:async';

import 'package:dio/dio.dart';

// Helper for queued pending requests
class PendingRequest {
  final RequestOptions options;
  final Completer<Response> completer;
  PendingRequest(this.options, this.completer);
}
