
import 'package:flutter/material.dart';
import 'package:example_dependencies/example_dependencies.dart' as dependencies;

import '../../../routes/routes.dart';

///WelcomePage
class WelcomePage extends StatefulWidget {
  ///Constructor
  const WelcomePage({Key? key}) : super(key: key);

  @override
  _WelcomePageState createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {

  ThemeData get _themeData => Theme.of(context);

  void _navigateToInputPhone(bool newBie) {
    Navigator.of(context)
        .pushNamed(Routes.inputPhone, arguments: newBie);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.all(dependencies.Dimens.size32),
          constraints: const BoxConstraints(
            maxWidth: dependencies.Dimens.maxWidthPhone,
            maxHeight: 900,//Max height
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Expanded(
                flex: 2,
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Text(
                   dependencies.tr('app_name').inCaps,
                   style: _themeData.textTheme.headline3?.copyWith(
                       fontWeight: FontWeight.bold
                   ),
                 ),
                ),
              ),
              const SizedBox(height: dependencies.Dimens.size16,),
              Expanded(
                flex: 1,
                child: Column(
                  children: <Widget>[
                    Text(
                      dependencies.tr('welcome_to').inCaps + ' ' +
                          dependencies.tr('app_name').inCaps + '!',
                      style: _themeData.textTheme.headline6,
                    ),
                    Text(
                      dependencies.tr('keeping_drivers_safety'),
                      style: _themeData.textTheme.titleMedium,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: dependencies.Dimens.size16,),
              dependencies.RoundedButton(
                onPressed: () => _navigateToInputPhone(false),
                backgroundColor: MaterialStateProperty.all(
                    _themeData.colorScheme.primary
                ),
                overlayColor: MaterialStateProperty.all(
                    _themeData.highlightColor
                ),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(dependencies.Dimens.size16),
                  alignment: Alignment.center,
                  child: Text(
                    dependencies.tr('login').inCaps,
                    style: _themeData.textTheme.titleMedium?.copyWith(
                      color: _themeData.selectedRowColor,
                      fontWeight: FontWeight.bold
                    ),
                  ),
                ),
              ),
              const SizedBox(height: dependencies.Dimens.size16,),
              dependencies.RoundedButton(
                onPressed: () => _navigateToInputPhone(true),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(dependencies.Dimens.size16),
                  alignment: Alignment.center,
                  child: Text(
                    dependencies.tr('newbie_sign_up_now').inCaps + '!',
                    style: _themeData.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
