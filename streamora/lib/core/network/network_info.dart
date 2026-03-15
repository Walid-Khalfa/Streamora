import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'network_info.g.dart';

@Riverpod(keepAlive: true)
NetworkInfo networkInfo(Ref ref) {
  return NetworkInfoImpl(Connectivity());
}

abstract class NetworkInfo {
  Future<bool> get isConnected;
  Stream<ConnectivityResult> get onConnectivityChanged;
}

class NetworkInfoImpl implements NetworkInfo {
  final Connectivity _connectivity;

  NetworkInfoImpl(this._connectivity);

  @override
  Future<bool> get isConnected async {
    final result = await _connectivity.checkConnectivity();
    return result != ConnectivityResult.none;
  }

  @override
  Stream<ConnectivityResult> get onConnectivityChanged {
    return _connectivity.onConnectivityChanged.map((results) => results.first);
  }
}

// Provider for connection status
final connectionStatusProvider = StreamProvider<bool>((ref) {
  final networkInfo = ref.watch(networkInfoProvider);
  return networkInfo.onConnectivityChanged.map(
    (result) => result != ConnectivityResult.none,
  );
});
