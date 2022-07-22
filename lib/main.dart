import 'package:authentication_module/authentication_module.dart';
import 'package:example_dependencies/example_dependencies.dart';
import 'package:home_module/home_module.dart';
import 'package:flutter/material.dart';

Future<void> _init() async {
  PackageInfo package = await PackageInfo.fromPlatform();
  //Common
  GetIt.I.registerLazySingleton<DeviceInfoPlugin>(() => DeviceInfoPlugin());
  GetIt.I.registerLazySingleton<PackageInfo>(() => package);
  GetIt.I.registerLazySingleton<DeviceInfoDataSource>(() => DeviceInfoDataSourceImpl(
    GetIt.I.get<DeviceInfoPlugin>(),
    GetIt.I.get<PackageInfo>(),
  ));

  //Blocs
  GetIt.I.registerLazySingleton<AppBloc>(() => AppBloc());

  //Data
  GetIt.I.registerLazySingleton<UserLocalDataSource>(() => UserLocalDataSourceImpl(GetIt.I.get()));
  GetIt.I.registerLazySingleton<UserRemoteDataSource>(
    () => UserRemoteDataSourceImpl(
      GetIt.I.get(),
      GetIt.I.get(),
    )
  );

  //Repository
  GetIt.I.registerLazySingleton<UserRepository>(() => UserRepositoryImpl(
    localDataSource: GetIt.I.get<UserLocalDataSource>(),
    remoteDataSource: GetIt.I.get<UserRemoteDataSource>())
  );

  //Use case
  GetIt.I.registerLazySingleton<FetchProfileUseCase>(() => FetchProfileUseCase(GetIt.I.get()));
  GetIt.I.registerLazySingleton<GetCachedProfileUseCase>(() => GetCachedProfileUseCase(GetIt.I.get()));
  GetIt.I.registerLazySingleton<LogoutUseCase>(() => LogoutUseCase(GetIt.I.get()));
}

Future<bool> _isLoggedIn() async {
  try {
    final failureOrLoggedIn = await GetIt.I.get<GetCachedProfileUseCase>().call(NoParams());
    return failureOrLoggedIn.fold<bool>(
          (failure) => false,
          (loggedIn) => true,
    );
  }
  catch(exception) {
    return false;
  }
}

void main() async {

  WidgetsFlutterBinding.ensureInitialized();
  await FlutterConfig.loadEnvVariables();
  await THCoreApp.ensureInitialized(
    baseURL: FlutterConfig.get('HOST') ?? '',
  );

  await _init();
  await AuthenticationModule.initialize();
  await HomeModule.initialize();

  String initRoute = await _isLoggedIn() ? HomeModule.routeName : AuthenticationModule.routeName;

  runApp(THCoreApp(
    supportedLocales: const [Locale('vi'), Locale('en')],
    path: 'assets/translations',
    fallbackLocale: const Locale('vi', 'VN'),
    child: MyApp(initRouteName: initRoute),
  ));
}

class MyApp extends StatelessWidget {
  MyApp({Key? key, required this.initRouteName}) : super(key: key);
  final String initRouteName;

  final _navigatorKey = GlobalKey<NavigatorState>();
  NavigatorState? get _navigator => _navigatorKey.currentState;

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      navigatorKey: _navigatorKey,
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      initialRoute: initRouteName,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      routes: {
        AuthenticationModule.routeName : (_) => AuthenticationModule(),
        HomeModule.routeName : (_) => HomeModule()
      },
      builder: (_, child) {
        return MultiBlocProvider(
          providers: [
            BlocProvider<AppBloc>(create: (_) => GetIt.I.get<AppBloc>()),
          ],
          child: BlocListener<AppBloc, AppState>(
            listener: (context, state) async {
              if (state.user != null) {
                _navigator!.pushReplacementNamed(HomeModule.routeName);
              }
              else {
                _navigator!.pushReplacementNamed(AuthenticationModule.routeName);
              }
            },
            child: child,
          )
        );
      },
    );
  }
}
