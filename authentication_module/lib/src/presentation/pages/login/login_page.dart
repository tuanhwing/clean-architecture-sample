
import 'package:example_dependencies/example_dependencies.dart' as dependencies;
import 'package:flutter/material.dart';
import 'package:th_core/th_core.dart';
import 'package:formz/formz.dart';

import '../../blocs/login/login.dart';
import '../../widgets/widgets.dart';
import '../../../routes/routes.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _LoginState();

}

class _LoginState extends THState<LoginPage, LoginBloc> {
  final TextEditingController _usernameTEC = TextEditingController();
  final TextEditingController _passwordTEC = TextEditingController();
  final FocusNode _userNameFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();

  @override
  void onRetry() {
    super.onRetry();
  }

  @override
  void initState() {
    super.initState();
    _usernameTEC.addListener(() {
      bloc.add(UserNameChangedEvent(_usernameTEC.text));
    });
    _passwordTEC.addListener(() {
      bloc.add(PasswordChangedEvent(_passwordTEC.text));
    });
  }

  @override
  void dispose() {
    _usernameTEC.dispose();
    _passwordTEC.dispose();
    _userNameFocusNode.dispose();
    _passwordFocusNode.dispose();

    super.dispose();
  }

  @override
  Widget get content => Center(
    child: Container(
      padding: const EdgeInsets.symmetric(
        horizontal: dependencies.Dimens.size32
      ),
      constraints: const BoxConstraints(
        maxWidth: dependencies.Dimens.size400
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const HeaderAuthenticationWidget(),

            RoundedTextField(
              textEditingController: _usernameTEC,
              hintText: tr("email").inCaps,
              textInputAction: TextInputAction.next,
              focusNode: _userNameFocusNode,
              icon: const Icon(
                Icons.person
              ),
              onSubmitted: (String value) {
                FocusScope.of(context).requestFocus(_passwordFocusNode);
              },
            ),
            const SizedBox(height: dependencies.Dimens.size16,),
            RoundedPasswordTextField(
              hintText: tr("password").inCaps,
              textEditingController: _passwordTEC,
              focusNode: _passwordFocusNode,
              textInputAction: TextInputAction.done,
            ),
            const _ForgotPassword(),
            const SizedBox(height: dependencies.Dimens.size32,),
            BlocBuilder<LoginBloc, LoginState>(
              buildWhen: (previous, current) => previous.status != current.status,
              builder: (_, state) {
                return RoundedButton(
                  title: tr("login").toUpperCase(),
                  textColor: themeData.scaffoldBackgroundColor,
                  onPressed: state.status.isValidated ? () {
                    FocusScope.of(context).requestFocus(FocusNode());
                    bloc.add(const LoginSubmitEvent());
                  } : null,
                );
              },
            ),
            const SizedBox(height: dependencies.Dimens.size32,),
            AlreadyHaveAnAccountWidget(
              title: tr("do_not_have_an_account").inCaps + "?",
              subTitle: tr("register").inCaps,
              onTap: () {
                Navigator.of(context).pushNamed(Routes.register);
              },
            )
          ],
        ),
      ),
    )
  );
}

class _ForgotPassword extends StatelessWidget {
  const _ForgotPassword({Key? key, this.onTap}) : super(key: key);
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        TextButton(
          onPressed: onTap,
          child: Text(
            tr("forget_password").inCaps+"?",
            style: themeData.textTheme.subtitle2!.apply(
              fontWeightDelta: 2,
              color: themeData.primaryColor.withOpacity(0.5)
            )
          ),
        )

      ],
    );
  }
}