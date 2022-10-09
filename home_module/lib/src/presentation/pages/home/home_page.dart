
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:th_core/th_core.dart';

import '../../blocs/blocs.dart';
import '../../../routes/routes.dart';

///Home page
class HomePage extends StatefulWidget {
  ///Constructor
  const HomePage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _HomeState();
}

class _HomeState extends THState<HomePage, HomeBloc>
    implements THNetworkListener {
  int _selectedIndex = 0;
  final List<Widget> _widgetOptions = <Widget>[
    const Center(
      child: Text(
        'Index 0: Home'
      ),
    ),
    GetIt.I.get<Widget>(instanceName: Routes.settings),
  ];

  @override
  void sessionExpired() {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => CupertinoAlertDialog(
          title: Text(tr('session_expired').inCaps),
          content: Text(
            tr('pls_login_again').inCaps + '!',
            style: themeData.textTheme.bodyText2,
          ),
          actions: <Widget>[
            CupertinoDialogAction(
              child: Text(tr('OK').inCaps),
              onPressed: () => bloc.add(const LogoutEvent()),
            )
          ],
        )
    );
  }

  @override
  void initState() {
    super.initState();
    GetIt.I.get<THNetworkRequester>().addListener(this);
  }

  @override
  void dispose() {
    GetIt.I.get<THNetworkRequester>().removeListener(this);
    super.dispose();
  }

  @override
  void onPostFrame() {
    super.onPostFrame();
    bloc.add(const FetchProfileEvent());
  }

  @override
  // TODO: implement bottomNavigationBar
  Widget? get bottomNavigationBar => BottomNavigationBar(
    currentIndex: _selectedIndex,
    onTap: (int index) {
      setState(() {
        _selectedIndex = index;
      });
    },
    items: <BottomNavigationBarItem>[
      BottomNavigationBarItem(
        icon: const Icon(Icons.home),
        label: tr('home').inCaps,
      ),
      BottomNavigationBarItem(
        icon: const Icon(Icons.settings),
        label: tr('settings').inCaps,
      ),
    ],
  );

  @override
  Widget get content => _widgetOptions.elementAt(_selectedIndex);
}