import 'package:smarthome/helper/connection_manager.dart';
import 'package:smarthome/helper/iterable_extensions.dart';
import 'package:tuple/tuple.dart';

import 'generic_device_exporter.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

final _layoutProvider = StateProvider<List<DeviceLayout>>((final ref) {
  DeviceLayoutService(ref);
  return [];
});

final _idLayoutProvider = Provider.family<DeviceLayout?, int>((final ref, final id) {
  final layouts = ref.watch(_layoutProvider);

  return layouts.firstOrNull((final element) => element.ids?.contains(id) ?? false);
});

final _typeNameLayoutProvider = Provider.family<DeviceLayout?, String>((final ref, final typeName) {
  final layouts = ref.watch(_layoutProvider);

  return layouts.firstOrNull((final element) => element.typeName == typeName);
});

final deviceLayoutProvider = Provider.family<DeviceLayout?, Tuple2<int, String>>((final ref, final device) {
  final deviceLayoutId = ref.watch(_idLayoutProvider(device.item1));
  final deviceLayoutTypeName = ref.watch(_typeNameLayoutProvider(device.item2));
  final retLayout = deviceLayoutId ?? deviceLayoutTypeName;
  if (retLayout == null) {
    DeviceLayoutService.loadFromServer(device.item1);
  }
  return retLayout;
});

final dashboardDeviceLayoutProvider =
    Provider.family<DashboardDeviceLayout?, Tuple2<int, String>>((final ref, final device) {
  final layoutProvider = ref.watch(deviceLayoutProvider(device));
  return layoutProvider?.dashboardDeviceLayout;
});

final dashboardSpecialTypeLayoutProvider =
    Provider.family<List<DashboardPropertyInfo>?, Tuple2<int, String>>((final ref, final device) {
  final layoutProvider = ref.watch(dashboardDeviceLayoutProvider(device));
  return layoutProvider?.dashboardProperties.where((final element) => element.specialType != SpecialType.none).toList();
});

final dashboardNoSpecialTypeLayoutProvider =
    Provider.family<List<DashboardPropertyInfo>?, Tuple2<int, String>>((final ref, final device) {
  final layoutProvider = ref.watch(dashboardDeviceLayoutProvider(device));
  return layoutProvider?.dashboardProperties.where((final element) => element.specialType == SpecialType.none).toList();
});

final detailDeviceLayoutProvider = Provider.family<DetailDeviceLayout?, Tuple2<int, String>>((final ref, final device) {
  final layoutProvider = ref.watch(deviceLayoutProvider(device));
  return layoutProvider?.detailDeviceLayout;
});

final detailPropertyInfoLayoutProvider =
    Provider.family<List<DetailPropertyInfo>?, Tuple2<int, String>>((final ref, final device) {
  final layoutProvider = ref.watch(detailDeviceLayoutProvider(device));
  return layoutProvider?.propertyInfos;
});

final detailTabInfoLayoutProvider =
    Provider.family<List<DetailTabInfo>?, Tuple2<int, String>>((final ref, final device) {
  final layoutProvider = ref.watch(detailDeviceLayoutProvider(device));
  return layoutProvider?.tabInfos;
});

final detailHistoryLayoutProvider =
    Provider.family<List<HistoryPropertyInfo>?, Tuple2<int, String>>((final ref, final device) {
  final layoutProvider = ref.watch(detailDeviceLayoutProvider(device));
  return layoutProvider?.historyProperties;
});

class DeviceLayoutService {
  DeviceLayoutService(this._ref) {
    _instance = this;
  }

  final Ref _ref;
  static DeviceLayoutService? _instance;

  static void updateFromServer(final List<Object?>? arguments) {
    for (final a in arguments!) {
      final updateMap = a as Map<String, dynamic>;
      final deviceLayout = DeviceLayout.fromJson(updateMap);
      _updateFromServer(deviceLayout);
    }
  }

  static void _updateFromServer(final DeviceLayout deviceLayout) {
    if (_instance == null) return;
    final layoutProvider = _instance!._ref.read(_layoutProvider.notifier);

    final currentList = layoutProvider.state.toList();
    final existingLayout = currentList.firstOrNull((final e) => e.uniqueName == deviceLayout.uniqueName);
    if (existingLayout.hashCode == deviceLayout.hashCode) return;
    if (existingLayout != null) currentList.remove(existingLayout);

    currentList.add(deviceLayout);

    layoutProvider.state = currentList;
  }

  static Future<void> loadFromServer(final int id) async {
    if (_instance == null) return;
    final fromServer = await ConnectionManager.hubConnection.invoke("GetDeviceLayoutByDeviceId", args: [id]);
    if (fromServer == null) return;

    final deviceLayout = DeviceLayout.fromJson(fromServer as Map<String, dynamic>);
    _updateFromServer(deviceLayout);
  }
}
