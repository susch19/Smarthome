// coverage:ignore-file
// ignore_for_file: type=lint

import 'package:json_annotation/json_annotation.dart';
import 'package:collection/collection.dart';

enum AppLogLevel {
  @JsonValue(null)
  swaggerGeneratedUnknown(null),

  @JsonValue(0)
  fatal(0),
  @JsonValue(1)
  error(1),
  @JsonValue(2)
  warning(2),
  @JsonValue(3)
  info(3),
  @JsonValue(4)
  debug(4);

  final int? value;

  const AppLogLevel(this.value);
}

enum DasboardSpecialType {
  @JsonValue(null)
  swaggerGeneratedUnknown(null),

  @JsonValue('None')
  none('None'),
  @JsonValue('Right')
  right('Right'),
  @JsonValue('Availability')
  availability('Availability'),
  @JsonValue('Color')
  color('Color'),
  @JsonValue('Disabled')
  disabled('Disabled'),
  @JsonValue('Battery')
  battery('Battery');

  final String? value;

  const DasboardSpecialType(this.value);
}

enum FontStyleSetting {
  @JsonValue(null)
  swaggerGeneratedUnknown(null),

  @JsonValue('Normal')
  normal('Normal'),
  @JsonValue('Italic')
  italic('Italic');

  final String? value;

  const FontStyleSetting(this.value);
}

enum FontWeightSetting {
  @JsonValue(null)
  swaggerGeneratedUnknown(null),

  @JsonValue('Normal')
  normal('Normal'),
  @JsonValue('Bold')
  bold('Bold');

  final String? value;

  const FontWeightSetting(this.value);
}

enum MessageType {
  @JsonValue(null)
  swaggerGeneratedUnknown(null),

  @JsonValue('Get')
  $get('Get'),
  @JsonValue('Update')
  update('Update'),
  @JsonValue('Options')
  options('Options'),
  @JsonValue('Relay')
  relay('Relay');

  final String? value;

  const MessageType(this.value);
}
