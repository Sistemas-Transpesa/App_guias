import 'package:intl/intl.dart';

class DateFormatter {
  DateFormatter._();

  static final DateFormat _displayDateFormat = DateFormat('dd/MM/yyyy');
  static final DateFormat _apiDateFormat = DateFormat('yyyy-MM-dd');
  static final DateFormat _dateTimeFormat = DateFormat('dd/MM/yyyy HH:mm');
  static final DateFormat _timeFormat = DateFormat('HH:mm');

  static String toDisplayDate(DateTime? date) {
    if (date == null) return '';
    return _displayDateFormat.format(date);
  }

  static String toApiDate(DateTime? date) {
    if (date == null) return '';
    return _apiDateFormat.format(date);
  }

  static String toDisplayDateTime(DateTime? date) {
    if (date == null) return '';
    return _dateTimeFormat.format(date);
  }

  static String toTime(DateTime? date) {
    if (date == null) return '';
    return _timeFormat.format(date);
  }

  static DateTime? parseDate(String? dateStr) {
    if (dateStr == null || dateStr.trim().isEmpty) return null;
    try {
      if (dateStr.contains('-')) {
        return _apiDateFormat.parse(dateStr);
      } else if (dateStr.contains('/')) {
        return _displayDateFormat.parse(dateStr);
      }
      return DateTime.tryParse(dateStr);
    } catch (_) {
      return null;
    }
  }

  static String formatStringDate(String? dateStr) {
    final parsed = parseDate(dateStr);
    if (parsed == null) return dateStr ?? '';
    return toDisplayDate(parsed);
  }
}
