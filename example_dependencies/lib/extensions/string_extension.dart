
///String extensions
extension StringExtension on String {
  ///needleRegex
  static const String needleRegex = r'{#}';
  ///needle
  static const String needle = '{#}';
  ///RegExp
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

  ///String is null or empty
  static bool isNullOrEmpty(String? string) {
    return string == null || string.isEmpty;
  }

  ///String is valid email
  bool get isValidEmail {
    if (trim().isEmpty) return false;
    return RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(this);
  }

  ///String is valid otp code
  bool get isValidOTPCode {
    if (trim().isEmpty) return false;
    return RegExp(r'^[1-9]{6}$').hasMatch(this);
  }

  ///String is valid phone number
  bool get isValidPhoneNumber {
    if (trim().isEmpty) return false;
    RegExp regExp = RegExp(r'^[0-9]{9,11}$');
    return regExp.hasMatch(this);
  }

  ///String is valid password
  bool get isValidPassword {
    if (trim().isEmpty) return false;
    RegExp regex =
    RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[#?!@%^&*-]).{8,}');
    return regex.hasMatch(this);
  }

  ///String is valid tax code
  bool get isValidTaxCode {
    if (trim().isEmpty) return false;
    RegExp regex = RegExp(r'^[0-9]{10}(?:[-][0-9]{3})?$');
    return regex.hasMatch(this);
  }

  ///format an interpolated String
  static String interpolate(String string, List<dynamic> l) {
    Iterable<RegExpMatch> matches = exp.allMatches(string);

    assert(l.length == matches.length);

    int i = -1;
    return string.replaceAllMapped(exp, (Match match) {
      i = i + 1;
      return '${l[i]}';
    });
  }
}
