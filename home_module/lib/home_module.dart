library home_module;

import 'package:flutter/material.dart';
import 'package:home_module/src/presentation/pages/home/home_page.dart';
import 'package:th_core/th_core.dart';

import 'src/routes/routes.dart';
import 'src/presentation/pages/pages.dart';
import 'src/presentation/blocs/blocs.dart';

/// Home module.
class HomeModule extends THModule {
  HomeModule({Key? key}) : super(key: key);

  static final routeName = Routes.root;

  static Future<void> initialize() async {
    //Blocs
    GetIt.I.registerFactory<SettingsBloc>(() => SettingsBloc(GetIt.I.get()));
    GetIt.I.registerFactory<HomeBloc>(() => HomeBloc());

    //Pages
    GetIt.I.registerFactory<Widget>(() => const HomePage(), instanceName: Routes.front);
    GetIt.I.registerFactory<Widget>(() => const SettingsPage(), instanceName: Routes.settings);
  }

  @override
  String get initialRoute => Routes.front;
}
