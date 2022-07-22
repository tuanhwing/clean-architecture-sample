
import 'package:flutter/material.dart';
import 'package:th_core/th_core.dart';

import '../../blocs/blocs.dart';
import '../../../routes/routes.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _HomeState();
}

class _HomeState extends THState<HomePage, HomeBloc> {

  int _selectedIndex = 0;
  final List<Widget> _widgetOptions = [
    const Center(
      child: Text(
        'Index 0: Home'
      ),
    ),
    GetIt.I.get<Widget>(instanceName: Routes.settings),
  ];

  @override
  // TODO: implement bottomNavigationBar
  Widget? get bottomNavigationBar => BottomNavigationBar(
    currentIndex: _selectedIndex,
    onTap: (index) {
      setState(() {
        _selectedIndex = index;
      });
    },
    items: <BottomNavigationBarItem>[
      BottomNavigationBarItem(
        icon: const Icon(Icons.home),
        label: tr("home").inCaps,
      ),
      BottomNavigationBarItem(
        icon: const Icon(Icons.settings),
        label: tr("settings").inCaps,
      ),
    ],
  );

  @override
  Widget get content => _widgetOptions.elementAt(_selectedIndex);



}