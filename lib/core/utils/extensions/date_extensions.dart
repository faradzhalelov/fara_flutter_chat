// lib/core/extensions/date_extensions.dart
extension DateExtensions on DateTime {
  bool isToday() {
    final now = DateTime.now();
    return now.year == year && now.month == month && now.day == day;
  }

  bool isYesterday() {
    final yesterday = DateTime.now().subtract(const Duration(days: 1));
    return yesterday.year == year && yesterday.month == month && yesterday.day == day;
  }

  bool isSameDay(DateTime other) => year == other.year && month == other.month && day == other.day;

  String toTimeString() => '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}';

  String toDateString() => '${day.toString().padLeft(2, '0')}.${month.toString().padLeft(2, '0')}.${year.toString().substring(2)}';
}