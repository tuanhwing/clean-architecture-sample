
import 'package:country_selection/country_selection.dart';
import 'package:formz/formz.dart';
import 'package:example_dependencies/example_dependencies.dart';

import '../../../domain/domain.dart';

///Phone Verification state
class PhoneVerificationState extends Equatable {
  ///Constructor
  const PhoneVerificationState({
    required this.countryCodeEntity,
    this.formStatus = FormzStatus.pure,
    this.phone = const PhoneInput.pure(),
  });

  ///Country information
  final CountryCodeEntity countryCodeEntity;
  ///Form's status
  final FormzStatus formStatus;
  ///Phone input
  final PhoneInput phone;

  ///Phone = dial code + phone number
  String get fullPhoneNumber => countryCodeEntity.dialCode + phone.value;

  ///Return new instance and copy all value not in params
  PhoneVerificationState copyWith({
    FormzStatus? formStatus,
    CountryCodeEntity? countryCodeEntity,
    PhoneInput? phone,
    bool? isProcessing,
  }) {
    return PhoneVerificationState(
      formStatus: formStatus ?? this.formStatus,
      countryCodeEntity: countryCodeEntity ?? this.countryCodeEntity,
      phone: phone ?? this.phone,
    );
  }

  @override
  List<Object?> get props =>
      <Object?>[countryCodeEntity, formStatus, phone];
}

///Phone processing completed
class InputPhoneCompletedState extends THWidgetState<void> {
  ///Constructor
  const InputPhoneCompletedState(this.verificationID) : super();

  ///verificationID
  final String verificationID;

  @override
  bool operator ==(Object other) => false;

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  List<Object?> get props => <Object?>[verificationID];

}
