
import 'package:country_selection/country_selection.dart';
import 'package:formz/formz.dart';
import 'package:example_dependencies/example_dependencies.dart';

import '../../../domain/domain.dart';
import 'phone_verification_event.dart';
import 'phone_verification_state.dart';

///InputPhone bloc
class PhoneVerificationBloc
    extends THBaseBloc<PhoneVerificationEvent, PhoneVerificationState> {
  ///Constructor
  PhoneVerificationBloc(
      this._nextButtonBloc,
      this._signInUseCase,
      this._signUpUseCase
  ) : super(PhoneVerificationState(
    countryCodeEntity: CountryCodeEntity.defaultCountry()
  )) {
    on<PhoneSubmitEvent>(_onSubmit);
    on<PhoneNumberChangedEvent>(_onPhoneChanged);
    on<CountryChangedEvent>(_onCountryChanged);
  }

  final THWidgetCubit _nextButtonBloc;
  final SignInUseCase _signInUseCase;
  final SignUpUseCase _signUpUseCase;

  ///Get next button bloc
  THWidgetCubit get nextButtonBloc => _nextButtonBloc;

  void _onCountryChanged(
      CountryChangedEvent event,
      Emitter<PhoneVerificationState> emit) async {
    emit(state.copyWith(
      countryCodeEntity: event.entity,
    ));
  }

  void _onSubmit(
      PhoneSubmitEvent event, Emitter<PhoneVerificationState> emit) async {
    if (state.formStatus == FormzStatus.invalid) return;

    _nextButtonBloc.add(const WidgetLoading<void>());

    final Either<Failure, String> failureOrAuthenticated;
    if (!event.newBie) {//Sign in
      failureOrAuthenticated = await _signInUseCase.call(AuthenticationParams(
          dialCode: state.countryCodeEntity.dialCode,
          phone: state.phone.value));
    }
    else {//Sign up
      failureOrAuthenticated = await _signUpUseCase.call(AuthenticationParams(
          dialCode: state.countryCodeEntity.dialCode,
          phone: state.phone.value));
    }

    failureOrAuthenticated.fold(
      (Failure failure) => showError(message: failure.message ?? tr('unknown')),
      (String id) => pageCubit.add(InputPhoneCompletedState(id)),
    );

    _nextButtonBloc.add(const WidgetInitial<void>());
  }

  void _onPhoneChanged(
      PhoneNumberChangedEvent event,
      Emitter<PhoneVerificationState> emit) async {
    final PhoneInput phone = PhoneInput.dirty(event.value);
    emit(state.copyWith(
      phone: phone,
      formStatus: Formz.validate(
          <FormzInput<dynamic, dynamic>>[phone]
      ),
    ));
  }
}
