class InputValidator {
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) return 'Email is required';
    final regex = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
    if (!regex.hasMatch(value)) return 'Please enter a valid email';
    return null;
  }

  static String? validateName(String? value) {
    if (value == null || value.trim().isEmpty) return 'Name is required';
    final trimmed = value.trim();
    if (!RegExp(r'^[a-zA-Z\s]+$').hasMatch(trimmed)) return 'Name must contain letters only';
    if (trimmed.length < 2) return 'Name must be at least 3 characters';
    if (trimmed.length > 50) return 'Name must be at most 50 characters';
    return null;
  }

  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) return 'Password is required';
    if (value.length < 4) return 'Minimum 4 characters';
    if (value.length > 8) return 'Maximum 8 characters';
    if (!RegExp(r'[A-Z]').hasMatch(value)) return 'Must contain an uppercase letter';
    if (!RegExp(r'[0-9]').hasMatch(value)) return 'Must contain a number';
    if (!RegExp(r'[!@#\$%^&*(),.?":{}|<>_\-+=\[\]\\\/`~;]').hasMatch(value)) return 'Must contain at least 1 special char';
    return null;
  }

  static String? validateAmount(String? value) {
    if (value == null || value.isEmpty) return 'Amount is required';
    final amount = double.tryParse(value);
    if (amount == null) return 'Enter a valid amount';
    if (amount <= 0) return 'Amount must be greater than 0';
    if (amount > 50000) return 'Amount cannot exceed ৳ 50,000';
    return null;
  }

  static String? validateAccountNumber(String? value) {
    if (value == null || value.isEmpty) return 'Account number is required';
    if (value.length < 10) return 'Enter a valid account number';
    return null;
  }
}
