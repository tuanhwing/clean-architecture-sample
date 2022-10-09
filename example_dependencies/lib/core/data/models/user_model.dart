
import '../../domain/entities/entities.dart';
import 'phone_model.dart';

///UserModel
class UserModel extends User {
  ///Constructor
  const UserModel({
    required String id,
    required String name,
    required PhoneModel phoneModel,
  }) : super(id: id, name: name, phone: phoneModel);

  ///Factory constructor
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      name: json['name'],
      phoneModel: PhoneModel.fromJson(json['phone'] ?? <String, dynamic>{})
    );
  }

  ///toJson
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['phone'] = phone.toJson();
    return data;
  }

}
