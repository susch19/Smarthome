// ignore_for_file: unused_import

import 'package:smarthome/devices/generic/device_layout_service.dart';
import 'package:smarthome/devices/generic/generic_device_exporter.dart';
import 'package:smarthome/devices/generic/stores/value_store.dart';
import 'package:smarthome/helper/iterable_extensions.dart';
import 'package:smarthome/models/message.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tuple/tuple.dart';

// final valueStoreProvider = StateNotifierProvider<StoreService, List<ValueStore>>((final ref) => StoreService());

final _valueStoreProvider = StateProvider<Map<int, List<ValueStore>>>((final ref) {
  StoreService(ref);
  return StoreService._stores;
});

final valueStoresPerIdProvider = Provider.family<List<ValueStore>?, int>((final ref, final id) {
  final stores = ref.watch(_valueStoreProvider);
  return stores[id];
});

final valueStoreChangedProvider =
    ChangeNotifierProvider.family<ValueStore?, Tuple2<String, int>>((final ref, final key) {
  final stores = ref.watch(valueStoresPerIdProvider(key.item2));
  return stores?.firstOrNull((final e) => e.key == key.item1);
});

final valueStorePerIdAndNameProvider = Provider.family<ValueStore?, Tuple2<int, String>>((final ref, final key) {
  final stores = ref.watch(valueStoresPerIdProvider(key.item1));
  return stores?.firstOrNull((final e) => e.key == key.item2);
});

class StoreService {
  StoreService(this._ref) {
    _instance = this;
  }

  final StateProviderRef<Map<int, List<ValueStore>>> _ref;
  static final Map<int, List<ValueStore>> _stores = {};
  static StoreService? _instance;

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

  static bool updateAndGetStores(final int deviceId, final Map<String, dynamic> json) {
    final Map<String, ValueStore> stores = (_stores[deviceId] ?? []).toMap((final e) => e.key, (final e) => e);
    bool changed = false;
    for (final item in json.keys) {
      if (!stores.containsKey(item)) {
        stores[item] = ValueStore(deviceId, json[item], item, Command.None);
        changed = true;
      } else {
        final store = stores[item]!;
        store.setValue(json[item]);
      }
    }
    for (int index = stores.length - 1; index >= 0; index--) {
      final store = stores.entries.elementAt(index);
      if (!json.containsKey(store.key)) {
        stores.remove(store.value);
        changed = true;
      }
    }
    _stores[deviceId] = stores.values.toList();

    if (changed) {
      final notifier = _instance?._ref.read(_valueStoreProvider.notifier);
      notifier?.state = _stores;
    }
    return changed;
  }

  // static Map<String, ValueStore>? getStoresFor(final int id) {
  //   return _deviceStores[id];
  // }
}
