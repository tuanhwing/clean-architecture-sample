library home_module;

import 'package:flutter/material.dart';
import 'package:example_dependencies/example_dependencies.dart';
import 'package:home_module/src/presentation/pages/home/home_page.dart';

import 'src/routes/routes.dart';
import 'src/presentation/pages/pages.dart';
import 'src/presentation/blocs/blocs.dart';

/// Home module.
class HomeModule extends THModule {
  ///Constructor
  HomeModule({Key? key}) : super(key: key);

  ///Root of route name
  static const String routeName = Routes.root;

  ///Initialization
  static Future<void> initialize() async {
    //Blocs
    GetIt.I.registerFactory<SettingsBloc>(() => SettingsBloc());
    GetIt.I.registerFactory<HomeBloc>(
        () => HomeBloc(
          GetIt.I.get<FetchProfileUseCase>(),
          GetIt.I.get<GetCachedProfileUseCase>(),
          GetIt.I.get<LogoutUseCase>(),
        ));

    //Pages
    GetIt.I.registerFactory<Widget>(
      () => const HomePage(),
      instanceName: Routes.front
    );
    GetIt.I.registerFactory<Widget>(
      () => const SettingsPage(),
      instanceName: Routes.settings
    );
  }

  @override
  String get initialRoute => Routes.front;
}
