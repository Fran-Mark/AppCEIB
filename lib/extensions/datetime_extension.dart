import '../helpers/helper_functions.dart';

extension DateTimeExtension on DateTime {
  String formatDate() {
    final date = this;
    final now = DateTime.now();
    final inOneDay = now.add(Duration(days: 1));
    final day = stringifyDate(date);

    final hour = date.hour.toString() + ':' + date.minute.toString();

    final today = stringifyDate(now);

    final tomorrow = stringifyDate(inOneDay);

    if (day == today) {
      return 'Hoy ' + hour;
    }
    if (day == tomorrow) {
      return 'Mañana ' + hour;
    }
    return day + ' ' + hour;
  }
}
