import 'dart:async';

import 'package:socket_io_client/socket_io_client.dart' as io;
import 'package:wc_dart_framework/wc_dart_framework.dart';

// for JSON encoding if needed
final _logger = Logger('heart_beat.dart');

class HeartbeatManager {
  // The data you want to emit with the heartbeat

  HeartbeatManager({required this.socket, required this.data});
  Timer? _heartbeatTimer;
  final io.Socket socket;
  final Map<String, dynamic> data;

  void startHeartbeat() {
    stopHeartbeat(); // Cancel if already running

    _heartbeatTimer = Timer.periodic(const Duration(seconds: 20), (timer) {
      if (socket.connected) {
        socket.emit('ping', data);
        _logger.fine("🔁 Heartbeat ping sent: $data");
      } else {
        _logger.fine("⚠️ Socket not connected, skipping heartbeat.");
        socket.connect();
      }
    });
  }

  void stopHeartbeat() {
    _heartbeatTimer?.cancel();
    _heartbeatTimer = null;
  }
}
