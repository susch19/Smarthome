import 'package:json_annotation/json_annotation.dart';
import 'package:collection/collection.dart';

enum StackTraceUsage {
  @JsonValue(null)
  swaggerGeneratedUnknown(null),

  @JsonValue(0)
  none(0),
  @JsonValue(1)
  withstacktrace(1),
  @JsonValue(1)
  withoutsource(1),
  @JsonValue(2)
  withfilenameandlinenumber(2),
  @JsonValue(3)
  withsource(3),
  @JsonValue(3)
  max(3),
  @JsonValue(4)
  withcallsite(4),
  @JsonValue(8)
  withcallsiteclassname(8);

  final int? value;

  const StackTraceUsage(this.value);
}

enum MethodAttributes {
  @JsonValue(null)
  swaggerGeneratedUnknown(null),

  @JsonValue(0)
  privatescope(0),
  @JsonValue(0)
  reuseslot(0),
  @JsonValue(1)
  private(1),
  @JsonValue(2)
  famandassem(2),
  @JsonValue(3)
  assembly(3),
  @JsonValue(4)
  family(4),
  @JsonValue(5)
  famorassem(5),
  @JsonValue(6)
  public(6),
  @JsonValue(7)
  memberaccessmask(7),
  @JsonValue(8)
  unmanagedexport(8),
  @JsonValue(16)
  $static(16),
  @JsonValue(32)
  $final(32),
  @JsonValue(64)
  virtual(64),
  @JsonValue(128)
  hidebysig(128),
  @JsonValue(256)
  newslot(256),
  @JsonValue(256)
  vtablelayoutmask(256),
  @JsonValue(512)
  checkaccessonoverride(512),
  @JsonValue(1024)
  $abstract(1024),
  @JsonValue(2048)
  specialname(2048),
  @JsonValue(4096)
  rtspecialname(4096),
  @JsonValue(8192)
  pinvokeimpl(8192),
  @JsonValue(16384)
  hassecurity(16384),
  @JsonValue(32768)
  requiresecobject(32768),
  @JsonValue(53248)
  reservedmask(53248);

  final int? value;

  const MethodAttributes(this.value);
}

enum MethodImplAttributes {
  @JsonValue(null)
  swaggerGeneratedUnknown(null),

  @JsonValue(0)
  il(0),
  @JsonValue(0)
  managed(0),
  @JsonValue(1)
  native(1),
  @JsonValue(2)
  optil(2),
  @JsonValue(3)
  codetypemask(3),
  @JsonValue(3)
  runtime(3),
  @JsonValue(4)
  managedmask(4),
  @JsonValue(4)
  unmanaged(4),
  @JsonValue(8)
  noinlining(8),
  @JsonValue(16)
  forwardref(16),
  @JsonValue(32)
  synchronized(32),
  @JsonValue(64)
  nooptimization(64),
  @JsonValue(128)
  preservesig(128),
  @JsonValue(256)
  aggressiveinlining(256),
  @JsonValue(512)
  aggressiveoptimization(512),
  @JsonValue(4096)
  internalcall(4096),
  @JsonValue(65535)
  maxmethodimplval(65535);

  final int? value;

  const MethodImplAttributes(this.value);
}

enum CallingConventions {
  @JsonValue(null)
  swaggerGeneratedUnknown(null),

  @JsonValue(1)
  standard(1),
  @JsonValue(2)
  varargs(2),
  @JsonValue(3)
  any(3),
  @JsonValue(32)
  hasthis(32),
  @JsonValue(64)
  explicitthis(64);

  final int? value;

  const CallingConventions(this.value);
}

enum MemberTypes {
  @JsonValue(null)
  swaggerGeneratedUnknown(null),

  @JsonValue(1)
  constructor(1),
  @JsonValue(2)
  event(2),
  @JsonValue(4)
  field(4),
  @JsonValue(8)
  method(8),
  @JsonValue(16)
  property(16),
  @JsonValue(32)
  typeinfo(32),
  @JsonValue(64)
  custom(64),
  @JsonValue(128)
  nestedtype(128),
  @JsonValue(191)
  all(191);

  final int? value;

  const MemberTypes(this.value);
}

enum EventAttributes {
  @JsonValue(null)
  swaggerGeneratedUnknown(null),

