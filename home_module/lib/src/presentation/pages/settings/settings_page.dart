
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:th_core/th_core.dart';

import '../../blocs/blocs.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _SettingsState();
}

class _SettingsState extends THState<SettingsPage, SettingsBloc> {
  _SettingsState() : super(GetIt.I.get<SettingsBloc>());

  @override
  Widget get content => Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        const Text('Settings'),
        TextButton(
          onPressed: () {
            bloc.add(LogoutEvent());
          },
          child: const Text('Logout')
        )
      ],
    ),
  );

}