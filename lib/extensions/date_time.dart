import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

extension XDateTime on DateTime {
  String format(
    final String format, {
    required final Locale? locale,
  }) {
    return DateFormat(format, locale?.languageCode).format(this);
  }

  TimeOfDay toTimeOfDay() {
    return TimeOfDay(
      hour: hour,
      minute: minute,
    );
  }

  String formatDateToUtc() {
    // Convert to UTC and format to 'yyyy-MM-dd'
    final DateTime utcDate = toUtc();
    return DateFormat('yyyy-MM-dd').format(utcDate);
  }

  bool isAudioVideoChatDisabled() {
    final DateTime current = DateTime.now().toLocal();
    final DateTime currentNotificationTime = toLocal();
    final Duration difference = current.difference(currentNotificationTime);
    if (difference.inMinutes < 3) {
      return true;
    } else {
      return false;
    }
  }
}

extension PrettyDate on DateTime {
  String toPrettyDate() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final inputDate = DateTime(year, month, day);

    if (inputDate == today) {
      return 'Today';
    } else if (inputDate == yesterday) {
      return 'Yesterday';
    } else {
      return '${month.toString().padLeft(2, '0')}-${day.toString().padLeft(2, '0')}-$year';
    }
  }
}
