
import '../../domain/entities/entities.dart';

class UserModel extends User {
  const UserModel({
    required String code,
    required String name,
  }) : super(code: code, name: name);

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      code: json['code'],
      name: json['name'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['code'] = code;
    data['name'] = name;
    return data;
  }

}
