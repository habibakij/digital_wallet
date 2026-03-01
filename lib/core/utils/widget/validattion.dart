class Validators {
  static String? email(String value) {
    if (value.isEmpty) return "Email is required";

    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');

    if (!emailRegex.hasMatch(value)) {
      return "Invalid email";
    }

    return null;
  }

  static String? password(String value) {
    if (value.isEmpty) return "Password is required";
    if (value.length < 6) return "Minimum 6 characters";
    return null;
  }
}
