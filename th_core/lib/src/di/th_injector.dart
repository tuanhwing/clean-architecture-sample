
import 'package:th_dependencies/th_dependencies.dart';
import 'package:th_network/th_network.dart';

import '../bloc/blocs.dart';
import '../presenter/widgets/th_overlay_handler.dart';

/// [THInjector] class responsible for injecting all core's dependencies
class THInjector {

  static GetIt get _injector => GetIt.I;

  ///Initialize core
  /// [baseURL] server's base URL
  static Future<void> initializeWith({
    required String baseURL,
    String? refreshTokenPath,
    String? authorizationPrefix,
  }) async {
    //Common
    final SharedPreferences _prefs = await SharedPreferences.getInstance();
    _injector.registerLazySingleton<FlutterSecureStorage>(
          () => const FlutterSecureStorage(),
    );
    _injector.registerLazySingleton<SharedPreferences>(() => _prefs);

    _injector.registerFactory<THPageCubit>(() => THPageCubit());
    _injector.registerSingleton<THConnectivityCubit>(THConnectivityCubit());

    //Network requester
    final THNetworkRequester requester = await THNetwork.getInstance(
      baseURL,
      _injector.get(),
      refreshTokenPath: refreshTokenPath,
      authorizationPrefix: authorizationPrefix
    );
    _injector.registerLazySingleton<THNetworkRequester>(() => requester);

    //Loading overlay
    _injector.registerLazySingleton<THOverlayHandler>(
          () => THOverlayHandler(),
    );
  }
}
