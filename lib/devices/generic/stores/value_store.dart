import 'dart:async';

import 'package:smarthome/helper/datetime_helper.dart';
import 'package:smarthome/models/message.dart';

class ValueChangedModel<T> {
  T value;
  bool sendToSever;

  ValueChangedModel(this.value, this.sendToSever);
}

class ValueStore<T> {
  T currentValue;
  String key;
  Command command;

  var valueChanged = StreamController<ValueChangedModel<T>>.broadcast();

  ValueStore(this.currentValue, this.key, this.command);

  T getValue() {
    return currentValue;
  }

  setValue(T newValue) {
    if (currentValue == newValue) return;
    currentValue = newValue;
    valueChanged.add(ValueChangedModel(newValue, true));
  }

  updateValue(T newValue) {
    if (currentValue == newValue) return;
    currentValue = newValue;
    valueChanged.add(ValueChangedModel(newValue, false));
  }

  String getMeasuremtUnit() {
    return "";
  }

  String getValueAsString({String? format}) {
    if (currentValue.runtimeType == (double)) return (currentValue as double).toStringAsFixed(1);
    if (format != null) {
      if (currentValue.runtimeType == (DateTime)) {
        return (currentValue as DateTime).toDate(format: format);
      }
    }

    return currentValue.toString();
  }

  void dispose() {
    valueChanged.close();
  }
}
