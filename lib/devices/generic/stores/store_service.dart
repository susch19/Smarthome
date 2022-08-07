// ignore_for_file: unused_import

import 'package:smarthome/devices/generic/device_layout_service.dart';
import 'package:smarthome/devices/generic/generic_device_exporter.dart';
import 'package:smarthome/devices/generic/stores/value_store.dart';
import 'package:smarthome/helper/iterable_extensions.dart';
import 'package:smarthome/models/message.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:synchronized/synchronized.dart';
import 'package:tuple/tuple.dart';

// final valueStoreProvider = StateNotifierProvider<StoreService, List<ValueStore>>((final ref) => StoreService());

// final _valueStoreProvider = StateProvider<Map<int, List<ValueStore>>>((final ref) {
//   StoreService(ref);
//   return StoreService._stores;
// });
final valueStoreProvider = StateNotifierProvider<StoreService, Map<int, List<ValueStore>>>((final ref) {
  return StoreService();
});

final valueStoresPerIdProvider = Provider.family<List<ValueStore>?, int>((final ref, final id) {
  final stores = ref.watch(valueStoreProvider);
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

  static final lock = Lock();
  static bool updateAndGetStores(final int deviceId, final Map<String, dynamic> json) {
    print("$deviceId updateAndGetStores");
    final Map<String, ValueStore> stores = (_instance.state[deviceId] ?? []).toMap((final e) => e.key, (final e) => e);
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

    if (changed) {
      lock.synchronized(() {
        _instance.state[deviceId] = stores.values.toList();
        print("$deviceId: ${_instance.state.length}");

        _instance.state = {..._instance.state};
      });
    }
    return changed;
  }

  // static Map<String, ValueStore>? getStoresFor(final int id) {
  //   return _deviceStores[id];
  // }
}
