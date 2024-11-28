import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:smarthome/restapi/swagger.enums.swagger.dart';
import 'package:smarthome/restapi/swagger.swagger.dart';

part 'property_info.g.dart';

@JsonSerializable(explicitToJson: true)
class DashboardPropertyInfo extends LayoutBasePropertyInfo {
  const DashboardPropertyInfo({
    required this.specialType,
    required super.name,
    required super.order,
    super.textStyle,
    super.editInfo,
    super.rowNr,
    required super.unitOfMeasurement,
    required super.format,
    super.showOnlyInDeveloperMode,
    super.deviceId,
    super.expanded,
    super.precision,
    super.extensionData,
    required super.displayName,
  });

  factory DashboardPropertyInfo.fromJson(Map<String, dynamic> json) =>
      _$DashboardPropertyInfoFromJson(json);

  static const toJsonFactory = _$DashboardPropertyInfoToJson;
  Map<String, dynamic> toJson() => _$DashboardPropertyInfoToJson(this);

  @JsonKey(
    name: 'specialType',
    toJson: dasboardSpecialTypeToJson,
    fromJson: dasboardSpecialTypeFromJson,
  )
  final DasboardSpecialType specialType;

  static const fromJsonFactory = _$DashboardPropertyInfoFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is LayoutBasePropertyInfo && super == (other)) ||
        (other is DashboardPropertyInfo &&
            (identical(other.specialType, specialType) ||
                const DeepCollectionEquality()
                    .equals(other.specialType, specialType)));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(specialType) ^
      const DeepCollectionEquality().hash(super.hashCode) ^
      runtimeType.hashCode;
}

extension $DashboardPropertyInfoExtension on DashboardPropertyInfo {
  DashboardPropertyInfo copyWith(
      {DasboardSpecialType? specialType,
      String? name,
      int? order,
      TextSettings? textStyle,
      PropertyEditInformation? editInfo,
      int? rowNr,
      String? unitOfMeasurement,
      String? format,
      bool? showOnlyInDeveloperMode,
      int? deviceId,
      bool? expanded,
      int? precision,
      Map<String, dynamic>? extensionData,
      String? displayName}) {
    return DashboardPropertyInfo(
        specialType: specialType ?? this.specialType,
        name: name ?? this.name,
        order: order ?? this.order,
        textStyle: textStyle ?? this.textStyle,
        editInfo: editInfo ?? this.editInfo,
        rowNr: rowNr ?? this.rowNr,
        unitOfMeasurement: unitOfMeasurement ?? this.unitOfMeasurement,
        format: format ?? this.format,
        showOnlyInDeveloperMode:
            showOnlyInDeveloperMode ?? this.showOnlyInDeveloperMode,
        deviceId: deviceId ?? this.deviceId,
        expanded: expanded ?? this.expanded,
        precision: precision ?? this.precision,
        extensionData: extensionData ?? this.extensionData,
        displayName: displayName ?? this.displayName);
  }

  DashboardPropertyInfo copyWithWrapped(
      {Wrapped<DasboardSpecialType>? specialType,
      Wrapped<String>? name,
      Wrapped<int>? order,
      Wrapped<TextSettings?>? textStyle,
      Wrapped<PropertyEditInformation?>? editInfo,
      Wrapped<int?>? rowNr,
      Wrapped<String>? unitOfMeasurement,
      Wrapped<String>? format,
      Wrapped<bool?>? showOnlyInDeveloperMode,
      Wrapped<int?>? deviceId,
      Wrapped<bool?>? expanded,
      Wrapped<int?>? precision,
      Wrapped<Map<String, dynamic>?>? extensionData,
      Wrapped<String>? displayName}) {
    return DashboardPropertyInfo(
        specialType:
            (specialType != null ? specialType.value : this.specialType),
        name: (name != null ? name.value : this.name),
        order: (order != null ? order.value : this.order),
        textStyle: (textStyle != null ? textStyle.value : this.textStyle),
        editInfo: (editInfo != null ? editInfo.value : this.editInfo),
        rowNr: (rowNr != null ? rowNr.value : this.rowNr),
        unitOfMeasurement: (unitOfMeasurement != null
            ? unitOfMeasurement.value
            : this.unitOfMeasurement),
        format: (format != null ? format.value : this.format),
        showOnlyInDeveloperMode: (showOnlyInDeveloperMode != null
            ? showOnlyInDeveloperMode.value
            : this.showOnlyInDeveloperMode),
        deviceId: (deviceId != null ? deviceId.value : this.deviceId),
        expanded: (expanded != null ? expanded.value : this.expanded),
        precision: (precision != null ? precision.value : this.precision),
        extensionData:
            (extensionData != null ? extensionData.value : this.extensionData),
        displayName:
            (displayName != null ? displayName.value : this.displayName));
  }
}

