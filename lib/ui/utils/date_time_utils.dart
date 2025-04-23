import 'package:intl/intl.dart';

class DateTimeUtils {
  static DateTime? _parse(String? dateTimeStr) {
    try {
      if (dateTimeStr == null) return null;
      return DateTime.parse(dateTimeStr);
    } catch (_) {
      return null;
    }
  }

  static String formatFull(String? dateTimeStr) {
    final dateTime = _parse(dateTimeStr);
    if (dateTime == null) return '-';
    return DateFormat('dd-MM-yyyy – kk:mm').format(dateTime);
  }

  static String formatDate(String? dateTimeStr) {
    final dateTime = _parse(dateTimeStr);
    if (dateTime == null) return '-';
    return DateFormat.yMMMd().format(dateTime);
  }

  static String formatTime(String? dateTimeStr) {
    final dateTime = _parse(dateTimeStr);
    if (dateTime == null) return '-';
    return DateFormat.jm().format(dateTime);
  }

  static bool isToday(String? dateTimeStr) {
    final dateTime = _parse(dateTimeStr);
    if (dateTime == null) return false;
    final now = DateTime.now();
    return now.year == dateTime.year &&
        now.month == dateTime.month &&
        now.day == dateTime.day;
  }
}
