import 'package:admin/extensions/date_time.dart';
import 'package:admin/extensions/int.dart';
import 'package:flutter/material.dart';

extension TimeOfDayExtension on TimeOfDay {
  int get inMinutes {
    return (hour * 60) + minute;
  }

  String toSerialize() {
    return '${hour.toFixedLength()}:${minute.toFixedLength()}';
  }

  String formatCustom(
    final String format, {
    required final Locale? locale,
  }) {
    return DateTime(0, 1, 1, hour, minute).format(
      format,
      locale: locale,
    );
  }
}

mixin TimeOfDayX {
  static TimeOfDay parse(final String time) {
    void throwInvalidArgs() {
      throw ArgumentError.value(time, 'TimeOfDay', 'Invalid time of day');
    }

    final List<String> aTime = time.split(':');
    if (aTime.length != 2) {
      throwInvalidArgs();
    }
    final int? hour = int.tryParse(aTime.first);
    final int? minute = int.tryParse(aTime.last);
    if (hour == null || minute == null) {
      throwInvalidArgs();
    }
    return TimeOfDay(
      hour: hour!,
      minute: minute!,
    );
  }
}
