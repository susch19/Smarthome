import 'package:json_annotation/json_annotation.dart';

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

enum Command {
  @JsonValue(null)
  swaggerGeneratedUnknown(null),

  @JsonValue(0)
  none(0),
  @JsonValue(1)
  off(1),
  @JsonValue(2)
  on(2),
  @JsonValue(3)
  whoiam(3),
  @JsonValue(4)
  ip(4),
  @JsonValue(5)
  time(5),
  @JsonValue(6)
  temp(6),
  @JsonValue(7)
  brightness(7),
  @JsonValue(8)
  relativebrightness(8),
  @JsonValue(9)
  color(9),
  @JsonValue(10)
  mode(10),
  @JsonValue(11)
  onchangedconnections(11),
  @JsonValue(12)
  onnewconnection(12),
  @JsonValue(13)
  mesh(13),
  @JsonValue(14)
  delay(14),
  @JsonValue(15)
  rgb(15),
  @JsonValue(16)
  strobo(16),
  @JsonValue(17)
  rgbcycle(17),
  @JsonValue(18)
  lightwander(18),
  @JsonValue(19)
  rgbwander(19),
  @JsonValue(20)
  reverse(20),
  @JsonValue(21)
  singlecolor(21),
  @JsonValue(22)
  devicemapping(22),
  @JsonValue(23)
  calibration(23),
  @JsonValue(24)
  ota(24),
  @JsonValue(25)
  otapart(25),
  @JsonValue(26)
  log(26),
  @JsonValue(100)
  zigbee(100);

  final int? value;

  const Command(this.value);
}

enum Command2 {
  @JsonValue(null)
  swaggerGeneratedUnknown(null),

  @JsonValue('None')
  none('None'),
  @JsonValue('Off')
  off('Off'),
  @JsonValue('On')
  on('On'),
  @JsonValue('WhoIAm')
  whoiam('WhoIAm'),
  @JsonValue('IP')
  ip('IP'),
  @JsonValue('Time')
  time('Time'),
  @JsonValue('Temp')
  temp('Temp'),
  @JsonValue('Brightness')
  brightness('Brightness'),
  @JsonValue('RelativeBrightness')
  relativebrightness('RelativeBrightness'),
  @JsonValue('Color')
  color('Color'),
  @JsonValue('Mode')
  mode('Mode'),
  @JsonValue('OnChangedConnections')
  onchangedconnections('OnChangedConnections'),
  @JsonValue('OnNewConnection')
  onnewconnection('OnNewConnection'),
  @JsonValue('Mesh')
  mesh('Mesh'),
  @JsonValue('Delay')
  delay('Delay'),
  @JsonValue('RGB')
  rgb('RGB'),
  @JsonValue('Strobo')
  strobo('Strobo'),
  @JsonValue('RGBCycle')
  rgbcycle('RGBCycle'),
  @JsonValue('LightWander')
  lightwander('LightWander'),
  @JsonValue('RGBWander')
  rgbwander('RGBWander'),
  @JsonValue('Reverse')
  reverse('Reverse'),
  @JsonValue('SingleColor')
  singlecolor('SingleColor'),
  @JsonValue('DeviceMapping')
  devicemapping('DeviceMapping'),
  @JsonValue('Calibration')
  calibration('Calibration'),
  @JsonValue('Ota')
  ota('Ota'),
  @JsonValue('OtaPart')
  otapart('OtaPart'),
  @JsonValue('Log')
  log('Log'),
  @JsonValue('Zigbee')
  zigbee('Zigbee');

  final String? value;

  const Command2(this.value);
}

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
