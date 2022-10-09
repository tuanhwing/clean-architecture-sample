import 'package:authentication_module/authentication_module.dart';
import 'package:example_dependencies/example_dependencies.dart';
import 'package:home_module/home_module.dart';
import 'package:flutter/material.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';

bool get _isLoggedIn {
  try {
    final String? token = GetIt.I.get<THNetworkRequester>().token;
    final bool result = token != null && token.isNotEmpty;
    return result;
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
      refreshTokenPath: '/api/user/refreshToken'
  );

  await GoterInjector().inject();
  await AuthenticationModule.initialize();
  await HomeModule.initialize();

  runApp(THCoreApp(
    supportedLocales: GetIt.I.get<AppBloc>().locales,
    path: 'assets/translations',
    fallbackLocale: const Locale('vi', 'VN'),
    child: MyApp(isLoggedIn: _isLoggedIn),
  ));
}

///My Application
class MyApp extends StatelessWidget {
  ///Constructor
  MyApp({Key? key, required this.isLoggedIn}) : super(key: key);
  ///Whether user logged in or not
  final bool isLoggedIn;

  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();
  NavigatorState? get _navigator => _navigatorKey.currentState;

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    GetIt.I
        .get<AppBloc>()
        .add(AuthenticationStatusChangedEvent(isLoggedIn: isLoggedIn));

    GetIt.I.get<THNetworkRequester>().languageCode = context.locale.toString();

    return MaterialApp(
      title: 'Goter',
      navigatorKey: _navigatorKey,
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      initialRoute: isLoggedIn ? HomeModule.routeName
          : AuthenticationModule.routeName,
      // The Grey law, light theme.
      theme: FlexThemeData.light(
        scheme: FlexScheme.blueWhale,
        fontFamily: 'Lato',
      ),
      // The Grey law, dark theme.
      darkTheme: FlexThemeData.dark(
        scheme: FlexScheme.blueWhale,
        fontFamily: 'Lato',
      ),
      routes: <String, Widget Function(BuildContext)>{
        AuthenticationModule.routeName : (_) => AuthenticationModule(),
        HomeModule.routeName : (_) => HomeModule()
      },
      builder: (_, Widget? child) {
        return MultiBlocProvider(
            providers: <BlocProvider<dynamic>>[
              BlocProvider<AppBloc>(create: (_) => GetIt.I.get<AppBloc>()),
            ],
            child: BlocListener<AppBloc, AppState>(
              listenWhen: (AppState current, AppState previous) =>
              current.isLoggedIn != previous.isLoggedIn,
              listener: (BuildContext context, AppState state) async {
                if (state.isLoggedIn) {
                  _navigator!.pushReplacementNamed(HomeModule.routeName);
                }
                else {
                  _navigator!
                      .pushReplacementNamed(AuthenticationModule.routeName);
                }
              },
              child: child,
            )
        );
      },
    );
  }
}
