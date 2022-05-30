// import 'dart:async';

// import 'package:connectivity_plus/connectivity_plus.dart';

// abstract class NetworkConnectionUpdates {
//   Future<StreamSubscription<ConnectivityResult>> getConnectivityUpdates();
// }

// class NetworkConnectionUpdatesImpl extends NetworkConnectionUpdates {
//   final Connectivity connectivity;

//   NetworkConnectionUpdatesImpl(this.connectivity);

//   bool isConnected = false;

//   @override
//   Future<StreamSubscription<ConnectivityResult>> getConnectivityUpdates() {
//     var subscription = connectivity.onConnectivityChanged
//         .listen((ConnectivityResult result) async {
//       if (!isConnected && result != ConnectivityResult.none) {
//         isConnected = await connectionChecker.hasConnection;
//         print("CONNECTION STATUS: ${isConnected}");
//       } else if (isConnected && result == ConnectivityResult.none) {
//         isConnected = false;
//         print("CONNECTION STATUS: ${isConnected}");
//       }
//     });

//     return Future.value(subscription);
//   }
// }
