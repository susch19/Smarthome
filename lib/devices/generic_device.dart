
import 'package:flutter/material.dart';
import 'package:smarthome/devices/device_exporter.dart';
import 'package:smarthome/devices/device_manager.dart';
import 'package:smarthome/devices/generic/device_layout_service.dart';
import 'package:smarthome/devices/generic/generic_device_exporter.dart';
import 'package:smarthome/devices/generic/stores/value_store.dart';
import 'package:smarthome/devices/generic/widgets/edits/advanced_slider.dart';
import 'package:smarthome/devices/generic/widgets/edits/basic_edit_types.dart';
import 'package:smarthome/devices/generic/widgets/edits/gauge_edit.dart';
import 'package:smarthome/devices/generic_device_screen.dart';
import 'package:smarthome/helper/iterable_extensions.dart';
import 'package:smarthome/helper/notification_service.dart';
import 'package:smarthome/models/message.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class GenericDevice extends Device<BaseModel> {
  GenericDevice(super.id, super.typeName);

  @override
  DeviceTypes getDeviceType() {
    return DeviceTypes.Generic;
  }

  @override
  void navigateToDevice(final BuildContext context) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (final BuildContext context) =>
                GenericDeviceScreen(this)));
  }

  @override
  Widget dashboardCardBody() {
    return Consumer(
      builder: (final context, final ref, final child) {
        final baseModel = ref.watch(BaseModel.byIdProvider(id));
        if (baseModel == null) return const SizedBox();
        final dashboardDeviceLayout = ref.watch(
            dashboardNoSpecialTypeLayoutProvider(id, baseModel.typeName));
        if (dashboardDeviceLayout?.isEmpty ?? true) return const SizedBox();

        return DashboardLayoutWidget(this, dashboardDeviceLayout!);
      },
    );
  }

  @override
  Widget getRightWidgets() {
    return Consumer(
      builder: (final context, final ref, final child) {
        final baseModel = ref.watch(BaseModel.byIdProvider(id));

        if (baseModel == null) return const SizedBox();

        final properties = ref
            .watch(dashboardSpecialTypeLayoutProvider(id, baseModel.typeName));
        if (properties?.isEmpty ?? true) return const SizedBox();

        properties!.sort((final a, final b) => a.order.compareTo(b.order));

        return Column(
          children: properties
              .map((final e) => DashboardRightValueStoreWidget(e, this))
              .toList(),
        );
      },
    );
  }

  @override
  Future iconPressed(final BuildContext context, final WidgetRef ref) async {
    final baseModel = ref.watch(BaseModel.byIdProvider(id));
    if (baseModel == null) return;
    final layout =
        ref.read(deviceLayoutsProvider.notifier).getLayout(id, typeName);
    if (layout == null) return;
    final notifications = layout.notificationSetup?.where((final x) =>
        !x.global &&
        (x.deviceIds == null ||
            x.deviceIds!.isEmpty ||
            x.deviceIds!.contains(id)));
    if (notifications == null) return;
    ref.read(notificationServiceProvider.notifier).showNotificationDialog(
        context,
        notifications.map((final x) => (baseModel.friendlyName, id, x)).toList());
  }

  Widget getEditWidget(
          final LayoutBasePropertyInfo e, final ValueStore valueModel) =>
      GenericDevice.getEditWidgetFor(id, e, valueModel);

  static Widget getEditWidgetFor(final int id, final LayoutBasePropertyInfo e,
      final ValueStore valueModel) {
    switch (e.editInfo?.editType.toLowerCase()) {
      case "button":
      case "raisedbutton":
        return BasicButton(
            id: id,
            valueModel: valueModel,
            info: e,
            raisedButton: e.editInfo!.editType.toLowerCase() == "raisedbutton");
      // case "buttionwithicon":
      //   return ButtonWithIcon(
      //       id: id,
      //       valueModel: valueModel,
      //       info: e,
      //       raisedButton: e.editInfo!.editType.toLowerCase() == "raisedbutton");
      case "toggle":
        return BasicToggle(id: id, valueModel: valueModel, info: e);
      case "dropdown":
        return BasicDropdown(id: id, valueModel: valueModel, info: e);
      case "slider":
        return BasicSlider(id: id, valueModel: valueModel, info: e);
      case "advancedslider":
        return AdvancedSlider(id, valueModel, info: e);
      case "iconbutton":
        return BasicIconButton(id: id, valueModel: valueModel, info: e);
      case "icon":
        return BasicIcon(info: e);
      case "radial":
        return GaugeEdit(id: id, valueModel: valueModel, info: e);
      // case EditType.input:
      //   return _buildInput(valueModel, e, ref);
      //https://github.com/mchome/flutter_colorpicker
      //FAB
      case "floatingactionbutton":
        return const SizedBox();
      default:
        //BasicIcon(info: e)

        return Text(
          (valueModel.getValueAsString(
                  format: e.format,
                  precision: e.precision ?? 1,
                  asHex: e.extensionData?["Hex"] ?? false)) +
              (e.unitOfMeasurement),
          style: toTextStyle(e.textStyle),
          maxLines: 100,
          softWrap: true,
          overflow: TextOverflow.clip,
        );
    }
  }

  static TextStyle toTextStyle(final TextSettings? setting) {
    var ts = const TextStyle();
    if (setting == null) return ts;
    if (setting.fontSize != null) ts = ts.copyWith(fontSize: setting.fontSize);
    if (setting.fontFamily != "") {
      ts = ts.copyWith(fontFamily: setting.fontFamily);
    }
    ts = ts.copyWith(fontStyle: FontStyle.values[setting.fontStyle.index - 1]);
    ts = ts.copyWith(
        fontWeight: setting.fontWeight == FontWeightSetting.bold
            ? FontWeight.bold
            : FontWeight.normal);
    return ts;
  }

  static Message getMessage(final PropertyEditInformation info,
      final EditParameter edit, final int id) {
    return Message(edit.id ?? id, edit.messageType ?? info.messageType,
        edit.command, edit.parameters);
  }

  static EditParameter? getEditParameter(final ValueStore<dynamic>? valueModel,
      final PropertyEditInformation info, final String name) {
    if (valueModel == null) {
      return info.editParameter
          .firstOrDefault((final x) => x.extensionData?['Name'] == name);
    }
    if (valueModel.currentValue is num) {
      final val = (valueModel.currentValue as num);
      return info.editParameter.firstOrDefault((final element) {
        if (element.extensionData?['Name'] != name) return false;
        final lower = element.extensionData?["Min"] as num?;
        final upper = element.extensionData?["Max"] as num?;
        if (lower != null && upper != null) {
          return val >= lower && val < upper;
        }
        return element.$value == val;
      });
    } else if (valueModel.currentValue is bool) {
      final val = (valueModel.currentValue as bool);
      return info.editParameter.firstOrDefault((final element) {
        if (element.extensionData?['Name'] != name) return false;
        return element.$value == val;
      });
    } else if (valueModel.currentValue is String) {
      final val = (valueModel.currentValue as String);
      return info.editParameter.firstOrDefault((final element) {
        if (element.extensionData?['Name'] != name) return false;
        return element.$value == val;
      });
    } else {
      return info.editParameter
          .firstOrDefault((final x) => x.extensionData?['Name'] == name);
    }
  }
}
