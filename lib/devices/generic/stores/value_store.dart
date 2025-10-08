import 'package:flutter/foundation.dart';
import 'package:json_path/json_path.dart';
import 'package:smarthome/devices/property_info.dart';
import 'package:smarthome/helper/datetime_helper.dart';
import 'package:smarthome/helper/extension_export.dart';
import 'package:smarthome/models/command.dart';

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

  T get value {
    if (currentValue.runtimeType == (DateTime)) {
      return ((currentValue as DateTime).toLocal() as T);
    }

    return currentValue;
  }

  set value(T newValue) {
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

  set updateValue(final T newValue) {
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

  dynamic getFromJson(final LayoutBasePropertyInfo info) {
    if (value is Map<String, dynamic> &&
        (info.extensionData?.containsKey("JsonPath") ?? false)) {
      final path = info.extensionData!["JsonPath"];
      final prices = JsonPath(path);

      return prices.read(value).firstOrDefault((final x) => true)?.value;
      // .map((match) => '${match.path}:\t${match.value}')
      // .forEach(print)
    }
    return getValueAsString(
        precision: info.precision ?? 1, format: info.format);
  }

  String getMeasuremtUnit() {
    return "";
  }

  String getValueAsString(
      {final int precision = 1,
      final String? format,
      final bool asHex = false}) {
    final val = value;
    if (val is num) {
      if (asHex) return val.toHex();
      return val.toStringAsFixed(precision);
    }
    if (format != null) {
      if (val is DateTime) {
        return (val as DateTime).toDate(format: format);
      }
    }

    if (val is List<dynamic>) {
      return (val as List<dynamic>).join('\r\n');
    }

    return val.toString();
  }
}