@JsonSerializable(explicitToJson: true)
class DetailPropertyInfo extends LayoutBasePropertyInfo {
  const DetailPropertyInfo({
    this.tabInfoId,
    required this.blurryCard,
    required this.specialType,
    required super.name,
    required super.order,
    super.textStyle,
    super.editInfo,
    super.rowNr,
    required super.unitOfMeasurement,
    required super.format,
    super.showOnlyInDeveloperMode,
    super.deviceId,
    super.expanded,
    super.precision,
    super.extensionData,
    required super.displayName,
  });

  factory DetailPropertyInfo.fromJson(Map<String, dynamic> json) =>
      _$DetailPropertyInfoFromJson(json);

  static const toJsonFactory = _$DetailPropertyInfoToJson;
  Map<String, dynamic> toJson() => _$DetailPropertyInfoToJson(this);

  @JsonKey(name: 'tabInfoId')
  final int? tabInfoId;
  @JsonKey(name: 'blurryCard')
  final bool blurryCard;
  @JsonKey(name: 'specialType')
  final String specialType;

  static const fromJsonFactory = _$DetailPropertyInfoFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is LayoutBasePropertyInfo && super == (other)) &&
            (other is DetailPropertyInfo &&
                (identical(other.tabInfoId, tabInfoId) ||
                    const DeepCollectionEquality()
                        .equals(other.tabInfoId, tabInfoId)) &&
                (identical(other.blurryCard, blurryCard) ||
                    const DeepCollectionEquality()
                        .equals(other.blurryCard, blurryCard)) &&
                (identical(other.specialType, specialType) ||
                    const DeepCollectionEquality()
                        .equals(other.specialType, specialType)));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(tabInfoId) ^
      const DeepCollectionEquality().hash(blurryCard) ^
      const DeepCollectionEquality().hash(specialType) ^
      const DeepCollectionEquality().hash(super.hashCode) ^
      runtimeType.hashCode;
}

extension $DetailPropertyInfoExtension on DetailPropertyInfo {
  DetailPropertyInfo copyWith(
      {int? tabInfoId,
      bool? blurryCard,
      String? specialType,
      String? name,
      int? order,
      TextSettings? textStyle,
      PropertyEditInformation? editInfo,
      int? rowNr,
      String? unitOfMeasurement,
      String? format,
      bool? showOnlyInDeveloperMode,
      int? deviceId,
      bool? expanded,
      int? precision,
      Map<String, dynamic>? extensionData,
      String? displayName}) {
    return DetailPropertyInfo(
        tabInfoId: tabInfoId ?? this.tabInfoId,
        blurryCard: blurryCard ?? this.blurryCard,
        specialType: specialType ?? this.specialType,
        name: name ?? this.name,
        order: order ?? this.order,
        textStyle: textStyle ?? this.textStyle,
        editInfo: editInfo ?? this.editInfo,
        rowNr: rowNr ?? this.rowNr,
        unitOfMeasurement: unitOfMeasurement ?? this.unitOfMeasurement,
        format: format ?? this.format,
        showOnlyInDeveloperMode:
            showOnlyInDeveloperMode ?? this.showOnlyInDeveloperMode,
        deviceId: deviceId ?? this.deviceId,
        expanded: expanded ?? this.expanded,
        precision: precision ?? this.precision,
        extensionData: extensionData ?? this.extensionData,
        displayName: displayName ?? this.displayName);
  }

