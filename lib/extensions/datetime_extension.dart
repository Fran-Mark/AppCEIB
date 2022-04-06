import 'package:ceib/helpers/helper_functions.dart';

extension DateTimeExtension on DateTime {
  String formatDate() {
    final date = this;
    final now = DateTime.now();
    final inOneDay = now.add(const Duration(days: 1));
    final day = stringifyDate(date);

    final hour = '${date.hour}:${date.minute}';

    final today = stringifyDate(now);

    final tomorrow = stringifyDate(inOneDay);

    if (day == today) {
      return 'Hoy $hour';
    }
    if (day == tomorrow) {
      return 'Mañana $hour';
    }
    return '$day $hour';
  }
}
