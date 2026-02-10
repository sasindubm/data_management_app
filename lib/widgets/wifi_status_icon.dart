import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class WifiStatusIcon extends StatelessWidget {
  const WifiStatusIcon({super.key});
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<ConnectivityResult>>(
      stream: Connectivity().onConnectivityChanged,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Icon(Icons.wifi,
              size: 30, color: Colors.grey); // default while loading
        }

        final results = snapshot.data ?? [];
        final result =
            results.isNotEmpty ? results.first : ConnectivityResult.none;

        // Check if connected to mobile or wifi
        final isConnected = result == ConnectivityResult.mobile ||
            result == ConnectivityResult.wifi;

        return Icon(
          isConnected ? Icons.wifi : Icons.wifi_off,
          size: 30,
          color: isConnected ? Colors.green : Colors.red,
        );
      },
    );
  }
}
