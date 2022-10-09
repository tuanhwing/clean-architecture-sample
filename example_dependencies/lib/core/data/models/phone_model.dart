import '../../domain/entities/entities.dart';

///UserModel
class PhoneModel extends Phone {
  ///Constructor
  const PhoneModel({
    required String dialCode,
    required String phoneNumber,
    required String fullPhoneNumber,
  }) : super(
            dialCode: dialCode,
            phoneNumber: phoneNumber,
            fullPhoneNumber: fullPhoneNumber);

  ///Factory constructor
  factory PhoneModel.fromJson(Map<String, dynamic> json) {
    return PhoneModel(
      dialCode: json['dial_code'],
      phoneNumber: json['phone_number'],
      fullPhoneNumber: json['full_phone_number'],
    );
  }

  ///toJson
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['dial_code'] = dialCode;
    data['phone_number'] = phoneNumber;
    data['full_phone_number'] = fullPhoneNumber;
    return data;
  }

}
