
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

  final TextEditingController _usernameTEC = TextEditingController();
  final TextEditingController _passwordTEC = TextEditingController();
  final TextEditingController _confirmPasswordTEC = TextEditingController();
  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();
  final FocusNode _confirmPasswordFocusNode = FocusNode();

  @override
  void dispose() {
    _usernameTEC.dispose();
    _passwordTEC.dispose();
    _confirmPasswordTEC.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    _confirmPasswordFocusNode.dispose();

    super.dispose();
  }

  @override
  AppBar? get appBar => AppBar(
    centerTitle: true,
    title: Text(tr("register").allInCaps),
  );

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
              focusNode: _emailFocusNode,
              textInputAction: TextInputAction.next,
              onSubmitted: (String value) {
                FocusScope.of(context).requestFocus(_passwordFocusNode);
              },
              icon: const Icon(
                  Icons.person
              ),
            ),
            const SizedBox(height: dependencies.Dimens.size16,),
            RoundedPasswordTextField(
              hintText: tr("password").inCaps,
              textEditingController: _passwordTEC,
              focusNode: _passwordFocusNode,
              textInputAction: TextInputAction.next,
              onSubmitted: (String value) {
                FocusScope.of(context).requestFocus(_confirmPasswordFocusNode);
              },
            ),
            const SizedBox(height: dependencies.Dimens.size16,),
            RoundedPasswordTextField(
              hintText: tr("confirm_password").inCaps,
              textEditingController: _confirmPasswordTEC,
              focusNode: _confirmPasswordFocusNode,
              textInputAction: TextInputAction.done,
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
              title: tr("already_have_an_account").inCaps + "?",
              subTitle: tr("login").inCaps,
              onTap: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
      ),
    ),
  );

}