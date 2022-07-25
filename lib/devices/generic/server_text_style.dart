import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

part 'server_text_style.g.dart';

@JsonSerializable()
class ServerTextStyle {
  FontStyle fontStyle;
  @JsonKey(fromJson: _fontWeightFromJson, toJson: _fontWeightToJson)
  FontWeight fontWeight;
  String? fontFamily;
  double? fontSize;

  ServerTextStyle(this.fontFamily, this.fontWeight, this.fontStyle);

  @override
  bool operator ==(final Object other) =>
      other is ServerTextStyle &&
      other.fontStyle == fontStyle &&
      other.fontWeight == fontWeight &&
      fontFamily == other.fontFamily &&
      fontSize == other.fontSize;

  @override
  int get hashCode => Object.hash(fontStyle, fontWeight, fontFamily, fontSize);

  TextStyle toTextStyle() {
    var ts = const TextStyle();
    if (fontSize != null) ts = ts.copyWith(fontSize: fontSize);
    if (fontFamily != null && fontFamily != "") ts = ts.copyWith(fontFamily: fontFamily);
    ts = ts.copyWith(fontStyle: fontStyle);
    ts = ts.copyWith(fontWeight: fontWeight);
    return ts;
  }

  factory ServerTextStyle.fromJson(final Map<String, dynamic> json) => _$ServerTextStyleFromJson(json);

  Map<String, dynamic> toJson() => _$ServerTextStyleToJson(this);

  static FontWeight _fontWeightFromJson(final dynamic abc) {
    return $enumDecode<FontWeightEnum, String>(_$FontWeightEnumMap, abc) == FontWeightEnum.bold
        ? FontWeight.bold
        : FontWeight.normal;
  }

  static String _fontWeightToJson(final FontWeight abc) {
    return _$FontWeightEnumMap[abc]!;
  }
}

enum FontWeightEnum { normal, bold }

const _$FontWeightEnumMap = {
  FontWeightEnum.normal: 'normal',
  FontWeightEnum.bold: 'bold',
};
