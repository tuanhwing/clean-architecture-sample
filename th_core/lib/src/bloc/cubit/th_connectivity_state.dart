
///abstract [THConnectivityState] represents connectivity state
abstract class THConnectivityState {
  ///Constructor
  const THConnectivityState();
}

/// Online - Connected to a network.
class THOnlineNetworkState extends THConnectivityState {
  ///Constructor
  const THOnlineNetworkState();
}

/// Offline - Lost connection to a network.
class THOfflineNetworkState extends THConnectivityState {
  ///Constructor
  const THOfflineNetworkState();
}