  DetailPropertyInfo copyWithWrapped(
      {Wrapped<int?>? tabInfoId,
      Wrapped<bool>? blurryCard,
      Wrapped<String>? specialType,
      Wrapped<String>? name,
      Wrapped<int>? order,
      Wrapped<TextSettings?>? textStyle,
      Wrapped<PropertyEditInformation?>? editInfo,
      Wrapped<int?>? rowNr,
      Wrapped<String>? unitOfMeasurement,
      Wrapped<String>? format,
      Wrapped<bool?>? showOnlyInDeveloperMode,
      Wrapped<int?>? deviceId,
      Wrapped<bool?>? expanded,
      Wrapped<int?>? precision,
      Wrapped<Map<String, dynamic>?>? extensionData,
      Wrapped<String>? displayName}) {
    return DetailPropertyInfo(
        tabInfoId: (tabInfoId != null ? tabInfoId.value : this.tabInfoId),
        blurryCard: (blurryCard != null ? blurryCard.value : this.blurryCard),
        specialType:
            (specialType != null ? specialType.value : this.specialType),
        name: (name != null ? name.value : this.name),
        order: (order != null ? order.value : this.order),
        textStyle: (textStyle != null ? textStyle.value : this.textStyle),
        editInfo: (editInfo != null ? editInfo.value : this.editInfo),
        rowNr: (rowNr != null ? rowNr.value : this.rowNr),
        unitOfMeasurement: (unitOfMeasurement != null
            ? unitOfMeasurement.value
            : this.unitOfMeasurement),
        format: (format != null ? format.value : this.format),
        showOnlyInDeveloperMode: (showOnlyInDeveloperMode != null
            ? showOnlyInDeveloperMode.value
            : this.showOnlyInDeveloperMode),
        deviceId: (deviceId != null ? deviceId.value : this.deviceId),
        expanded: (expanded != null ? expanded.value : this.expanded),
        precision: (precision != null ? precision.value : this.precision),
        extensionData:
            (extensionData != null ? extensionData.value : this.extensionData),
        displayName:
            (displayName != null ? displayName.value : this.displayName));
  }
}

@JsonSerializable(explicitToJson: true)
class LayoutBasePropertyInfo {
  const LayoutBasePropertyInfo({
    required this.name,
    required this.order,
    this.textStyle,
    this.editInfo,
    this.rowNr,
    required this.unitOfMeasurement,
    required this.format,
    this.showOnlyInDeveloperMode,
    this.deviceId,
    this.expanded,
    this.precision,
    this.extensionData,
    required this.displayName,
  });

  factory LayoutBasePropertyInfo.fromJson(Map<String, dynamic> json) =>
      _$LayoutBasePropertyInfoFromJson(json);

  static const toJsonFactory = _$LayoutBasePropertyInfoToJson;
  Map<String, dynamic> toJson() => _$LayoutBasePropertyInfoToJson(this);

  @JsonKey(name: 'name')
  final String name;
  @JsonKey(name: 'order')
  final int order;
  @JsonKey(name: 'textStyle')
  final TextSettings? textStyle;
  @JsonKey(name: 'editInfo')
  final PropertyEditInformation? editInfo;
  @JsonKey(name: 'rowNr')
  final int? rowNr;
  @JsonKey(name: 'unitOfMeasurement')
  final String unitOfMeasurement;
  @JsonKey(name: 'format')
  final String format;
  @JsonKey(name: 'showOnlyInDeveloperMode')
  final bool? showOnlyInDeveloperMode;
  @JsonKey(name: 'deviceId')
  final int? deviceId;
  @JsonKey(name: 'expanded')
  final bool? expanded;
  @JsonKey(name: 'precision')
  final int? precision;
  @JsonKey(name: 'extensionData')
  final Map<String, dynamic>? extensionData;
  @JsonKey(name: 'displayName')
  final String displayName;
  static const fromJsonFactory = _$LayoutBasePropertyInfoFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is LayoutBasePropertyInfo &&
            (identical(other.name, name) ||
                const DeepCollectionEquality().equals(other.name, name)) &&
            (identical(other.order, order) ||
                const DeepCollectionEquality().equals(other.order, order)) &&
            (identical(other.textStyle, textStyle) ||
                const DeepCollectionEquality()
                    .equals(other.textStyle, textStyle)) &&
            (identical(other.editInfo, editInfo) ||
                const DeepCollectionEquality()
                    .equals(other.editInfo, editInfo)) &&
            (identical(other.rowNr, rowNr) ||
                const DeepCollectionEquality().equals(other.rowNr, rowNr)) &&
            (identical(other.unitOfMeasurement, unitOfMeasurement) ||
                const DeepCollectionEquality()
                    .equals(other.unitOfMeasurement, unitOfMeasurement)) &&
            (identical(other.format, format) ||
                const DeepCollectionEquality().equals(other.format, format)) &&
            (identical(
                    other.showOnlyInDeveloperMode, showOnlyInDeveloperMode) ||
                const DeepCollectionEquality().equals(
                    other.showOnlyInDeveloperMode, showOnlyInDeveloperMode)) &&
            (identical(other.deviceId, deviceId) ||
                const DeepCollectionEquality()
                    .equals(other.deviceId, deviceId)) &&
            (identical(other.expanded, expanded) ||
                const DeepCollectionEquality()
                    .equals(other.expanded, expanded)) &&
            (identical(other.precision, precision) ||
                const DeepCollectionEquality()
                    .equals(other.precision, precision)) &&
            (identical(other.extensionData, extensionData) ||
                const DeepCollectionEquality()
                    .equals(other.extensionData, extensionData)) &&
            (identical(other.displayName, displayName) ||
                const DeepCollectionEquality()
                    .equals(other.displayName, displayName)));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(name) ^
      const DeepCollectionEquality().hash(order) ^
      const DeepCollectionEquality().hash(textStyle) ^
      const DeepCollectionEquality().hash(editInfo) ^
      const DeepCollectionEquality().hash(rowNr) ^
      const DeepCollectionEquality().hash(unitOfMeasurement) ^
      const DeepCollectionEquality().hash(format) ^
      const DeepCollectionEquality().hash(showOnlyInDeveloperMode) ^
      const DeepCollectionEquality().hash(deviceId) ^
      const DeepCollectionEquality().hash(expanded) ^
      const DeepCollectionEquality().hash(precision) ^
      const DeepCollectionEquality().hash(extensionData) ^
      const DeepCollectionEquality().hash(displayName) ^
      runtimeType.hashCode;
}

