import 'dart:convert';
import 'dart:typed_data';

import 'package:signalr_core/signalr_core.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smarthome/helper/connection_manager.dart';

final _iconProvider = StateProvider<Map<String, Uint8List>>((final ref) {
  IconManager(ref);
  return {};
});

final iconByTypeNameProvider = Provider.family<Uint8List?, String>((final ref, final name) {
  final iconCache = ref.watch(_iconProvider);
  final result = iconCache[name];
  if (result == null) {
    final connection = ref.watch(hubConnectionConnectedProvider);
    if (connection != null) IconManager._getIconForTypeName(name, connection);
  }
  return result;
});

final iconByNameProvider = Provider.family<Uint8List?, String>((final ref, final name) {
  final iconCache = ref.watch(_iconProvider);
  final result = iconCache[name];
  if (result == null) {
    final connection = ref.watch(hubConnectionConnectedProvider);
    if (connection != null) IconManager._getIconByName(name, connection);
  }
  return result;
});

final iconByTypeNamesProvider = Provider.family<Uint8List?, List<String>>((final ref, final names) {
  final iconCache = ref.watch(_iconProvider);
  for (final name in names) {
    if (iconCache.containsKey(name)) return iconCache[name];
  }
  final connection = ref.watch(hubConnectionConnectedProvider);
  if (connection != null && names.isNotEmpty) IconManager._getIconByName(names.first, connection);
  return null;
});

class IconManager {
  static const Base64Decoder _b64Decoder = Base64Decoder();
  static late StateProviderRef<Map<String, Uint8List>> _ref;

  IconManager(final StateProviderRef<Map<String, Uint8List>> ref) {
    _ref = ref;
  }

  static Future<Uint8List?> _getIconForTypeName(final String typeName, final HubConnection connection) async {
    return _getIcon(typeName, "GetIconByTypeName", connection);
  }

  static Future<Uint8List?> _getIconByName(final String iconName, final HubConnection connection) async {
    return _getIcon(iconName, "GetIconByName", connection);
  }

  static Future<Uint8List?> _getIcon(
      final String name, final String endpointName, final HubConnection connection) async {
    final cache = _ref.read(_iconProvider.notifier);
    if (cache.state.containsKey(name)) return cache.state[name];
    final res = await connection.invoke(endpointName, args: [name]) as String;
    final bytesIcon = _b64Decoder.convert(res);
    cache.state[name] = bytesIcon;
    cache.state = cache.state.map((final key, final value) => MapEntry(key, value));
    return bytesIcon;
  }
}
