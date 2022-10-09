
import 'package:country_selection/domain/entities/entities.dart';

///Abstract class phone verification event
abstract class PhoneVerificationEvent {
  ///Constructor
  const PhoneVerificationEvent();
}

///Submit phone
class PhoneSubmitEvent extends PhoneVerificationEvent {
  ///Constructor
  const PhoneSubmitEvent(this.newBie);

  ///New member or not
  final bool newBie;
}

///Phone number changed
class PhoneNumberChangedEvent extends PhoneVerificationEvent {
  ///Constructor
  const PhoneNumberChangedEvent(this.value);
  ///String of phone number
  final String value;
}

///Country changed
class CountryChangedEvent extends PhoneVerificationEvent {
  ///Constructor
  const CountryChangedEvent(this.entity);
  ///Variable of country
  final CountryCodeEntity entity;
}
