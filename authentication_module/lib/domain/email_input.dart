
import 'package:example_dependencies/example_dependencies.dart';
import 'package:formz/formz.dart';

///Email input error enums
enum EmailInputError {
  ///Invalid
  invalid,
}

/// class [EmailInput] used to validate email
class EmailInput extends FormzInput<String, EmailInputError> {

  // Call super.pure to represent an unmodified form input.
  const EmailInput.pure() : super.pure('');

  ///Call super.dirty to represent a modified form input.
  EmailInput.dirty(String value) : super.dirty(value);

  @override
  EmailInputError? validator(String? value) {
    if (value == null || value.trim().isEmpty || !value.trim().isValidEmail) {
      return EmailInputError.invalid;
    }
    return null;
  }
}