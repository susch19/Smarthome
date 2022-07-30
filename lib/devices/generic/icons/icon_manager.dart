import 'dart:io';
import 'dart:typed_data';
import 'package:path/path.dart' as path;

import 'package:flutter/foundation.dart';
// import 'package:signalr_core/signalr_core.dart';
import 'package:signalr_netcore/signalr_client.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smarthome/devices/generic/icons/svg_icon.dart';
import 'package:smarthome/helper/cache_file_manager.dart';
import 'package:smarthome/helper/connection_manager.dart';

final _iconProvider = StateProvider<Map<String, Uint8List>>((final ref) {
  IconManager(ref);
  return {};
});

final iconByTypeNameProvider = Provider.autoDispose.family<Uint8List?, String>((final ref, final name) {
  final iconCache = ref.watch(_iconProvider);
  final result = iconCache[name];
  if (result == null) {
    final connection = ref.watch(hubConnectionConnectedProvider);
    if (connection != null) IconManager._getIconForTypeName(name, connection);
  }
  return result;
});

final iconByNameProvider = Provider.autoDispose.family<Uint8List?, String>((final ref, final name) {
  final iconCache = ref.watch(_iconProvider);
  final result = iconCache[name];
  if (result == null) {
    final connection = ref.watch(hubConnectionConnectedProvider);
    if (connection != null) IconManager._getIconByName(name, connection);
  }
  return result;
});

final iconByTypeNamesProvider = Provider.autoDispose.family<Uint8List?, List<String>>((final ref, final names) {
  final iconCache = ref.watch(_iconProvider);
  for (final name in names) {
    if (iconCache.containsKey(name)) return iconCache[name];
  }
  final connection = ref.watch(hubConnectionConnectedProvider);
  if (connection != null && names.isNotEmpty) IconManager._getIconByName(names.first, connection);
  return null;
});

class IconManager {
  static late StateProviderRef<Map<String, Uint8List>> _ref;

  static final CacheFileManager _cacheFileManager =
      CacheFileManager(path.join(Directory.systemTemp.path, "smarthome_icon_cache"), "svg");

  IconManager(final StateProviderRef<Map<String, Uint8List>> ref) {
    _ref = ref;
  }

  static Future<Uint8List?> _getIconForTypeName(final String typeName, final HubConnection connection) async {
    return _getIcon(typeName, "GetIconByTypeName", connection, true);
  }

  static Future<Uint8List?> _getIconByName(final String iconName, final HubConnection connection) async {
    return _getIcon(iconName, "GetIconByName", connection, false);
  }

  static Future<String> _getIconHashForTypeName(final String typeName, final HubConnection connection) async {
    return await connection.invoke("GetHashCodeByTypeName", args: [typeName]) as String;
  }

  static Future<String> _getIconHashByName(final String iconName, final HubConnection connection) async {
    return await connection.invoke("GetHashCodeByName", args: [iconName]) as String;
  }

  static Future<Uint8List?> _getIcon(
      final String name, final String endpointName, final HubConnection connection, final bool byTypeName) async {
    final cache = _ref.read(_iconProvider.notifier);
    if (cache.state.containsKey(name)) return cache.state[name];

    String hash;
    if (byTypeName) {
      hash = await _getIconHashForTypeName(name, connection);
    } else {
      hash = await _getIconHashByName(name, connection);
    }
    if (!kIsWeb) {
      await _cacheFileManager.ensureDirectoryExists();

      final hashLocal = await _cacheFileManager.readHashCode(name);
      if (hashLocal == hash) {
        final bytes = await _cacheFileManager.readContentAsBytes(name);
        if (bytes != null) return _putIntoCache(cache, name, bytes);
      }
    }

    final res = await connection.invoke(endpointName, args: [name]);
    final svg = SvgIcon.fromJson(res as Map<String, dynamic>);

    if (!kIsWeb) {
      await _cacheFileManager.ensureDirectoryExists();
      await _cacheFileManager.writeHashCode(name, hash);
      await _cacheFileManager.writeContentAsBytes(name, svg.data!);

      return _putIntoCache(cache, name, svg.data!);
    }

    return _putIntoCache(cache, name, svg.data!);
  }

  static Uint8List _putIntoCache(
      final StateController<Map<String, Uint8List>> cache, final String name, final Uint8List uint8list) {
    cache.state[name] = uint8list;
    cache.state = cache.state.map((final key, final value) => MapEntry(key, value));
    return uint8list;
  }
}
