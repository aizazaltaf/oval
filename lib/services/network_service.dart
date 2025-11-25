import 'dart:async';
import 'dart:io';
import 'dart:isolate';

import 'package:admin/utils/dio.dart';
import 'package:dio/io.dart';
import 'package:flutter/foundation.dart';

mixin NetworkService {
  /// This function runs inside the isolate.
  static Future<void> networkMonitor(SendPort mainSendPort) async {
    final receivePort = ReceivePort();
    mainSendPort.send(receivePort.sendPort);

    Timer? timer;

    receivePort.listen((message) async {
      if (message == 'start') {
        timer?.cancel();
        timer = Timer.periodic(const Duration(seconds: 3), (_) async {
          final status = await _checkInternetConnection();
          mainSendPort.send(status);
        });
      } else if (message == 'stop') {
        timer?.cancel();
      }
    });
  }

  /// Check if the internet is stable and fast enough (≥ 2 Mbps)
  static Future<bool> _checkInternetConnection() async {
    const double minSpeedMbps = 0.003; // Fast.com style

    try {
      final result = await InternetAddress.lookup('8.8.8.8')
          .timeout(const Duration(seconds: 2));

      if (result.isEmpty || result[0].rawAddress.isEmpty) {
        return false;
      }

      final stopwatch = Stopwatch()..start();
      const url = "https://speed.hetzner.de/10MB.bin";
      final dio = Dio();

      (dio.httpClientAdapter as IOHttpClientAdapter).createHttpClient = () =>
          HttpClient()..badCertificateCallback = (cert, host, port) => true;

      final response = await dio.get<List<int>>(
        url,
        options: Options(
          responseType: ResponseType.bytes,
          sendTimeout: const Duration(seconds: 10),
          receiveTimeout: const Duration(seconds: 15),
        ),
      );
      stopwatch.stop();

      final bytesDownloaded = response.data?.length ?? 0;
      final timeSeconds = stopwatch.elapsedMilliseconds / 1000;

      if (timeSeconds == 0 || bytesDownloaded == 0) {
        return false;
      }

      final speedMbps = (bytesDownloaded * 8) / (timeSeconds * 1e6);

      if (kDebugMode) {
        print(
          "Downloaded $bytesDownloaded bytes in $timeSeconds s → $speedMbps Mbps",
        );
      }

      return speedMbps >= minSpeedMbps;
    } catch (_) {
      return false;
    }
  }
}
