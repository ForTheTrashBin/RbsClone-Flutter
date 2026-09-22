import 'package:flutter/material.dart';
import 'package:openapi/openapi.dart';
import 'package:rbsclone_flutter/screens/app_shell.dart';

import 'dart:io';

class RbsCloneApp extends StatelessWidget {
  const RbsCloneApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'RbsClone',
      theme: ThemeData.light(useMaterial3: true),
      darkTheme: ThemeData.dark(useMaterial3: true),
      themeMode: ThemeMode.system,
      home: const ConnectionGateKeeper(),
    );
  }
}

class ConnectionGateKeeper extends StatefulWidget {
  const ConnectionGateKeeper({super.key});

  @override
  State<ConnectionGateKeeper> createState() => _ConnectionGateKeeperState();
}

class _ConnectionGateKeeperState extends State<ConnectionGateKeeper> {
  final ConnectivityService _connectivityService = ConnectivityService();

  @override
  void initState() {
    super.initState();

    _connectivityService.startMonitoring();
  }

  @override
  void dispose() {
    _connectivityService.stopMonitoring();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool?>(
      valueListenable: _connectivityService.connectionStatus,
      builder: (context, isConected, snapshot) {
        if (isConected == null) {
          return const WaitScreen();
        } else if (!isConected) {
          return const ErrorScreen();
        } else {
          return const AppScreen();
        }
      },
    );
  }
}

//------------------------------------------------------------------------------

class ConnectivityService {
  final UtilitiesApi _utilitiesApi = Openapi().getUtilitiesApi();

  final _delayShort = 5; // Should be >= 2
  final _delayLong = 10; // Should be > _delayShort

  final ValueNotifier<bool?> connectionStatus = ValueNotifier<bool?>(null);

  Future<bool> checkConnectivity(int timeoutSeconds) async {
    timeoutSeconds = timeoutSeconds < 2 ? 2 : timeoutSeconds;

    try {
      final response = await _utilitiesApi.getPing().timeout(
        Duration(seconds: timeoutSeconds),
      );

      return response.statusCode == HttpStatus.ok;
    } catch (e) {
      return false;
    }
  }

  Future<bool> checkConnectivityMinDuration(int waitSeconds) async {
    waitSeconds = waitSeconds < 2 ? 2 : waitSeconds;

    final apiPingFuture = checkConnectivity(waitSeconds - 1);

    final minDurationFuture = Future.delayed(Duration(seconds: waitSeconds));

    try {
      final result = await Future.wait([apiPingFuture, minDurationFuture]);

      return result[0];
    } catch (e) {
      await minDurationFuture;

      return false;
    }
  }

  bool _isMonitoring = false;

  void startMonitoring() async {
    if (!_isMonitoring) {
      _isMonitoring = true;

      bool isConnected = await checkConnectivityMinDuration(2);

      while (_isMonitoring) {
        connectionStatus.value = isConnected;

        final int delay = isConnected ? _delayLong : _delayShort;

        await Future.delayed(Duration(seconds: delay));

        if (_isMonitoring) {
          isConnected = await checkConnectivity(_delayShort - 1);
        }
      }
    }
  }

  void stopMonitoring() {
    _isMonitoring = false;
  }
}

//------------------------------------------------------------------------------

class WaitScreen extends StatelessWidget {
  const WaitScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          color: Colors.yellow.shade50,
          child: const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 80,
                  height: 80,
                  child: Padding(
                    padding: EdgeInsets.all(10.0),
                    child: CircularProgressIndicator(),
                  ),
                ),
                SizedBox(height: 16),
                Text(
                  "Checking server connection...",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 8),
                Text(
                  "Trying to connect to Server",
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

//------------------------------------------------------------------------------

class ErrorScreen extends StatelessWidget {
  const ErrorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          color: Colors.red.shade50,
          child: const Center(
            child: Padding(
              padding: EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.cloud_off, color: Colors.red, size: 80),
                  SizedBox(height: 16),
                  Text(
                    "Connection Error",
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 8),
                  Text(
                    "Unable to connect to server",
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
