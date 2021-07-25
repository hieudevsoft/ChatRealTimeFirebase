extension validateEmail on String? {
  bool isValidEmail() {
    if (this == null || this!.isEmpty)
      return false;
    else
      return RegExp(
              r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
          .hasMatch(this!);
  }
}

extension validatePass on String? {
  bool isValidPass() {
    if (this == null || this!.isEmpty)
      return false;
    else
      return this!.length > 6;
  }
}

extension validateConfirmPass on String? {
  bool isValidConfirmPass(String? confirmPass) {
    if (this == null || this!.isEmpty || confirmPass == null)
      return false;
    else
      return this == confirmPass;
  }
}
