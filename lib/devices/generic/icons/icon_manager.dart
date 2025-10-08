import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
// import 'package:signalr_core/signalr_core.dart';

import 'package:smarthome/devices/generic/device_layout_service.dart';
import 'package:smarthome/devices/generic/icons/svg_icon.dart';
import 'package:smarthome/helper/iterable_extensions.dart';

part 'icon_manager.g.dart';

@riverpod
Uint8List? iconByTypeNames(final Ref ref, final List<String> names) {
  final icons = ref.watch(_iconTypeNamesProvider);
  for (final name in names) {
    if (icons.containsKey(name)) return icons[name]?.data;
  }
  for (final name in names) {
    final data = ref.read(iconByNameProvider(name));
    if (data != null) return data;
  }
  return null;
}

@riverpod
Uint8List? iconByDeviceId(final Ref ref, final int id) {
  ref.watch(deviceLayoutsProvider);
  return null;
}

@riverpod
Uint8List? iconByName(final Ref ref, final String iconName) {
  final iconCache = ref.watch(_iconNameProvider);
  if (iconCache.containsKey(iconName)) {
    return iconCache[iconName]?.data;
  }
  return null;
}

@Riverpod(keepAlive: true)
Map<String, SvgIcon> _iconTypeNames(final Ref ref) {
  final layoutsRes = ref.watch(layoutIconsProvider);

  // return layoutsRes.maybeWhen(
  //     orElse: () => {},
  //     data: (data) {
  //       final filtered = data.where((x) =>
  //           x.icon != null &&
  //           x.layout?.typeNames != null &&
  //           x.layout!.typeNames!.isNotEmpty);
  //       final grouped = filtered.groupManyBy((x) => x.layout!.typeNames!);
  //       final ret =
  //           grouped.entries.toMap((x) => x.key, (x) => x.value.first.icon!);
  //       return ret;
  //     });
  return switch (layoutsRes) {
    AsyncData(:final value) => value
        .where((final x) =>
            x.icon != null &&
            x.layout?.typeNames != null &&
            x.layout!.typeNames!.isNotEmpty)
        .groupManyBy((final x) => x.layout!.typeNames!)
        .entries
        .toMap((final x) => x.key, (final x) => x.value.first.icon!.icon),
    _ => {},
  };
}

@Riverpod(keepAlive: true)
Map<String, SvgIcon> _iconTypeName(final Ref ref) {
  final layoutsRes = ref.watch(layoutIconsProvider);
  return switch (layoutsRes) {
    AsyncData(:final value) => value
        .where((final x) => x.icon != null && x.layout?.typeName != null)
        .groupBy((final x) => (x.layout!.typeName!, x.icon!))
        .keys
        .toMap((final x) => x.$1, (final x) => x.$2.icon),
    _ => {},
  };
}

@Riverpod(keepAlive: true)
Map<String, SvgIcon> _iconName(final Ref ref) {
  final layoutsRes = ref.watch(layoutIconsProvider);
  return switch (layoutsRes) {
    AsyncData(:final value) => value
        .where((final x) => x.icon != null)
        .mapMany((final x) => [x.icon!, ...x.additionalIcons])
        .distinct()
        .toMap((final x) => x.name, (final x) => x.icon),
    _ => {},
  };
}
