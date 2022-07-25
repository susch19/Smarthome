import 'package:intl/intl.dart';

extension DateHelper on DateTime {
  String toDate({final String? format}) {
    if (format != null) return DateFormat(format).format(toLocal()).toString();
    return DateFormat.yMd().add_jms().format(toLocal()).toString();
  }
}
