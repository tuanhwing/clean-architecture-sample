import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:th_core/th_core.dart';

import 'bloc/blocs.dart';
import 'presenter/widgets/widgets.dart';
import 'resources/th_dimens.dart';

///abstract [THState] class used to building your StatefulWidget(Page)
// ignore: always_specify_types
abstract class THState<FWidget extends StatefulWidget, Bloc extends THBaseBloc>
    extends State<FWidget>
    with WidgetsBindingObserver {
  ///Constructor
  THState(this._bloc) {
    _loadingOverlay = GetIt.I.get<THOverlayHandler>();
  }

  late THOverlayHandler _loadingOverlay;

  ///Bloc of current state
  final Bloc _bloc;

  ///Get bloc of current state
  Bloc get bloc => _bloc;

  ///Get ThemeData
  ThemeData get themeData => Theme.of(context);

  ///Get screen size
  Size? get screenSize => MediaQuery.of(context).size;

  ///Content of page
  Widget get content;

  ///AppBar of page
  AppBar? get appBar => null;

  ///Floating widget of page
  Widget? get floatingActionButton => null;

  ///Bottom navigation bar
  Widget? get bottomNavigationBar => null;

  ///The scaffold's floating widgets should size
  ///themselves to avoid the onscreen keyboard whose height is defined
  bool get resizeToAvoidBottomInset => true;

  ///Network unavailable widget
  Widget get networkOfflineWidget => SafeArea(
    child: Container(
      color: themeData.disabledColor.withOpacity(THDimens.size05),
      padding: const EdgeInsets.symmetric(
        vertical: THDimens.size8,
      ),
      alignment: Alignment.center,
      child: Text(
        tr('network_unavailable'),
        style: themeData.textTheme.subtitle1!.apply(
            color: themeData.disabledColor,
        ),
      ),
    ),
  );

  ///Loading widget
  Widget get loadingWidget => ColoredBox(
        color: themeData.primaryColorDark.withOpacity(0.1),
        child: Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(themeData.primaryColor),
          ),
        ),
      );

  ///Error widget
  Widget errorWidget(String message, {String? title, VoidCallback? onOK}) {
    Widget titleWidget = const SizedBox();
    if (title != null) {
      titleWidget = Padding(
        padding: const EdgeInsets.only(
          top: THDimens.size16,
          left: THDimens.size64,
          right: THDimens.size64,
        ),
        child: Text(
          title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: themeData.textTheme.subtitle1
              ?.apply(fontSizeDelta: THDimens.size3),
        ),
      );
    }

    final double height =
        screenSize != null ? screenSize!.height : THDimens.size300;

    return ColoredBox(
      color: themeData.primaryColorDark.withOpacity(0.1),
      child: Material(
        color: Colors.transparent,
        child: Center(
          child: ClipRRect(
            borderRadius: const BorderRadius.all(
              Radius.circular(THDimens.size16),
            ),
            child: Container(
              width: height,
              color: themeData.scaffoldBackgroundColor,
              constraints: const BoxConstraints(maxWidth: THDimens.size300),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  titleWidget,
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: THDimens.size16,
                      horizontal: THDimens.size32,
                    ),
                    child: Text(message),
                  ),
                  Divider(
                    height: THDimens.size1,
                    color: themeData.primaryColorDark,
                  ),
                  TextButton(
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.zero,
                    ),
                    onPressed: () {
                      _loadingOverlay.hide();
                      onOK?.call();
                    },
                    child: Container(
                      width: double.infinity,
                      alignment: Alignment.center,
                      child: Text(
                        tr('ok').toUpperCase(),
                        style: themeData.textTheme.subtitle1?.apply(
                          color: themeData.primaryColor,
                          fontSizeDelta: THDimens.size1,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  ///Called when cubit's state changed
  @mustCallSuper
  void onCubitStateChanged(THPageState state) {
    if (state is THNone) {
      _loadingOverlay.hide();
    } else if (state is THLoading) {
      _loadingOverlay.showLoading(context, loadingWidget: loadingWidget);
    } else if (state is THError) {
      _loadingOverlay.showError(
        context,
        errorWidget: errorWidget(state.message),
      );
    }
  }

  ///Post-frame
  void onPostFrame() {}

  ///The application is visible and responding to user input.
  void onResume() {}

  /// The application is not currently visible to the user, not responding to
  /// user input, and running in the background.
  void onPause() {}

  /// The application is still hosted on a flutter engine but is detached from
  /// any host views.
  void onDetach() {}

  /// The application is in an inactive state and is not receiving user input.
  void onInactive() {}

  ///The network connectivity changed
  void onNetworkStatusChanged(THConnectivityState state) {}

  @override
  @mustCallSuper
  void initState() {
    super.initState();

    //Listen state's page
    bloc.pageCubit.stream.listen(onCubitStateChanged);

    // Add the observer
    WidgetsBinding.instance!.addObserver(this);

    // Check current network status
    GetIt.I.get<THConnectivityCubit>().checkCurrentStatus();

    SchedulerBinding.instance!.addPostFrameCallback((Duration duration) {
      onPostFrame();
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<Bloc>.value(
      value: bloc,
      child: Builder(
        builder: (BuildContext context) {
          return GestureDetector(
            onTap: () {
              FocusScope.of(context).requestFocus(FocusNode());
            },
            child: Scaffold(
              appBar: appBar,
              resizeToAvoidBottomInset: resizeToAvoidBottomInset,
              body: Column(
                children: <Widget>[
                  BlocConsumer<THConnectivityCubit, THConnectivityState>(
                    listener: (_, THConnectivityState state) {
                      THLogger().d(state.toString());
                      onNetworkStatusChanged(state);
                    },
                    builder: (_, THConnectivityState state) {
                      Widget networkWidget = const SizedBox();
                      if (state is THOfflineNetworkState) {
                        networkWidget = networkOfflineWidget;
                      }
                      return networkWidget;
                    },
                  ),
                  Expanded(child: content),
                ],
              ),
              floatingActionButton: floatingActionButton,
              bottomNavigationBar: bottomNavigationBar,
            ),
          );
        },
      ),
    );
  }

  @override
  @mustCallSuper
  void dispose() {
    // Remove the observer
    WidgetsBinding.instance!.removeObserver(this);
    bloc.dispose();

    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    if (!mounted) return;
    switch (state) {
      case AppLifecycleState.resumed:
        // widget is resumed
        onResume();
        break;
      case AppLifecycleState.inactive:
        // widget is inactive
        onInactive();
        break;
      case AppLifecycleState.paused:
        // widget is paused
        onPause();
        break;
      case AppLifecycleState.detached:
        // widget is detached
        onDetach();
        break;
    }
  }
}
