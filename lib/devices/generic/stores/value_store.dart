import 'package:flutter/foundation.dart';
import 'package:smarthome/helper/datetime_helper.dart';
import 'package:smarthome/helper/iterable_extensions.dart';
import 'package:smarthome/restapi/swagger.enums.swagger.dart';

class ValueStore<T> extends ChangeNotifier {
  T currentValue;
  String key;
  Command command;
  int id;
  bool sendToServer = false;
  bool _debugDisposes = false;

  bool get disposed => _debugDisposes;

  ValueStore(this.id, this.currentValue, this.key, this.command);

  @override
  dispose() {
    _debugDisposes = true;
    super.dispose();
  }

  T getValue() {
    if (currentValue.runtimeType == (DateTime)) {
      return ((currentValue as DateTime).toLocal() as T);
    }

    return currentValue;
  }

  setValue(T newValue) {
    switch (T) {
      case const (List<String>):
        (currentValue as List<String>).sequenceEquals(newValue as List<String>);
        return;
      case const (DateTime):
        newValue = DateTime.tryParse(newValue.toString()) as T;
        break;
      default:
        break;
    }

    if (currentValue == newValue) return;
    currentValue = newValue;
    sendToServer = true;
    notifyListeners();
  }

  updateValue(final T newValue) {
    switch (T) {
      case const (List<String>):
        (currentValue as List<String>).sequenceEquals(newValue as List<String>);
        return;
      default:
        break;
    }
    if (currentValue == newValue) return;
    currentValue = newValue;
    sendToServer = false;
    notifyListeners();
  }

  String getMeasuremtUnit() {
    return "";
  }

  String getValueAsString({final int precision = 1, final String? format}) {
    final val = getValue();
    if (val.runtimeType == (double)) {
      return (val as double).toStringAsFixed(precision);
    }
    if (format != null) {
      if (val.runtimeType == (DateTime)) {
        return (val as DateTime).toDate(format: format);
      }
    }

    if (val is List<dynamic>) {
      return (val as List<dynamic>).join('\r\n');
    }

    return val.toString();
  }
}
