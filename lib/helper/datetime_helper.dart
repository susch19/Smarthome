import 'package:intl/intl.dart';

extension DateHelper on DateTime {
  String toDate({String? format}) {
    if (format != null) return DateFormat(format).format(this.toLocal()).toString();
    return DateFormat.yMd().add_jms().format(this.toLocal()).toString();
  }
}
