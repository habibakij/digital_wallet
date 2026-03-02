class ApiEndpoints {
  ApiEndpoints._();

  static const String baseUrl = "https://api.escuelajs.co/api/v1";
  // Auth
  static const String login = '/auth/login';
  static const String logout = '/auth/logout';
  static const String refreshToken = '/auth/refresh';
  static const String profile = '/auth/profile';

  // Wallet
  static const String balance = '/wallet/balance';
  static const String sendMoney = '/wallet/transfer';

  // Transactions
  static const String transactions = '/transactions';
  static String transactionDetail(String id) => '/transactions/$id';
}
