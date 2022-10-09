
import 'package:country_selection/country_selection.dart';
import 'package:formz/formz.dart';
import 'package:example_dependencies/example_dependencies.dart' as dependencies;
import 'package:flutter/material.dart';
import 'package:th_core/th_core.dart';

import '../../../routes/routes.dart';
import '../../widgets/widgets.dart';
import '../../blocs/blocs.dart';
import '../code_verification/code_verification_page.dart';

///Phone verification page
class PhoneVerificationPage extends StatefulWidget {
  ///Constructor
  const PhoneVerificationPage({Key? key})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _PhoneVerificationState();
}

class _PhoneVerificationState
    extends THState<PhoneVerificationPage, PhoneVerificationBloc> {

  final TextEditingController _phoneTEC = TextEditingController();
  final FocusNode _phoneFocusNode = FocusNode();

  bool? get _newBie =>
      ModalRoute.of(context)!.settings.arguments as bool?;

  void _showCountrySelection() async {
    CountryCodeEntity? entity = await showModalBottomSheet<CountryCodeEntity>(
        context: context,
        backgroundColor: Theme.of(context).selectedRowColor,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(dependencies.Dimens.size32),
            topLeft: Radius.circular(dependencies.Dimens.size32),
          ),
        ),
        isScrollControlled: true,
        builder: (BuildContext context) {
          return dependencies.BottomSheetWidget(
              child: CountrySelectionPage(
                initialCountryCodeEntity: bloc.state.countryCodeEntity,
              )
          );
        });
    dependencies.THLogger().d('${entity?.name}');
    if (entity != null && entity != bloc.state.countryCodeEntity) {
      bloc.add(CountryChangedEvent(entity));
    }
  }

  @override
  void initState() {
    super.initState();
    _phoneTEC.addListener(() {
      bloc.add(PhoneNumberChangedEvent(_phoneTEC.text));
    });
  }

  @override
  void onPostFrame() {
    super.onPostFrame();
    _phoneFocusNode.requestFocus();
  }

  @override
  void handleOutsideTap() {}

  @override
  void dispose() {
    _phoneFocusNode.unfocus();
    _phoneTEC.dispose();
    _phoneFocusNode.dispose();

    super.dispose();
  }

  @override
  void onPageStateChanged(dependencies.THWidgetState<dynamic> state) {
    super.onPageStateChanged(state);

    if (state is InputPhoneCompletedState) {
      Navigator.of(context).pushNamed(Routes.codeVerification,
        arguments: CodeVerificationParam(
          verificationID: state.verificationID,
          dialCode: bloc.state.countryCodeEntity.dialCode,
          phoneNumber: bloc.state.phone.value
        )
      );
    }
  }

  @override
  Widget get content {
    bool newBie = _newBie ?? false;
    return SafeArea(
      child: Container(
        constraints: const BoxConstraints(
          maxWidth: dependencies.Dimens.maxWidthPhone
        ),
        child: Column(
          children: <Widget>[
            AuthenticationAppBar(
              onBack: () {
                Navigator.of(context).pop();
              },
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: dependencies.Dimens.size16
                ),
                child: SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      const SizedBox(height: dependencies.Dimens.size32,),
                      SizedBox(
                        width: double.infinity,
                        child: AuthenticationHeaderWidget(
                          title: tr('welcome').inCaps,
                          description: tr('registration_description').inCaps,
                        ),
                      ),
                      const SizedBox(height: dependencies.Dimens.size32,),
                      _RegistrationPhoneInputWidget(
                        onCountryTap: _showCountrySelection,
                        controller: _phoneTEC,
                        focusNode: _phoneFocusNode,
                        onSubmitted: (_) => bloc.add(PhoneSubmitEvent(newBie)),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            _InputPhoneNextButton(
              onTap: () => bloc.add(PhoneSubmitEvent(newBie)),
            ),
          ],
        )
      ),
    );
  }
}

