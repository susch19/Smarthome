import 'package:flutter/foundation.dart';
import 'package:smarthome/helper/datetime_helper.dart';
import 'package:smarthome/helper/iterable_extensions.dart';
import 'package:smarthome/models/message.dart';

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
    return currentValue;
  }

  setValue(final T newValue) {
    switch (T) {
      case List<String>:
        (currentValue as List<String>).sequenceEquals(newValue as List<String>);
        return;
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
      case List<String>:
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

  String getValueAsString({final String? format}) {
    if (currentValue.runtimeType == (double)) return (currentValue as double).toStringAsFixed(1);
    if (format != null) {
      if (currentValue.runtimeType == (DateTime)) {
        return (currentValue as DateTime).toDate(format: format);
      }
    }

    return currentValue.toString();
  }
}