  @JsonValue(0)
  none(0),
  @JsonValue(512)
  specialname(512),
  @JsonValue(1024)
  rtspecialname(1024),
  @JsonValue(1024)
  reservedmask(1024);

  final int? value;

  const EventAttributes(this.value);
}

enum ParameterAttributes {
  @JsonValue(null)
  swaggerGeneratedUnknown(null),

  @JsonValue(0)
  none(0),
  @JsonValue(1)
  $in(1),
  @JsonValue(2)
  out(2),
  @JsonValue(4)
  lcid(4),
  @JsonValue(8)
  retval(8),
  @JsonValue(16)
  optional(16),
  @JsonValue(4096)
  hasdefault(4096),
  @JsonValue(8192)
  hasfieldmarshal(8192),
  @JsonValue(16384)
  reserved3(16384),
  @JsonValue(32768)
  reserved4(32768),
  @JsonValue(61440)
  reservedmask(61440);

  final int? value;

  const ParameterAttributes(this.value);
}

enum FieldAttributes {
  @JsonValue(null)
  swaggerGeneratedUnknown(null),

  @JsonValue(0)
  privatescope(0),
  @JsonValue(1)
  private(1),
  @JsonValue(2)
  famandassem(2),
  @JsonValue(3)
  assembly(3),
  @JsonValue(4)
  family(4),
  @JsonValue(5)
  famorassem(5),
  @JsonValue(6)
  public(6),
  @JsonValue(7)
  fieldaccessmask(7),
  @JsonValue(16)
  $static(16),
  @JsonValue(32)
  initonly(32),
  @JsonValue(64)
  literal(64),
  @JsonValue(128)
  notserialized(128),
  @JsonValue(256)
  hasfieldrva(256),
  @JsonValue(512)
  specialname(512),
  @JsonValue(1024)
  rtspecialname(1024),
  @JsonValue(4096)
  hasfieldmarshal(4096),
  @JsonValue(8192)
  pinvokeimpl(8192),
  @JsonValue(32768)
  hasdefault(32768),
  @JsonValue(38144)
  reservedmask(38144);

  final int? value;

  const FieldAttributes(this.value);
}

enum PropertyAttributes {
  @JsonValue(null)
  swaggerGeneratedUnknown(null),

  @JsonValue(0)
  none(0),
  @JsonValue(512)
  specialname(512),
  @JsonValue(1024)
  rtspecialname(1024),
  @JsonValue(4096)
  hasdefault(4096),
  @JsonValue(8192)
  reserved2(8192),
  @JsonValue(16384)
  reserved3(16384),
  @JsonValue(32768)
  reserved4(32768),
  @JsonValue(62464)
  reservedmask(62464);

  final int? value;

  const PropertyAttributes(this.value);
}

enum SecurityRuleSet {
  @JsonValue(null)
  swaggerGeneratedUnknown(null),

  @JsonValue(0)
  none(0),
  @JsonValue(1)
  level1(1),
  @JsonValue(2)
  level2(2);

  final int? value;

  const SecurityRuleSet(this.value);
}

enum FilterResult {
  @JsonValue(null)
  swaggerGeneratedUnknown(null),

  @JsonValue(0)
  neutral(0),
  @JsonValue(1)
  log(1),
  @JsonValue(2)
  ignore(2),
  @JsonValue(3)
  logfinal(3),
  @JsonValue(4)
  ignorefinal(4);

  final int? value;

  const FilterResult(this.value);
}

enum CultureTypes {
  @JsonValue(null)
  swaggerGeneratedUnknown(null),

  @JsonValue(1)
  neutralcultures(1),
  @JsonValue(2)
  specificcultures(2),
  @JsonValue(4)
  installedwin32cultures(4),
  @JsonValue(7)
  allcultures(7),
  @JsonValue(8)
  usercustomculture(8),
  @JsonValue(16)
  replacementcultures(16),
  @JsonValue(32)
  windowsonlycultures(32),
  @JsonValue(64)
  frameworkcultures(64);

  final int? value;

  const CultureTypes(this.value);
}

enum DigitShapes {
  @JsonValue(null)
  swaggerGeneratedUnknown(null),

  @JsonValue(0)
  context(0),
  @JsonValue(1)
  none(1),
  @JsonValue(2)
  nativenational(2);

