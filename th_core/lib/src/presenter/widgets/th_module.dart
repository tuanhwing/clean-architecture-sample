

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:th_dependencies/th_dependencies.dart';
import 'package:th_logger/th_logger.dart';


///abstract [THModule] class used to building your module Widget
abstract class THModule extends StatelessWidget {
  ///Constructor
  THModule({Key? key}) : super(key: key);

  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();

  ///The name of the first route to show.
  String get initialRoute;

  ///Called to generate a route for a given [RouteSettings].
  Route<dynamic>? generateRoutes(RouteSettings routeSettings) {
    Widget page = Scaffold(
      body: Center(
        child: Text(tr('not_found')),
      ),
    );

    try {
      page = GetIt.I.get(instanceName: routeSettings.name);
    }
    catch(exception) {
      final String tag = '${runtimeType.toString()}.generateRoutes';
      THLogger().e('$tag routeName:${routeSettings.name} exception:$exception');
    }
    return MaterialPageRoute<void>(
        builder: (_) => page,
        settings:routeSettings,
    );
  }

  Future<bool> _onWillPop(BuildContext context) async {
    if (_navigatorKey.currentState!.canPop()) {
      _navigatorKey.currentState!.pop();
    }
    else {
      SystemNavigator.pop();
    }

    return false;
  }

  @override
  Widget build(BuildContext context) {
    THLogger().d('${runtimeType.toString()} build');
    return WillPopScope(
        onWillPop: () => _onWillPop(context),
        child: Navigator(
          key: _navigatorKey,
          initialRoute: initialRoute,
          onGenerateRoute: generateRoutes,
        ),
    );
  }
}
