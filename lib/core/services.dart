import 'dart:async';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:socket_io_client/socket_io_client.dart' as io;
import 'package:wc_dart_framework/wc_dart_framework.dart';

final _logger = Logger('services.dart');

mixin Services {
  static Future<bool> isInternetWorking() async {
    try {
      final client = http.Client();
      final response = await client.get(
        Uri.parse("https://www.google.com"),
      ).timeout(const Duration(seconds: 10));
      client.close();
      return response.statusCode == 200;
    } on http.ClientException catch (e) {
      _logger.warning('Network client exception: $e');
      return false;
    } on SocketException catch (e) {
      _logger.warning('Socket exception: $e');
      return false;
    } on TimeoutException catch (e) {
      _logger.warning('Network timeout: $e');
      return false;
    } on Exception catch (e) {
      _logger.warning('Network error: $e');
      return false;
    }
  }

  Future<bool> isUrlWorking(String url) async {
    try {
      final client = http.Client();
      final response = await client.get(
        Uri.parse(url),
      ).timeout(const Duration(seconds: 15));
      client.close();
      return response.statusCode == 200;
    } on http.ClientException catch (e) {
      _logger.warning('URL client exception: $e');
      return false;
    } on SocketException catch (e) {
      _logger.warning('URL socket exception: $e');
      return false;
    } on TimeoutException catch (e) {
      _logger.warning('URL timeout: $e');
      return false;
    } on Exception catch (e) {
      _logger.warning('URL error: $e');
      return false;
    }
  }
}

extension EmitWithAck on io.Socket {
  Future<dynamic> emitWithAcknowledge(
    String event,
    dynamic data, {
    Duration timeout = const Duration(seconds: 5),
  }) {
    final completer = Completer<dynamic>();
    bool acknowledged = false;

    emitWithAckCallback(event, data, (ackData) {
      acknowledged = true;
      completer.complete(ackData);
    });

    Future.delayed(timeout, () {
      if (!acknowledged && !completer.isCompleted) {
        completer
            .completeError('Ack timeout after ${timeout.inSeconds} seconds');
      }
    });

    return completer.future;
  }

  void emitWithAckCallback(
    String event,
    dynamic data,
    Function(dynamic) ackCallback,
  ) {
    emit(event, [data, ackCallback]);
  }
}
