import 'dart:convert';
import 'dart:typed_data';

import 'package:json_annotation/json_annotation.dart';

part 'svg_icon.g.dart';

@JsonSerializable()
class SvgIcon {
  static const Base64Decoder _b64Decoder = Base64Decoder();

  String name;
  String hash;
  @JsonKey(fromJson: _dataFromJson, toJson: _dataToJson, includeIfNull: false)
  Uint8List? data;

  SvgIcon(this.name, this.hash, {this.data});

  @override
  bool operator ==(final Object other) =>
      other is SvgIcon && name == other.name && hash == other.hash;

  @override
  int get hashCode => Object.hash(super.hashCode, name, hash);

  factory SvgIcon.fromJson(final Map<String, dynamic> json) =>
      _$SvgIconFromJson(json);

  Map<String, dynamic> toJson() => _$SvgIconToJson(this);

  static Uint8List? _dataFromJson(final dynamic jsonData) {
    if (jsonData == null) return null;
    return _b64Decoder.convert(jsonData);
  }

  static String? _dataToJson(final Uint8List? data) {
    if (data == null) return null;
    return base64.encode(data);
  }
}