class _RegistrationPhoneInputWidget extends StatelessWidget {
  const _RegistrationPhoneInputWidget({
    Key? key,
    this.onCountryTap,
    this.controller,
    this.focusNode,
    this.onSubmitted,
  }) : super(key: key);
  final VoidCallback? onCountryTap;
  final Function(String?)? onSubmitted;
  final TextEditingController? controller;
  final FocusNode? focusNode;

  @override
  Widget build(BuildContext context) {
    ThemeData _themeData = Theme.of(context);
    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: _themeData.hintColor)
        )
      ),
      child: Row(
        children: <Widget>[
          dependencies.BlocBuilder<PhoneVerificationBloc,
                  PhoneVerificationState>(
              buildWhen: (PhoneVerificationState previous,
                      PhoneVerificationState current) =>
                  previous.countryCodeEntity != current.countryCodeEntity,
              builder: (BuildContext context, PhoneVerificationState state) {
              return CountryCodeWidget(
                code: state.countryCodeEntity.dialCode,
                onTap: onCountryTap,
              );
            }
          ),
          Container(
            width: dependencies.Dimens.size1,
            height: dependencies.Dimens.size24,
            color: _themeData.hintColor,
          ),
          Expanded(
            child: TextField(
              controller: controller,
              keyboardType: TextInputType.number,
              onSubmitted: onSubmitted,
              style: _themeData.textTheme.titleLarge
                  ?.copyWith(
                  color: _themeData
                      .colorScheme.onBackground),
              focusNode: focusNode,
              decoration: InputDecoration(
                  fillColor: Colors.transparent,
                  hintText: dependencies
                      .tr('phone_number')
                      .inCaps,
                  focusedBorder: InputBorder.none),
            ),
          )
        ],
      ),
    );
  }
}

class _InputPhoneNextButton extends StatelessWidget {
  const _InputPhoneNextButton({
    Key? key,
    required this.onTap,
  }) : super(key: key);
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    ThemeData _themeData = Theme.of(context);
    PhoneVerificationBloc _bloc = BlocProvider.of<PhoneVerificationBloc>(
        context);
    return Padding(
      padding: const EdgeInsets.all(dependencies.Dimens.size16),
      child: Column(
        children: <Widget>[
          dependencies.BlocBuilder<PhoneVerificationBloc,
                  PhoneVerificationState>(
              buildWhen: (PhoneVerificationState previous,
                      PhoneVerificationState current) =>
                  previous.formStatus != current.formStatus,
              builder: (BuildContext context, PhoneVerificationState state) {
              return Column(
                children: <Widget>[
                  ElevatedButton(
                    onPressed: state.formStatus.isValid
                            ? onTap
                            : null,
                      child: dependencies.BlocBuilder<
                          dependencies.THWidgetCubit, THWidgetState<dynamic>>(
                        bloc: _bloc.nextButtonBloc,
                      builder: (_, THWidgetState<dynamic> state) {
                        return state is dependencies.WidgetLoading ? Container(
                            width: dependencies.Dimens.size40,
                            height: dependencies.Dimens.size40,
                            alignment: Alignment.center,
                            child: const SizedBox(
                                width: dependencies.Dimens.size24,
                                height: dependencies.Dimens.size24,
                                child: CircularProgressIndicator()
                            )
                        ) : const Icon(
                          Icons.navigate_next_rounded,
                          size: dependencies.Dimens.size40,
                        );
                      },
                    ),
                    style: ButtonStyle(
                      shape: MaterialStateProperty.all(const CircleBorder()),
                      padding: MaterialStateProperty.all(
                        const EdgeInsets.all(dependencies.Dimens.size12)
                      ),
                    ),
                  ),
                  const SizedBox(height: dependencies.Dimens.size4,),
                  Text(
                    dependencies.tr('next').inCaps,
                    style: _themeData.textTheme.bodyText2?.copyWith(
                          color: state.formStatus.isValidated
                              ? null
                              : _themeData.disabledColor),
                  ),
                ],
              );
            }
          ),
        ],
      ),
    );
  }
}
