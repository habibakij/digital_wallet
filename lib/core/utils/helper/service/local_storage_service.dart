import 'package:shared_preferences/shared_preferences.dart';

class LocalStorageService {
  Future<void> saveEmail(String email) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('remember_email', email);
  }

  Future<String?> getEmail() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('remember_email');
  }
}
