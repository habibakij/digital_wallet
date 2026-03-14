class ApiEndpoints {
  ApiEndpoints._();

  static const String baseUrl = "https://api.escuelajs.co/api/v1";
  static const String transactionBaseUrl = "https://jsonplaceholder.typicode.com/";
  // Auth
  static const String login = '/auth/login';
  static const String logout = '/auth/logout';
  static String currentUser(id) => '/users/$id';
  static const String refreshToken = '/auth/refresh';
  static const String profile = '/auth/profile';

  // Wallet
  static const String balance = '/wallet/balance';
  static const String sendMoney = '/wallet/transfer';

  // Transactions
  static const String transactionList = 'todos';
  static String transactionDetail(String id) => '/transactions/$id';
}
