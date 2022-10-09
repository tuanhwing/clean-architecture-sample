library authentication_module;

import 'package:country_selection/country_selection.dart';
import 'package:example_dependencies/example_dependencies.dart';
import 'package:flutter/material.dart';
import 'package:th_core/th_core.dart';

import 'routes/routes.dart';
import 'presentation/pages/pages.dart';
import 'presentation/blocs/blocs.dart';
import 'domain/domain.dart';
import 'data/data.dart';

/// Authentication module.
class AuthenticationModule extends THModule {
  ///Constructor
  AuthenticationModule({Key? key}) : super(key: key);

  ///Root of route name
  static const String routeName = Routes.root;

  ///Initialization
  static Future<void> initialize() async {
    // Data sources
    GetIt.I.registerLazySingleton<AuthenticationRemoteDataSource>(
        () => AuthenticationRemoteDataSourceImpl(
              GetIt.I.get(),
              GetIt.I.get(),
            ));
    GetIt.I.registerLazySingleton<AuthenticationLocalDataSource>(
        () => AuthenticationLocalDataSourceImpl(GetIt.I.get()));

    //Repository
    GetIt.I.registerLazySingleton<AuthenticationRepository>(
        () => AuthenticationRepositoryImpl(
              localDataSource: GetIt.I.get(),
              remoteDataSource: GetIt.I.get(),
            ));

    //Use cases
    GetIt.I.registerLazySingleton<SignInUseCase>(
        () => SignInUseCase(GetIt.I.get()));
    GetIt.I.registerLazySingleton<SignUpUseCase>(
        () => SignUpUseCase(GetIt.I.get()));
    GetIt.I.registerLazySingleton<VerifyCodeUseCase>(
            () => VerifyCodeUseCase(GetIt.I.get()));

    //Blocs
    GetIt.I.registerFactory<CodeVerificationBloc>(
        () => CodeVerificationBloc(
          GetIt.I.get<VerifyCodeUseCase>(),
        )
    );
    GetIt.I.registerFactory<PhoneVerificationBloc>(
        () => PhoneVerificationBloc(
          GetIt.I.get<THWidgetCubit>(),
          GetIt.I.get<SignInUseCase>(),
          GetIt.I.get<SignUpUseCase>(),
        )
    );
    GetIt.I.registerFactory<CountrySelectionBloc>(() => CountrySelectionBloc());

    //Pages
    GetIt.I.registerFactory<Widget>(() => const CodeVerificationPage(),
        instanceName: Routes.codeVerification);
    GetIt.I.registerFactory<Widget>(() => const PhoneVerificationPage(),
        instanceName: Routes.inputPhone);
    GetIt.I.registerFactory<Widget>(() => const WelcomePage(),
        instanceName: Routes.welcome);
  }

  @override
  String get initialRoute => Routes.welcome;
}
