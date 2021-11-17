
import 'package:example_dependencies/extensions/string_extension.dart';
import 'package:formz/formz.dart';

enum EmailInputError { invalid }

class EmailInput extends FormzInput<String, EmailInputError> {

  // Call super.pure to represent an unmodified form input.
  const EmailInput.pure() : super.pure('');

  EmailInput.dirty(String value) : super.dirty(value);

  @override
  EmailInputError? validator(String? value) {
    if (value == null || value.trim().isEmpty || !value.trim().isValidEmail()) {
      return EmailInputError.invalid;
    }
    return null;
  }
}