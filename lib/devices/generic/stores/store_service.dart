// ignore_for_file: unused_import

import 'package:smarthome/devices/generic/device_layout_service.dart';
import 'package:smarthome/devices/generic/generic_device_exporter.dart';
import 'package:smarthome/devices/generic/stores/value_store.dart';
import 'package:smarthome/models/message.dart';

class StoreService {
  // static final Map<Type, Widget Function(ValueProvider provider)> getWidgetFor = {
  //   TemperatureStore: (vp) {
  //     var ts = vp as TemperatureStore;
  //     return Row(
  //       children: [
  //         Text(ts.key + ": "),
  //         Text(ts.currentValue.toStringAsFixed(1)),
  //         Slider(
  //           value: ts.currentValue,
  //           onChanged: (c) => ts.setValue(c),
  //           min: 0.0,
  //           max: 40.0,
  //         )
  //       ],
  //     );
  //   },
  //   StateStore: (vp) => ListTile(
  //         title: Text("Status: " + vp.currentValue.toString()),
  //       ),
  //   BatteryStore: (vp) => ListTile(
  //         title: Text("Battery: " + (vp as BatteryStore).currentValue.toStringAsFixed(0) + " %"),
  //       ),
  // };

  static Map<int, Map<String, ValueStore>> _deviceStores = Map<int, Map<String, ValueStore>>();

  static Map<String, ValueStore> updateAndGetStores(int deviceId, Map<String, dynamic> json) {
    Map<String, ValueStore> stores = _deviceStores[deviceId] ?? {};
    for (var item in json.keys) {
      if (!stores.containsKey(item)) {
        stores[item] = ValueStore(json[item], item, Command.None);
      } else {
        var store = stores[item]!;
        store.updateValue(json[item]);
      }
    }
    for (int index = stores.length - 1; index >= 0; index--) {
      var store = stores.entries.elementAt(index);
      if (json.containsKey(store.key))
        store.value.updateValue(json[store.key]);
      else
        stores.remove(store.key);
    }
    _deviceStores[deviceId] = stores;
    return stores;
  }

  static Map<String, ValueStore>? getStoresFor(int id) {
    return _deviceStores[id];
  }
}
