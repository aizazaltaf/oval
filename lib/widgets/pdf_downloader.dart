import 'package:admin/models/data/user_data.dart';
import 'package:admin/utils/dio.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:open_file/open_file.dart';

class PdfDownloader {
  PdfDownloader() {
    // Initialize notifications
    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    const initSettings = InitializationSettings(
      android: android,
      iOS: DarwinInitializationSettings(),
    );

    _notificationsPlugin.initialize(
      initSettings,
      onDidReceiveNotificationResponse: (resp) async {
        if (resp.payload != null) {
          await openPdf(resp.payload!);
        }
      },
    );
  }

  final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> openPdf(String filePath) async {
    final result = await OpenFile.open(filePath);
    logger.fine(result.message); // Optional: see if opening succeeded
  }

  /// Show/update notification
  Future<void> _updateNotification({
    required int id,
    required String title,
    String? body,
    bool completed = false,
    String? payload,
  }) async {
    final androidDetails = AndroidNotificationDetails(
      'download_channel',
      'Downloads',
      channelDescription: 'File download notifications',
      importance: completed ? Importance.high : Importance.low,
      priority: completed ? Priority.high : Priority.low,
      onlyAlertOnce: true,
    );

    final notificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: const DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      ),
    );

    await _notificationsPlugin.show(
      id,
      title,
      body,
      notificationDetails,
      payload: payload, //  file path as payload
    );
  }

  /// Download file and show progress/completion notification
  Future<void> downloadAndNotify({
    required String url,
    required String savePath,
    required String filename,
  }) async {
    final notificationId = filename.hashCode;

    try {
      await dio.download(
        url,
        savePath,
      );

      // Update as completed
      await _updateNotification(
        id: notificationId,
        title: 'Download Complete',
        body: filename,
        completed: true,
        payload: savePath, // send local file path
      );
    } catch (e) {
      await _updateNotification(
        id: notificationId,
        title: 'Download Failed',
        body: filename,
        completed: true,
      );
      logger.fine("Download failed: $e");
    }
  }
}
