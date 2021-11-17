
import 'package:example_dependencies/example_dependencies.dart' as dependencies;
import 'package:flutter/material.dart';
import 'package:th_core/th_core.dart';

import '../../blocs/register/register.dart';
import '../../widgets/widgets.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _RegisterState();
}

class _RegisterState extends THState<RegisterPage, RegisterBloc>  {
  _RegisterState() : super(GetIt.I.get<RegisterBloc>());

  final TextEditingController _usernameTEC = TextEditingController();
  final TextEditingController _passwordTEC = TextEditingController();
  final TextEditingController _confirmPasswordTEC = TextEditingController();

  @override
  void dispose() {
    _usernameTEC.dispose();
    _passwordTEC.dispose();
    _confirmPasswordTEC.dispose();

    super.dispose();
  }

  @override
  AppBar? get appBar => AppBar(
    centerTitle: true,
    title: Text(tr("register").allInCaps),
  );

  @override
  Widget get content => SafeArea(
      child: Container(
        padding: const EdgeInsets.symmetric(
            horizontal: dependencies.Dimens.size32
        ),
        constraints: const BoxConstraints(
            maxWidth: dependencies.Dimens.size400
        ),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const HeaderAuthenticationWidget(),

            RoundedTextField(
              textEditingController: _usernameTEC,
              hintText: tr("email").capitalize,
              icon: const Icon(
                  Icons.person
              ),
            ),
            const SizedBox(height: dependencies.Dimens.size16,),
            RoundedPasswordTextField(
              hintText: tr("password").capitalize,
              textEditingController: _passwordTEC,
            ),
            const SizedBox(height: dependencies.Dimens.size16,),
            RoundedPasswordTextField(
              hintText: tr("confirm_password").capitalize,
              textEditingController: _confirmPasswordTEC,
            ),
            const SizedBox(height: dependencies.Dimens.size32,),
            RoundedButton(
              title: tr("register").toUpperCase(),
              textColor: themeData.scaffoldBackgroundColor,
              onPressed: () {
                bloc.add(const RegisterSubmitEvent());
              },
            ),
            const SizedBox(height: dependencies.Dimens.size32,),
            AlreadyHaveAnAccountWidget(
              title: tr("already_have_an_account").capitalize + "?",
              subTitle: tr("login").capitalize,
              onTap: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
      )
  );

}