// ignore_for_file: unused_import

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:smarthome/devices/generic/device_layout_service.dart';
import 'package:smarthome/devices/generic/generic_device_exporter.dart';
import 'package:smarthome/devices/generic/stores/value_store.dart';
import 'package:smarthome/helper/iterable_extensions.dart';
import 'package:smarthome/models/command.dart';
import 'package:smarthome/models/message.dart';

part 'store_service.g.dart';
// final valueStoreProvider = StateNotifierProvider<StoreService, List<ValueStore>>((final ref) => StoreService());

// final _valueStoreProvider = StateProvider<Map<int, List<ValueStore>>>((final ref) {
//   StoreService(ref);
//   return StoreService._stores;
// });

@riverpod
List<ValueStore>? valueStoresPerId(final Ref ref, final int id) {
  final stores = ref.watch(stateServiceProvider);
  return stores[id];
}

@riverpod
ValueStore? valueStoreChanged(final Ref ref, final String key, final int id) {
  final stores = ref.watch(valueStoresPerIdProvider(id));
  return stores?.firstOrDefault((final e) => e.key == key);
}

@Riverpod(keepAlive: true)
class StateService extends _$StateService {
  // static late Ref<Map<int, List<ValueStore>>> _ref;
  // static late StateService _instance;

  @override
  Map<int, List<ValueStore>> build() {
    // _instance = this;
    // _ref = ref;
    return {};
  }

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

  bool updateAndGetStores(final int deviceId, final Map<String, dynamic> json) {
    final Map<String, ValueStore> stores =
        (state[deviceId] ?? []).toMap((final e) => e.key, (final e) => e);
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
              ValueStore<DateTime>(
            deviceId,
            val,
            item,
            Command.none,
          );
        } else {
          stores[item] = ValueStore(deviceId, val, item, Command.none);
        }
        changed = true;
      } else {
        final store = stores[item]!;
        store.value = getValueFromJson(json[item]);
      }
    }

    if (changed) {
      state[deviceId] = stores.values.toList();

      state = {...state};
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