extension $LayoutBasePropertyInfoExtension on LayoutBasePropertyInfo {
  LayoutBasePropertyInfo copyWith(
      {String? name,
      int? order,
      TextSettings? textStyle,
      PropertyEditInformation? editInfo,
      int? rowNr,
      String? unitOfMeasurement,
      String? format,
      bool? showOnlyInDeveloperMode,
      int? deviceId,
      bool? expanded,
      int? precision,
      Map<String, dynamic>? extensionData,
      String? displayName}) {
    return LayoutBasePropertyInfo(
        name: name ?? this.name,
        order: order ?? this.order,
        textStyle: textStyle ?? this.textStyle,
        editInfo: editInfo ?? this.editInfo,
        rowNr: rowNr ?? this.rowNr,
        unitOfMeasurement: unitOfMeasurement ?? this.unitOfMeasurement,
        format: format ?? this.format,
        showOnlyInDeveloperMode:
            showOnlyInDeveloperMode ?? this.showOnlyInDeveloperMode,
        deviceId: deviceId ?? this.deviceId,
        expanded: expanded ?? this.expanded,
        precision: precision ?? this.precision,
        extensionData: extensionData ?? this.extensionData,
        displayName: displayName ?? this.displayName);
  }

  LayoutBasePropertyInfo copyWithWrapped(
      {Wrapped<String>? name,
      Wrapped<int>? order,
      Wrapped<TextSettings?>? textStyle,
      Wrapped<PropertyEditInformation?>? editInfo,
      Wrapped<int?>? rowNr,
      Wrapped<String>? unitOfMeasurement,
      Wrapped<String>? format,
      Wrapped<bool?>? showOnlyInDeveloperMode,
      Wrapped<int?>? deviceId,
      Wrapped<bool?>? expanded,
      Wrapped<int?>? precision,
      Wrapped<Map<String, dynamic>?>? extensionData,
      Wrapped<String>? displayName}) {
    return LayoutBasePropertyInfo(
        name: (name != null ? name.value : this.name),
        order: (order != null ? order.value : this.order),
        textStyle: (textStyle != null ? textStyle.value : this.textStyle),
        editInfo: (editInfo != null ? editInfo.value : this.editInfo),
        rowNr: (rowNr != null ? rowNr.value : this.rowNr),
        unitOfMeasurement: (unitOfMeasurement != null
            ? unitOfMeasurement.value
            : this.unitOfMeasurement),
        format: (format != null ? format.value : this.format),
        showOnlyInDeveloperMode: (showOnlyInDeveloperMode != null
            ? showOnlyInDeveloperMode.value
            : this.showOnlyInDeveloperMode),
        deviceId: (deviceId != null ? deviceId.value : this.deviceId),
        expanded: (expanded != null ? expanded.value : this.expanded),
        precision: (precision != null ? precision.value : this.precision),
        extensionData:
            (extensionData != null ? extensionData.value : this.extensionData),
        displayName:
            (displayName != null ? displayName.value : this.displayName));
  }
}
