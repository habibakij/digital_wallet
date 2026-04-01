import 'package:digital_wallet/core/network/api_client.dart';

class ApiService {
  Future<String?> getProducts() async {
    try {
      final response = await ApiClient().get("/products");
      return response.toString();
    } catch (e) {
      throw Exception('Error: $e');
    }
  }
}
