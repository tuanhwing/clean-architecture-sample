
import 'package:formz/formz.dart';
import 'package:example_dependencies/example_dependencies.dart';

///Phone input error enums
enum PhoneInputError {
  ///Invalid
  invalid,
}

/// class [PhoneInput] used to validate email
class PhoneInput extends FormzInput<String, PhoneInputError> {

  // Call super.pure to represent an unmodified form input.
  const PhoneInput.pure() : super.pure('');

  ///Call super.dirty to represent a modified form input.
  PhoneInput.dirty(String value) : super.dirty(value);

  @override
  PhoneInputError? validator(String? value) {
    if (value == null || !value.isValidPhoneNumber) {
      return PhoneInputError.invalid;
    }
    return null;
  }
}