
///String extension
extension THStringExtension on String {
  ///Upper case first character
  String get inCaps => '${this[0].toUpperCase()}${substring(1)}';
  ///Upper case all characters
  String get allInCaps => toUpperCase();
  ///Upper case first character each word in string
  String get capitalizeFirsTofEach =>
      split(' ').map((String str) => str.inCaps).join(' ');
}
