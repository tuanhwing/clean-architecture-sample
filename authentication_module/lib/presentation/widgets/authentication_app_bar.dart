
import 'package:flutter/material.dart';
import 'package:example_dependencies/example_dependencies.dart' as dependencies;

///Authentication app bar
class AuthenticationAppBar extends StatelessWidget {
  ///Constructor
  const AuthenticationAppBar({
    Key? key,
    this.onBack,
  }) : super(key: key);

  ///On back icon tap
  final VoidCallback? onBack;

  @override
  Widget build(BuildContext context) {
    ThemeData _themeData = Theme.of(context);
    return Align(
      alignment: Alignment.centerLeft,
      child: GestureDetector(
        onTap: onBack,
        child: Padding(
          padding: const EdgeInsets.all(dependencies.Dimens.size16),
          child: Icon(
            Icons.arrow_back_ios,
            color: _themeData.colorScheme.primary,
          ),
        ),
      ),
    );
  }
}
