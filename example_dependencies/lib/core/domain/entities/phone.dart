import 'package:equatable/equatable.dart';

///User
class Phone extends Equatable {
  ///Constructor
  const Phone(
      {required this.dialCode,
      required this.phoneNumber,
      required this.fullPhoneNumber});

  ///dialCode
  final String dialCode;
  ///phoneNumber
  final String phoneNumber;
  ///fullPhoneNumber
  final String fullPhoneNumber;

  @override
  List<Object?> get props => <Object?>[
    dialCode,
    phoneNumber,
    fullPhoneNumber,
  ];

  ///Return Map<String, dynamic> object
  Map<String, dynamic> toJson() {
    throw UnimplementedError();
  }
}