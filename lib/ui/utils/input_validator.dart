class InputValidator {
  static String? validateEmail(String? value) {
    if (value?.trim().isEmpty ?? true) {
      return "Email is required";
    }

    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    if (!emailRegex.hasMatch(value ?? '')) {
      return "Enter a valid email address";
    }
    return null;
  }

  static String? validatePassword(String? value) {
    if (value?.isEmpty ?? true) {
      return "Password is required";
    }
    return null;
  }

  static String? validateConfirmPassword(
    String? value,
    String originalPassword,
  ) {
    if (value?.isEmpty ?? true) {
      return "Confirm password is required";
    } else if (value != originalPassword) {
      return "Passwords do not match";
    }
    return null;
  }
}