  final int? value;

  const DigitShapes(this.value);
}

enum CalendarAlgorithmType {
  @JsonValue(null)
  swaggerGeneratedUnknown(null),

  @JsonValue(0)
  unknown(0),
  @JsonValue(1)
  solarcalendar(1),
  @JsonValue(2)
  lunarcalendar(2),
  @JsonValue(3)
  lunisolarcalendar(3);

  final int? value;

  const CalendarAlgorithmType(this.value);
}

enum CalendarId {
  @JsonValue(null)
  swaggerGeneratedUnknown(null),

  @JsonValue(0)
  uninitializedValue(0),
  @JsonValue(1)
  gregorian(1),
  @JsonValue(2)
  gregorianUs(2),
  @JsonValue(3)
  japan(3),
  @JsonValue(4)
  taiwan(4),
  @JsonValue(5)
  korea(5),
  @JsonValue(6)
  hijri(6),
  @JsonValue(7)
  thai(7),
  @JsonValue(8)
  hebrew(8),
  @JsonValue(9)
  gregorianMeFrench(9),
  @JsonValue(10)
  gregorianArabic(10),
  @JsonValue(11)
  gregorianXlitEnglish(11),
  @JsonValue(12)
  gregorianXlitFrench(12),
  @JsonValue(13)
  julian(13),
  @JsonValue(14)
  japaneselunisolar(14),
  @JsonValue(15)
  chineselunisolar(15),
  @JsonValue(16)
  saka(16),
  @JsonValue(17)
  lunarEtoChn(17),
  @JsonValue(18)
  lunarEtoKor(18),
  @JsonValue(19)
  lunarEtoRokuyou(19),
  @JsonValue(20)
  koreanlunisolar(20),
  @JsonValue(21)
  taiwanlunisolar(21),
  @JsonValue(22)
  persian(22),
  @JsonValue(23)
  umalqura(23),
  @JsonValue(23)
  lastCalendar(23);

  final int? value;

  const CalendarId(this.value);
}

enum DayOfWeek {
  @JsonValue(null)
  swaggerGeneratedUnknown(null),

  @JsonValue(0)
  sunday(0),
  @JsonValue(1)
  monday(1),
  @JsonValue(2)
  tuesday(2),
  @JsonValue(3)
  wednesday(3),
  @JsonValue(4)
  thursday(4),
  @JsonValue(5)
  friday(5),
  @JsonValue(6)
  saturday(6);

  final int? value;

  const DayOfWeek(this.value);
}

enum CalendarWeekRule {
  @JsonValue(null)
  swaggerGeneratedUnknown(null),

  @JsonValue(0)
  firstday(0),
  @JsonValue(1)
  firstfullweek(1),
  @JsonValue(2)
  firstfourdayweek(2);

  final int? value;

  const CalendarWeekRule(this.value);
}

enum DateTimeFormatFlags {
  @JsonValue(null)
  swaggerGeneratedUnknown(null),

  @JsonValue(0)
  none(0),
  @JsonValue(1)
  usegenitivemonth(1),
  @JsonValue(2)
  useleapyearmonth(2),
  @JsonValue(4)
  usespacesinmonthnames(4),
  @JsonValue(8)
  usehebrewrule(8),
  @JsonValue(16)
  usespacesindaynames(16),
  @JsonValue(32)
  usedigitprefixintokens(32),
  @JsonValue(-1)
  notinitialized(-1);

  final int? value;

  const DateTimeFormatFlags(this.value);
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

enum EditType {
  @JsonValue(null)
  swaggerGeneratedUnknown(null),

  @JsonValue('Button')
  button('Button'),
  @JsonValue('RaisedButton')
  raisedbutton('RaisedButton'),
  @JsonValue('FloatingActionButton')
  floatingactionbutton('FloatingActionButton'),
  @JsonValue('IconButton')
  iconbutton('IconButton'),
  @JsonValue('Toggle')
  toggle('Toggle'),
  @JsonValue('Dropdown')
  dropdown('Dropdown'),
  @JsonValue('Slider')
  slider('Slider'),
  @JsonValue('Input')
  input('Input'),
  @JsonValue('Icon')
  icon('Icon'),
  @JsonValue('Radial')
  radial('Radial');

  final String? value;

  const EditType(this.value);
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
