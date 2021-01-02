class ValidationMixing {
  String validateEmail(val) {
    if (val.contains("@") && val.contains(".")) return null;
    return "Email address not valid";
  }

  String validatePassword(val) {
    if (val.length >= 2) return null;
    return "Password too short";
  }

  String isEmptyValidation(val) {
    if (val.isNotEmpty) return null;
    return "Cannot be empty";
  }
}
