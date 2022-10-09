
import 'package:example_dependencies/example_dependencies.dart';

class CountryCodeEntity extends Equatable {
  const CountryCodeEntity({
    required this.code,
    required this.name,
    required this.dialCode,
  });
  final String code;
  final String name;
  final String dialCode;

  static CountryCodeEntity defaultCountry() {
    return const CountryCodeEntity(
        code: "VN",
        dialCode: "+84",
        name: "Việt Nam"
    );
  }

  CountryCodeEntity copyWith({
    String? code,
    String? name,
    String? dialCode,
  }) {
    return CountryCodeEntity(
        code: code ?? this.code,
        name: name ?? this.name ,
        dialCode: dialCode ?? this.dialCode,
    );
  }

  factory CountryCodeEntity.fromJson(Map<String, dynamic> json) {
    return CountryCodeEntity(
        code: json['code'],
        name: json['name'],
        dialCode: json['dial_code']
    );
  }

  Map<String, dynamic> toJson() =>
      {
        'code': code,
        'name' : name,
        'dial_code' : dialCode,
      };

  @override
  List<Object?> get props => [code, name, dialCode];
}