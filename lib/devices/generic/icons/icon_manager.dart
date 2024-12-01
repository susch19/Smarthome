import 'dart:io';
import 'package:path/path.dart' as path;

import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
// import 'package:signalr_core/signalr_core.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smarthome/devices/device_manager.dart';
import 'package:smarthome/devices/generic/device_layout_service.dart';
import 'package:smarthome/devices/generic/icons/svg_icon.dart';
import 'package:smarthome/helper/cache_file_manager.dart';
import 'package:smarthome/helper/iterable_extensions.dart';

part 'icon_manager.g.dart';

@riverpod
Uint8List? iconByTypeNames(final Ref ref, final List<String> names) {
  final icons = ref.watch(_iconTypeNamesProvider);
  for (final name in names) {
    if (icons.containsKey(name)) return icons[name]?.data;
  }
  return null;
}

@riverpod
Uint8List? iconByDeviceId(final Ref ref, final int id) {
  ref.watch(deviceLayoutsProvider);
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
        .where((x) =>
            x.icon != null &&
            x.layout?.typeNames != null &&
            x.layout!.typeNames!.isNotEmpty)
        .groupManyBy((x) => x.layout!.typeNames!)
        .entries
        .toMap((x) => x.key, (x) => x.value.first.icon!),
    _ => {},
  };
}

@Riverpod(keepAlive: true)
Map<String, SvgIcon> _iconTypeName(final Ref ref) {
  final layoutsRes = ref.watch(layoutIconsProvider);
  return switch (layoutsRes) {
    AsyncData(:final value) => value
        .where((x) => x.icon != null && x.layout?.typeName != null)
        .groupBy((x) => (x.layout!.typeName!, x.icon!))
        .keys
        .toMap((x) => x.$1, (x) => x.$2),
    _ => {},
  };
}

@Riverpod(keepAlive: true)
Map<String, SvgIcon> _iconName(final Ref ref) {
  final layoutsRes = ref.watch(layoutIconsProvider);
  return switch (layoutsRes) {
    AsyncData(:final value) => value
        .where((x) => x.icon != null && x.layout != null)
        .groupBy((x) => (x.layout!.iconName, x.icon!))
        .keys
        .toMap((x) => x.$1, (x) => x.$2),
    _ => {},
  };
}
