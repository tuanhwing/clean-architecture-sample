
import 'package:example_dependencies/example_dependencies.dart' as dependencies;
import 'package:flutter/material.dart';
import 'package:otp_text_field/otp_field.dart';
import 'package:otp_text_field/otp_field_style.dart';
import 'package:otp_text_field/style.dart';
import 'package:th_core/th_core.dart';

import '../../blocs/code_verification/code_verification.dart';
import '../../widgets/widgets.dart';

///Code verification param
class CodeVerificationParam {
  ///Constructor
  const CodeVerificationParam({
    required this.verificationID,
    required this.dialCode,
    required this.phoneNumber,
  });
  ///verificationID
  final String verificationID;
  ///dialCode
  final String dialCode;
  ///phoneNumber
  final String phoneNumber;
}

///Code verification page
class CodeVerificationPage extends StatefulWidget {
  ///Constructor
  const CodeVerificationPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _CodeVerificationState();
}

class _CodeVerificationState
    extends THState<CodeVerificationPage, CodeVerificationBloc> {

  CodeVerificationParam? get _param =>
      ModalRoute.of(context)!.settings.arguments as CodeVerificationParam?;

  final OtpFieldController _controller = OtpFieldController();

  String get _fullPhoneNumber {
    CodeVerificationParam? param = _param;
    return (param?.dialCode ?? '') + ' ' + (param?.phoneNumber ?? '');
  }

  @override
  void onPostFrame() {
    super.onPostFrame();
    _controller.setFocus(0);
    bloc.add(const TimerStarted());
  }

  @override
  void handleOutsideTap() {}

  @override
  Widget get content {
    CodeVerificationParam? param = _param;
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
                            title: tr('verification').inCaps,
                            description: tr('we_sent_you_an_sms_code').inCaps,
                          ),
                        ),
                        const SizedBox(height: dependencies.Dimens.size4,),
                        _OnNumberWidget(
                          phoneNumber: _fullPhoneNumber,
                        ),
                        const SizedBox(height: dependencies.Dimens.size32,),
                        _OTPWidget(
                          onCompleted: (String? pin) => bloc
                              .add(CodeVerificationSubmitEvent(
                                  pin: pin ?? '',
                                  verificationID: param?.verificationID ?? '')),
                          onChanged: (String code) {
                            dependencies.THLogger().d('onChanged $code');
                          },
                          controller: _controller,
                        ),

                        const SizedBox(height: dependencies.Dimens.size32,),
                        _ResendWidget(
                          onResend: () =>
                              bloc.add(const ResendCodeVerificationEvent()),
                        ),
                        const SizedBox(height: dependencies.Dimens.size8,),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          )
      ),
    );
  }
}

class _OnNumberWidget extends StatelessWidget {
  const _OnNumberWidget({
    Key? key,
    this.phoneNumber,
  }) : super(key: key);
  final String? phoneNumber;

  @override
  Widget build(BuildContext context) {
    ThemeData _themeData = Theme.of(context);
    return Row(
      children: <Widget>[
        Text(
          tr('on_number').inCaps + ':',
          style: _themeData.textTheme.bodyText1?.copyWith(
            color: _themeData.hintColor
          ),
        ),
        const SizedBox(width: dependencies.Dimens.size4,),
        Text(
          phoneNumber ?? '',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: _themeData.textTheme.bodyText1?.copyWith(
            color: _themeData.colorScheme.primary
          ),
        ),
      ],
    );
  }
}

class _OTPWidget extends StatelessWidget {
  const _OTPWidget({
    Key? key,
    this.controller,
    required this.onCompleted,
    this.onChanged,
  }) : super(key: key);
  final Function(String) onCompleted;
  final Function(String)? onChanged;
  final OtpFieldController? controller;

  @override
  Widget build(BuildContext context) {
    ThemeData _themeData = Theme.of(context);
    return LayoutBuilder(
      builder: (_, BoxConstraints constraints) {
        return OTPTextField(
          length: 6,
          controller: controller,
          style: _themeData.textTheme.headline4!.copyWith(
            color: _themeData.colorScheme.primary
          ),
          otpFieldStyle: OtpFieldStyle(
            focusBorderColor: _themeData.colorScheme.primary,
            borderColor: _themeData.colorScheme.outline,
          ),
          width: constraints.maxWidth,
          fieldWidth: (constraints.maxWidth/7),
          textFieldAlignment: MainAxisAlignment.spaceAround,
          fieldStyle: FieldStyle.box,
          onCompleted: onCompleted,
          onChanged: onChanged,
        );
      },
    );
  }
}

class _ResendWidget extends StatelessWidget {
  const _ResendWidget({
    Key? key,
    this.onResend,
  }) : super(key: key);

  final VoidCallback? onResend;

  @override
  Widget build(BuildContext context) {
    ThemeData _themeData = Theme.of(context);
    String _resendText = tr('resend_new_code').allInCaps;
    final TextStyle? _resendTextStyle = _themeData.textTheme
        .headline6?.copyWith(
      fontWeight: FontWeight.bold,
    );

    return SafeArea(
      child: SizedBox(
        width: double.infinity,
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: dependencies.Dimens.size16
              ),
              child: Text(
                tr('code_not_received').inCaps + '?',
                style: _themeData.textTheme.bodyText1?.copyWith(
                  color: _themeData.hintColor
                ),
              ),
            ),
            dependencies.BlocBuilder<CodeVerificationBloc,
                    CodeVerificationState>(
                builder: (_, CodeVerificationState state) {
              String _durationString =
                  '${state.duration < 10 ? '0' : ''}${state.duration}s';
              return TextButton(
                  onPressed: state.duration <= 0 ? onResend : null,
                  style: TextButton.styleFrom(
                    textStyle: _resendTextStyle,
                  ),
                  child: Text(
                    state.duration <= 0
                        ? _resendText
                        : _durationString,
                  ),);
              }
            )
          ],
        ),
      ),
    );
  }
}

