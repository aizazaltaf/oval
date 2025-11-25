import 'package:flutter/services.dart';
import 'package:wc_dart_framework/wc_dart_framework.dart';

final _logger = Logger("SpeakerphoneController.dart");

mixin SpeakerphoneController {
  static const MethodChannel _channel = MethodChannel('speakerphone_control');

  static Future<void> setSpeakerphoneOn(bool enable) async {
    try {
      await _channel.invokeMethod('setSpeakerphoneOn', enable);
      _logger.fine("Speakerphone set to: ${enable ? 'ON' : 'OFF'}");
    } on PlatformException catch (e) {
      _logger.severe("Failed to set speakerphone: ${e.message}");
    } catch (e) {
      _logger.severe("Unexpected error setting speakerphone: $e");
    }
  }

  static Future<bool> getSpeakerphoneStatus() async {
    int retryCount = 0;
    const maxRetries = 3;

    while (retryCount < maxRetries) {
      try {
        _logger.fine(
          "Calling getSpeakerphoneStatus on platform... (attempt ${retryCount + 1})",
        );
        final bool isSpeakerOn =
            await _channel.invokeMethod('getSpeakerphoneStatus');
        _logger.fine("Speaker status received: ${isSpeakerOn ? 'ON' : 'OFF'}");
        return isSpeakerOn;
      } on PlatformException catch (e) {
        retryCount++;
        _logger
          ..severe(
            "PlatformException getting speakerphone status (attempt $retryCount): ${e.message}",
          )
          ..severe("PlatformException code: ${e.code}")
          ..severe("PlatformException details: ${e.details}");

        if (retryCount >= maxRetries) {
          _logger.severe("Max retries reached, returning false");
          return false;
        }

        // Wait before retrying
        await Future.delayed(Duration(milliseconds: 500 * retryCount));
      } catch (e) {
        retryCount++;
        _logger.severe(
          "Unexpected error getting speakerphone status (attempt $retryCount): $e",
        );

        if (retryCount >= maxRetries) {
          _logger.severe("Max retries reached, returning false");
          return false;
        }

        // Wait before retrying
        await Future.delayed(Duration(milliseconds: 500 * retryCount));
      }
    }

    return false; // Default to false if all retries failed
  }

  static Future<bool> pingMethodChannel() async {
    try {
      _logger.fine("Pinging method channel...");
      // Try to get speaker status as a ping test
      await _channel.invokeMethod('getSpeakerphoneStatus');
      _logger.fine("Method channel ping successful");
      return true;
    } catch (e) {
      _logger.severe("Method channel ping failed: $e");
      return false;
    }
  }
}
