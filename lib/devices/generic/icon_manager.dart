import 'dart:convert';
import 'dart:typed_data';

import 'package:signalr_core/signalr_core.dart';

class IconManager {
  static Map<String, Uint8List> cache = Map<String, Uint8List>();
  static Base64Decoder b64Decoder = Base64Decoder();

  static Future<Uint8List?> getIconForTypeName(
      String typeName, HubConnection connection) async {
    return _getIcon(typeName, "GetIconByTypeName", connection);
  }

  static Future<Uint8List?> getIconByName(
      String iconName, HubConnection connection) async {
    return _getIcon(iconName, "GetIconByName", connection);
  }

  static Future<Uint8List?> _getIcon(
      String name, String endpointName, HubConnection connection) async {
    if (cache.containsKey(name)) return cache[name];

    var res = await connection.invoke(endpointName, args: [name]) as String;
    var bytesIcon = b64Decoder.convert(res);
    cache[name] = bytesIcon;

    return bytesIcon;
  }

  static Future<Uint8List?> getIconForTypeNames(
      List<String> typeNames, HubConnection connection) async {
    for (var typeName in typeNames)
      if (cache.containsKey(typeName)) return cache[typeName];

    var typeName = typeNames.first;
    return getIconForTypeName(typeName, connection);
  }
}
