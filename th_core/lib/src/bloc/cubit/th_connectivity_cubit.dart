
import 'dart:async';

import 'package:connectivity/connectivity.dart';
import 'package:th_core/th_core.dart';

import 'th_connectivity_state.dart';

///abstract [THConnectivityCubit] used to manage connectivity state
class THConnectivityCubit extends Cubit<THConnectivityState> {
  ///Constructor
  THConnectivityCubit() : super(const THOnlineNetworkState()) {
    _subscription = Connectivity().onConnectivityChanged.listen(
            (ConnectivityResult result) {
      switch (result) {
        case ConnectivityResult.mobile:
        case ConnectivityResult.wifi:
          emit(const THOnlineNetworkState());
          break;
        default:
          emit(const THOfflineNetworkState());
          break;
      }
    });
  }

  ///Network status subscription
  late StreamSubscription<ConnectivityResult> _subscription;

  ///Check current network status
  Future<void> checkCurrentStatus() async {
    final ConnectivityResult connectivityResult = await Connectivity()
        .checkConnectivity();
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      emit(const THOnlineNetworkState());
    } else {
      emit(const THOfflineNetworkState());
    }
  }

  ///Dispose function
  void dispose() {
    _subscription.cancel();
  }
}
