// ignore_for_file: unused_import

import 'package:smarthome/devices/generic/device_layout_service.dart';
import 'package:smarthome/devices/generic/generic_device_exporter.dart';
import 'package:smarthome/devices/generic/stores/value_store.dart';
import 'package:smarthome/helper/iterable_extensions.dart';
import 'package:smarthome/models/message.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tuple/tuple.dart';

// final valueStoreProvider = StateNotifierProvider<StoreService, List<ValueStore>>((final ref) => StoreService());

// final _valueStoreProvider = StateProvider<Map<int, List<ValueStore>>>((final ref) {
//   StoreService(ref);
//   return StoreService._stores;
// });
final valueStoreProvider =
    StateNotifierProvider<StoreService, Map<int, List<ValueStore>>>(
        (final ref) {
  return StoreService();
});

final valueStoresPerIdProvider =
    Provider.family<List<ValueStore>?, int>((final ref, final id) {
  final stores = ref.watch(valueStoreProvider);
  return stores[id];
});

final valueStoreChangedProvider =
    ChangeNotifierProvider.family<ValueStore?, Tuple2<String, int>>(
        (final ref, final key) {
  final stores = ref.watch(valueStoresPerIdProvider(key.item2));
  return stores?.firstOrNull((final e) => e.key == key.item1);
});

class StoreService extends StateNotifier<Map<int, List<ValueStore>>> {
  StoreService() : super({}) {
    _instance = this;
  }

  static late StoreService _instance;

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

  static bool updateAndGetStores(
      final int deviceId, final Map<String, dynamic> json) {
    final Map<String, ValueStore> stores = (_instance.state[deviceId] ?? [])
        .toMap((final e) => e.key, (final e) => e);
    bool changed = false;
    bool rebuild = false;
    for (final item in json.keys) {
      if (!rebuild && !stores.containsKey(item)) {
        rebuild = true;
      }
    }
    for (int index = stores.length - 1; index >= 0; index--) {
      final store = stores.entries.elementAt(index);
      if (!rebuild && !json.containsKey(store.key)) {
        rebuild = true;
      }
    }

    if (rebuild) stores.clear();

    for (final item in json.keys) {
      if (rebuild) {
        final val = getValueFromJson(json[item]);
        if (val.runtimeType == DateTime) {
          stores[item] =
              ValueStore<DateTime>(deviceId, val, item, Command.none);
        } else {
          stores[item] = ValueStore(deviceId, val, item, Command.none);
        }
        changed = true;
      } else {
        final store = stores[item]!;
        store.setValue(getValueFromJson(json[item]));
      }
    }

    if (changed) {
      _instance.state[deviceId] = stores.values.toList();

      _instance.state = {..._instance.state};
    }
    return changed;
  }

  static dynamic getValueFromJson(final dynamic val) {
    if (val.runtimeType == String) return DateTime.tryParse(val) ?? val;
    return val;
  }

  // static Map<String, ValueStore>? getStoresFor(final int id) {
  //   return _deviceStores[id];
  // }
}
