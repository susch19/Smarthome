import 'dart:async';
import 'dart:io';
import 'package:path/path.dart' as path;

import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
// import 'package:signalr_core/signalr_core.dart';
import 'package:signalr_netcore/signalr_client.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smarthome/devices/generic/icons/svg_icon.dart';
import 'package:smarthome/helper/cache_file_manager.dart';
import 'package:smarthome/helper/connection_manager.dart';

part 'icon_manager.g.dart';

// @riverpod
// FutureOr<Uint8List?> iconByTypeName(Ref ref, String typeName) async {
//   final iconCache = ref.watch(iconManagerProvider);
//   final result = iconCache[typeName];
//   if (result == null) {
//     final connection = ref.watch(hubConnectionConnectedProvider);
//     if (connection != null) {
//       return await ref
//           .read(iconManagerProvider.notifier)
//           ._getIconForTypeName(typeName, connection);
//     }
//   }
//   return result;
// }

// @riverpod
// FutureOr<Uint8List?> iconByName(Ref ref, String iconName) async {
//   final iconCache = ref.watch(iconManagerProvider);
//   final result = iconCache[iconName];
//   if (result == null) {
//     final connection = ref.watch(hubConnectionConnectedProvider);
//     if (connection != null) {
//       return await ref
//           .read(iconManagerProvider.notifier)
//           ._getIconByName(iconName, connection);
//     }
//   }
//   return result;
// }

@riverpod
FutureOr<Uint8List?> iconByTypeNames(Ref ref, List<String> names) async {
  final iconCache = ref.watch(iconManagerProvider);
  for (final name in names) {
    if (iconCache.containsKey(name)) {
      return iconCache[name];
    }
  }
  final connection = ref.watch(hubConnectionConnectedProvider);
  if (connection != null && names.isNotEmpty) {
    return await ref
        .read(iconManagerProvider.notifier)
        ._getIconForTypeName(names.first);
  }
  return null;
}

@Riverpod(keepAlive: true)
class IconManager extends _$IconManager {
  static final CacheFileManager _cacheFileManager = CacheFileManager(
      path.join(Directory.systemTemp.path, "smarthome_icon_cache"), "svg");

  HubConnection? _connection;

  @override
  Map<String, Uint8List> build() {
    _connection = ref.watch(hubConnectionConnectedProvider);
    return {};
  }

  FutureOr<Uint8List?> _getIconForTypeName(final String typeName) async {
    try {
      return await _getIcon(typeName, "GetIconByTypeName", true);
    } catch (e) {}
  }

  FutureOr<Uint8List?> _getIconByName(final String iconName) {
    return _getIcon(iconName, "GetIconByName", false);
  }

  FutureOr<String> _getIconHashForTypeName(final String typeName) async {
    final connection = _connection;
    if (connection == null) return "";
    return await connection.invoke("GetHashCodeByTypeName", args: [typeName])
        as String;
  }

  FutureOr<String> _getIconHashByName(final String iconName) async {
    final connection = _connection;
    if (connection == null) return "";
    return await connection.invoke("GetHashCodeByName", args: [iconName])
        as String;
  }

  FutureOr<Uint8List?> _getIcon(final String name, final String endpointName,
      final bool byTypeName) async {
    final cache = state;
    final connection = _connection;
    if (connection == null) return null;

    if (cache.containsKey(name)) return cache[name];

    final String hash;
    if (byTypeName) {
      hash = await _getIconHashForTypeName(name);
    } else {
      hash = await _getIconHashByName(name);
    }
    if (hash == "") return null;
    if (!kIsWeb) {
      await _cacheFileManager.ensureDirectoryExists();

      final hashLocal = await _cacheFileManager.readHashCode(name);
      if (hashLocal == hash) {
        final bytes = await _cacheFileManager.readContentAsBytes(name);
        if (bytes != null) return _putIntoCache(name, bytes);
      }
    }

    final res = await connection.invoke(endpointName, args: [name]);
    final svg = SvgIcon.fromJson(res as Map<String, dynamic>);

    if (!kIsWeb) {
      await _cacheFileManager.ensureDirectoryExists();
      await _cacheFileManager.writeHashCode(name, hash);
      await _cacheFileManager.writeContentAsBytes(name, svg.data!);

      return _putIntoCache(name, svg.data!);
    }

    return _putIntoCache(name, svg.data!);
  }

  Uint8List _putIntoCache(final String name, final Uint8List uint8list) {
    state = {...state, name: uint8list};
    // cache.state[name] = uint8list;
    // cache.state = cache.state.map((final key, final value) => MapEntry(key, value));
    // return uint8list;
    return uint8list;
  }
}
