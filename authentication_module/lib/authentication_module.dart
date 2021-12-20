library authentication_module;

import 'package:example_dependencies/example_dependencies.dart';
import 'package:flutter/material.dart';
import 'package:th_core/th_core.dart';

import 'src/routes/routes.dart';
import 'src/presentation/pages/pages.dart';
import 'src/presentation/blocs/blocs.dart';
import 'src/domain/domain.dart';
import 'src/data/data.dart';

/// Authentication module.
class AuthenticationModule extends THModule {
  AuthenticationModule({Key? key}) : super(key: key);

  static const routeName = Routes.root;

  static Future<void> initialize() async {
    // Data sources
    GetIt.I.registerLazySingleton<AuthenticationRemoteDataSource>(
      () => AuthenticationRemoteDataSourceImpl(
        GetIt.I.get(),
        GetIt.I.get(),
      )
    );
    GetIt.I.registerLazySingleton<AuthenticationLocalDataSource>(() => AuthenticationLocalDataSourceImpl(GetIt.I.get()));

    //Repository
    GetIt.I.registerLazySingleton<AuthenticationRepository>(
      () => AuthenticationRepositoryImpl(
        localDataSource: GetIt.I.get(),
        remoteDataSource: GetIt.I.get(),
      )
    );

    //Use cases
    GetIt.I.registerLazySingleton<SignInUseCase>(() => SignInUseCase(GetIt.I.get()));


    //Blocs
    GetIt.I.registerFactory<LoginBloc>(() => LoginBloc(GetIt.I.get(), GetIt.I.get()));
    GetIt.I.registerFactory<RegisterBloc>(() => RegisterBloc());

    //Pages
    GetIt.I.registerFactory<Widget>(() => const LoginPage(), instanceName: Routes.login);
    GetIt.I.registerFactory<Widget>(() => const RegisterPage(), instanceName: Routes.register);
  }

  @override
  String get initialRoute => Routes.login;
}
