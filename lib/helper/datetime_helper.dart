import 'package:intl/intl.dart';

extension DateHelper on DateTime {
  String toDate() {
    return DateFormat.yMd().add_jms().format(this.toLocal()).toString();
  }
}
