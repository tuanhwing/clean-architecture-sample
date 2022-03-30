
import 'package:flutter/cupertino.dart';
import 'package:th_core/th_core.dart';

import '../../di/th_injector.dart';

/// [THCoreApp] class responsible for starting the Modular engine
class THCoreApp extends StatefulWidget {
  ///Constructor
  THCoreApp({
    Key? key,
    required this.child,
    required this.supportedLocales,
    required this.path,
    this.fallbackLocale,
    this.startLocale,
    this.useOnlyLangCode = false,
    this.useFallbackTranslations = false,
    this.assetLoader = const RootBundleAssetLoader(),
    this.saveLocale = true,
    this.errorWidget,
  }) : super(key: key) {
    THLogger().d('start!');
  }

  /// Home application containing the MaterialApp or CupertinoApp.
  final Widget child;

  /// List of supported locales.
  /// {@macro flutter.widgets.widgetsApp.supportedLocales}
  final List<Locale> supportedLocales;

  /// Locale when the locale is not in the list
  final Locale? fallbackLocale;

  /// Overrides device locale.
  final Locale? startLocale;

  /// Trigger for using only language code for reading localization files.
  /// @Default value false
  /// Example:
  /// ```
  /// en.json //useOnlyLangCode: true
  /// en-US.json //useOnlyLangCode: false
  /// ```
  final bool useOnlyLangCode;

  /// If a localization key is not found in the locale file,
  /// try to use the fallbackLocale file.
  /// @Default value false
  /// Example:
  /// ```
  /// useFallbackTranslations: true
  /// ```
  final bool useFallbackTranslations;

  /// Path to your folder with localization files.
  /// Example:
  /// ```dart
  /// path: 'assets/translations',
  /// path: 'assets/translations/lang.csv',
  /// ```
  final String path;

  /// Class loader for localization files.
  /// You can use custom loaders from [Easy Localization Loader](https://github.com/aissat/easy_localization_loader) or create your own class.
  /// @Default value `const RootBundleAssetLoader()`
  final AssetLoader assetLoader;

  /// Save locale in device storage.
  /// @Default value true
  final bool saveLocale;

  /// Shows a custom error widget when an error is encountered instead of
  /// the default error widget.
  /// @Default value `errorWidget = ErrorWidget()`
  final Widget Function(FlutterError? message)? errorWidget;

  @override
  State<StatefulWidget> createState() => _THCoreState();

  /// ensureInitialized needs to be called in main
  /// so that inject all dependencies
  ///
  /// [baseURL] param is server's url
  static Future<void> ensureInitialized({
    required String baseURL,
    String? refreshTokenPath,
    String? authorizationPrefix,
  }) async {
    await EasyLocalization.ensureInitialized();
    await THInjector.initializeWith(
      baseURL: baseURL,
      refreshTokenPath: refreshTokenPath,
      authorizationPrefix: authorizationPrefix,
    );

    //Localize message
    tr(THErrorMessageKey.unknown);
    tr(THErrorMessageKey.networkError);
    tr(THErrorMessageKey.somethingWentWrong);
  }
}

class _THCoreState extends State<THCoreApp> {



  @override
  Widget build(BuildContext context) {
    return EasyLocalization(
      supportedLocales: widget.supportedLocales,
      path: widget.path,
      fallbackLocale: widget.fallbackLocale,
      startLocale: widget.startLocale,
      useOnlyLangCode: widget.useOnlyLangCode,
      useFallbackTranslations: widget.useFallbackTranslations,
      assetLoader: widget.assetLoader,
      saveLocale: widget.saveLocale,
      errorWidget: widget.errorWidget,
      child: widget.child,
    );
  }
}
