import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import '../th_core.dart';
import 'bloc/blocs.dart';
import 'presenter/widgets/widgets.dart';
import 'resources/th_dimens.dart';

///abstract [THState] class used to building your StatefulWidget(Page)
abstract class THState<FWidget extends StatefulWidget, FBloc extends THBaseBloc>
    extends State<FWidget>
    with WidgetsBindingObserver {

  late THOverlayHandler _overlayHandler;

  ///Bloc of current state
  late FBloc _bloc;

  ///Get bloc of current state
  FBloc get bloc => _bloc;

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

  ///In progress widget when [THFetchInProgressState] called
  Widget get inProgressWidget => const InProgressWidget();

  ///Failure widget when [THFetchFailureState] called
  Widget get failureWidget =>
      Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(themeData.primaryColor),
        ),
      );

  ///Loading widget when [THShowLoadingOverlayState] called
  Widget get loadingWidget => const LoadingWidget();

  ///Error widget when [THShowErrorOverlayState] called
  Widget errorWidget(String message,
      {
        String? title,
        String? okString,
        VoidCallback? onOK,
      }) {
    return ErrorPopUpOverlayWidget(
      message: message.inCaps,
      title: title,
      okString: okString,
      overlayHandler: _overlayHandler,
    );
  }

  bool _buildWhen(THPageState previous, THPageState current) {
    if (previous is THInitialState) {
      return current is THFetchInProgressState ||
          current is THFetchFailureState ||
          current is THFetchSuccessState;
    }
    if (previous is THFetchInProgressState) {
      return current is THFetchFailureState ||
          current is THFetchSuccessState;
    }
    if (previous is THFetchFailureState) {
      return current is THFetchInProgressState ||
          current is THFetchSuccessState;
    }
    if (previous is THFetchSuccessState) {
      return current is THFetchFailureState ||
          current is THFetchInProgressState;
    }
    return false;
  }

  ///Called when cubit's state changed
  @mustCallSuper
  void onPageStateChanged(THPageState state) {
    if (state is THInitialState) {
      _overlayHandler.hide();
    } else if (state is THShowLoadingOverlayState) {
      _overlayHandler.showLoading(context, loadingWidget: loadingWidget);
    } else if (state is THShowErrorOverlayState) {
      _overlayHandler.showError(
        context,
        errorWidget: errorWidget(state.message, ),
      );
    }
  }

  ///Handle retry function when state is [THFetchFailureState]
  void onRetry() {}

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

  @override
  @mustCallSuper
  void initState() {
    super.initState();

    // Initialize
    _bloc = GetIt.I.get<FBloc>();
    _overlayHandler = GetIt.I.get<THOverlayHandler>();

    // Add the observer
    WidgetsBinding.instance!.addObserver(this);

    SchedulerBinding.instance!.addPostFrameCallback((Duration duration) {
      onPostFrame();
    });
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      // ignore_for_file: always_specify_types
      providers: [
        BlocProvider<FBloc>.value(value: _bloc),
        BlocProvider<THPageCubit>.value(value: _bloc.pageCubit),
      ],
      child: Builder(
        builder: (BuildContext context) {
          return GestureDetector(
            onTap: () {
              FocusScope.of(context).requestFocus(FocusNode());
            },
            child: Scaffold(
              appBar: appBar,
              resizeToAvoidBottomInset: resizeToAvoidBottomInset,
              body: BlocConsumer<THPageCubit, THPageState>(
                  listener: (BuildContext context, THPageState state) {
                    onPageStateChanged(state);
                  },
                  buildWhen: (THPageState previous, THPageState current) {
                    return _buildWhen(previous, current);
                  },
                  builder: (BuildContext context, THPageState state) {
                    THLogger().d('$runtimeType build $state');
                    if (state is THFetchInProgressState) {
                      return inProgressWidget;
                    }
                    if (state is THFetchFailureState) {
                    return FailureWidget(
                      errorMessage: state.errorMessage,
                      titleButton: state.titleButton,
                      onRetry: onRetry,
                    );
                  }
                    return content;
                  },
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
