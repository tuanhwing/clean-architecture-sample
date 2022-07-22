
import 'package:flutter/material.dart';
import 'package:th_core/th_core.dart';

import '../../blocs/blocs.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _SettingsState();
}

class _SettingsState extends THState<SettingsPage, SettingsBloc> {

  void _changeLanguage() {
    String localeString = context.locale.toString();
    late Locale locale = const Locale('en');
    if (localeString == 'vi') {
      locale = const Locale('en');
    }
    else {
      locale = const Locale('vi');
    }
    context.setLocale(locale);
  }

  @override
  void onRetry() {
    bloc.add(const SettingInitializationEvent());
  }

  @override
  void initState() {
    super.initState();
    bloc.add(const SettingInitializationEvent());
  }

  @override
  void onPageStateChanged(THPageState state) {
    super.onPageStateChanged(state);

    print ("AAAAAAAAA onPageStateChanged $state");
  }

  @override
  Widget get content {
    String locale = context.locale.toString();
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          BlocBuilder<SettingsBloc, SettingsState>(
            buildWhen: (previous, current) => previous.count != current.count,
            builder: (_, state) {
              return Text('Settings [countState:${state.count}]');
            },
          ),
          TextButton(
              onPressed: () {
                bloc.add(const LogoutEvent());
              },
              child: const Text('Logout')
          ),
          TextButton(
              onPressed: _changeLanguage,
              child: Text('Change language [$locale]')
          ),
          TextButton(
              onPressed: () {
                bloc.add(const SettingInitializationErrorEvent());
              },
              child: const Text('Refresh error')
          )
        ],
      ),
    );
  }

}