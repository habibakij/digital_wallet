abstract final class AppExceptionMessages {
  static const noInternet = 'No internet connection. Please check your network and try again.';
  static const connectionTimeout = 'Connection timed out. Please check your internet and retry.';
  static const sendTimeout = 'Request timed out while sending. Please try again.';
  static const receiveTimeout = 'The server took too long to respond. Please try again.';
  static const requestTimeout = 'The request timed out. Please try again.';
  static const badCertificate = 'Secure connection failed. Please update the app or contact support.';
  static const sessionExpired = 'Your session has expired. Please log in again.';
  static const unknown = 'Something went wrong. Please try again.';
  // HTTP 4xx
  static const badRequest = 'The request was invalid. Please check your input and try again.';
  static const unauthorized = 'Invalid credentials. Please check your email and password.';
  static const forbidden = "You don't have permission to perform this action.";
  static const notFound = 'The requested resource was not found.';
  static const methodNotAllowed = 'This operation is not supported.';
  static const conflict = 'A conflict occurred. The resource may already exist.';
  static const gone = 'This resource is no longer available.';
  static const payloadTooLarge = 'The file or data you are trying to upload is too large.';
  static const unsupportedMediaType = 'The file type is not supported by the server.';
  static const unprocessableEntity = 'Validation failed. Please review the highlighted fields.';
  static const tooManyRequests = 'Too many requests. Please slow down and try again in a moment.';
  // HTTP 5xx
  static const internalServerError = 'Something went wrong on our end. Please try again later.';
  static const badGateway = 'Our servers are temporarily unreachable. Please try again shortly.';
  static const serviceUnavailable = 'The service is currently unavailable. Please try again later.';
  static const gatewayTimeout = 'The server did not respond in time. Please try again.';
}
