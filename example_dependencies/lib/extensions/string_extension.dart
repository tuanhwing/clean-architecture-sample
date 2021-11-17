
extension StringExtension on String {
  static const needleRegex = r'{#}';
  static const needle = '{#}';
  static final RegExp exp = RegExp(needleRegex);

  ///is integer value
  bool isInt() {
    bool result = false;
    try {
      int? temp = int.tryParse(this);
      result = temp != null;
    }
    catch(_) {}
    return result;
  }

  static bool isNullOrEmpty(String? string) {
    return string == null || string.isEmpty;
  }

  bool isValidEmail() {
    if (trim().isEmpty) return false;
    return RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(this);
  }

  bool isValidOTPCode() {
    if (trim().isEmpty) return false;
    return RegExp(r'^[1-9]{6}$').hasMatch(this);
  }

  bool isValidPhoneNumber() {
    if (trim().isEmpty) return false;
    RegExp regExp = RegExp(r"^[1-9]{9,11}$");
    return regExp.hasMatch(this);
  }

  bool isValidPassword() {
    if (trim().isEmpty) return false;
    RegExp regex =
    RegExp(r"^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[#?!@%^&*-]).{8,}");
    return regex.hasMatch(this);
  }

  bool isValidTaxCode() {
    if (trim().isEmpty) return false;
    RegExp regex = RegExp(r"^[0-9]{10}(?:[-][0-9]{3})?$");
    return regex.hasMatch(this);
  }

  ///format an interpolated String
  static String interpolate(String string, List l) {
    Iterable<RegExpMatch> matches = exp.allMatches(string);

    assert(l.length == matches.length);

    var i = -1;
    return string.replaceAllMapped(exp, (match) {
      i = i + 1;
      return '${l[i]}';
    });
  }

  ///Upcase function
  String get inCaps => '${this[0].toUpperCase()}${substring(1)}';
  String get allInCaps => toUpperCase();
  String get capitalizeFirsTofEach => split(" ").map((str) => str.inCaps).join(" ");
  String get capitalize {
    return "${this[0].toUpperCase()}${substring(1)}";
  }
}
