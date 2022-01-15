import 'package:flutter/cupertino.dart';
import 'package:json_annotation/json_annotation.dart';

part 'server_text_style.g.dart';

@JsonSerializable()
class ServerTextStyle {
  // @JsonKey(fromJson: _fontStyleFromJson, toJson: _fontStyleToJson)
  FontStyle fontStyle;
  @JsonKey(fromJson: _fontWeightFromJson, toJson: _fontWeightToJson)
  FontWeight fontWeight;
  String? fontFamily;
  double? fontSize;

  ServerTextStyle(this.fontFamily, this.fontWeight, this.fontStyle);

  TextStyle toTextStyle() {
    var ts = TextStyle();
    if (fontSize != null) ts = ts.copyWith(fontSize: fontSize);
    if (fontFamily != null && fontFamily != "") ts = ts.copyWith(fontFamily: fontFamily);
    ts = ts.copyWith(fontStyle: fontStyle);
    ts = ts.copyWith(fontWeight: fontWeight);
    return ts;
  }

  factory ServerTextStyle.fromJson(Map<String, dynamic> json) => _$ServerTextStyleFromJson(json);

  Map<String, dynamic> toJson() => _$ServerTextStyleToJson(this);

  static FontWeight _fontWeightFromJson(dynamic abc) {
    // var str = abc as num;
    // if (str == 1) return FontWeight.bold;
    // return FontWeight.normal;
    return _$enumDecode(_$FontWeightEnumMap, abc);
  }

  static String _fontWeightToJson(FontWeight abc) {
    // if (abc == FontWeight.bold) return 1;
    // return 0;

    return _$FontWeightEnumMap[abc]!;
  }

  // static FontStyle? _fontStyleFromJson(dynamic abc) {
  //   var str = abc as num;
  //   if (str == 1) return FontStyle.italic;
  //   return FontStyle.normal;
  // }

  // static num _fontStyleToJson(FontStyle? abc) {
  //   if (abc == FontStyle.normal) return 1;
  //   return 0;
  // }
}

const _$FontWeightEnumMap = {
  FontWeight.normal: 'normal',
  FontWeight.bold: 'bold',
};
