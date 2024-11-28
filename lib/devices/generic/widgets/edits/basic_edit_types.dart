import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:smarthome/controls/gradient_rounded_rect_slider_track_shape.dart';
import 'package:smarthome/devices/device_exporter.dart';
import 'package:smarthome/devices/generic/stores/value_store.dart';
import 'package:smarthome/devices/generic_device.dart';
import 'package:smarthome/devices/heater/heater_config.dart';
import 'package:smarthome/devices/heater/temp_scheduling.dart';
import 'package:smarthome/helper/connection_manager.dart';
import 'package:smarthome/models/message.dart';
import 'package:smarthome/restapi/swagger.swagger.dart';
import 'package:tuple/tuple.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BasicEditTypes {
  static Widget buildButton(
      final int id,
      final BuildContext context,
      final ValueStore? valueModel,
      final LayoutBasePropertyInfo e,
      final WidgetRef ref,
      final bool raisedButton) {
    final info = e.editInfo!;
    final tempSettingsDialog = info.dialog == "HeaterConfig";

    if (raisedButton) {
      return ElevatedButton(
        onPressed: (() async {
          if (tempSettingsDialog) {
            pushTempSettings(context, id, e, ref);
          } else {
            await ref
                .read(hubConnectionConnectedProvider)
                ?.invoke(info.hubMethod ?? "Update", args: <Object>[
              GenericDevice.getMessage(info, info.editParameter.first, id)
                  .toJson()
            ]);
          }
        }),
        child: Text(info.display!,
            style: TextStyle(
                fontWeight: valueModel?.currentValue == info.activeValue
                    ? FontWeight.bold
                    : FontWeight.normal)),
      );
    }

    return MaterialButton(
      onPressed: (() async {
        if (tempSettingsDialog) {
          pushTempSettings(context, id, e, ref);
        } else {
          await ref
              .read(hubConnectionConnectedProvider)
              ?.invoke(info.hubMethod ?? "Update", args: <Object>[
            GenericDevice.getMessage(info, info.editParameter.first, id)
                .toJson()
          ]);
        }
      }),
      child: Text(info.display!,
          style: TextStyle(
              fontWeight: valueModel?.currentValue == info.activeValue
                  ? FontWeight.bold
                  : FontWeight.normal)),
    );
  }

  static Widget icon(final ValueStore? valueModel,
      final LayoutBasePropertyInfo e, final WidgetRef ref) {
    final edit = GenericDevice.getEditParameter(valueModel, e.editInfo!);
    final raw = edit.extensionData ?? {};
    final color = raw["Color"] as int?;
    if (raw["Disable"] == true) return const SizedBox();
    return Icon(
      IconData(raw["CodePoint"] as int,
          fontFamily: raw["FontFamily"] ?? 'MaterialIcons'),
      color: color == null ? null : Color(color),
      size: raw["Size"],
    );
  }

  static Widget iconButton(final int id, final ValueStore? valueModel,
      final LayoutBasePropertyInfo e, final WidgetRef ref) {
    final info = e.editInfo!;
    final edit = info.editParameter.firstWhere(
        (final element) =>
            valueModel != null && element.$value == valueModel.currentValue,
        orElse: () => info.editParameter.first);
    final raw = edit.extensionData ?? {};
    final color = raw["Color"] as int?;
    if (raw["Disable"] == true) return const SizedBox();

    return IconButton(
      onPressed: (() async {
        await ref.read(hubConnectionConnectedProvider)?.invoke(
            info.hubMethod ?? "Update",
            args: <Object>[GenericDevice.getMessage(info, edit, id).toJson()]);
      }),
      icon: Icon(
        IconData(raw["CodePoint"] as int,
            fontFamily: raw["FontFamily"] ?? 'MaterialIcons'),
        color: color == null ? null : Color(color),
        size: raw["Size"],
      ),
    );
  }

  static Widget buildToggle(final int id, final ValueStore? valueModel,
      final LayoutBasePropertyInfo e, final WidgetRef ref) {
    final info = e.editInfo!;
    final edit = info.editParameter.firstWhere(
        (final element) => element.$value != valueModel?.currentValue);
    if (edit.extensionData?["Disable"] == true) return const SizedBox();

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (edit.displayName != null) Text(edit.displayName!),
        Switch(
          onChanged: ((final _) async {
            await ref
                .read(hubConnectionConnectedProvider)
                ?.invoke(info.hubMethod ?? "Update", args: <Object>[
              GenericDevice.getMessage(info, edit, id).toJson()
            ]);
          }),
          value: valueModel?.currentValue == info.activeValue,
        ),
      ],
    );
  }

  static Widget buildDropdown(final int id, final ValueStore? valueModel,
      final LayoutBasePropertyInfo e, final WidgetRef ref) {
    final info = e.editInfo!;
    return DropdownButton(
      items: info.editParameter
          .map((final e) => DropdownMenuItem(
                value: e.$value,
                child: Text(e.displayName ?? e.$value.toString()),
              ))
          .toList(),
      onChanged: (final value) async {
        final edit = info.editParameter
            .firstWhere((final element) => element.$value == value);
        await ref.read(hubConnectionConnectedProvider)?.invoke(
            info.hubMethod ?? "Update",
            args: <Object>[GenericDevice.getMessage(info, edit, id).toJson()]);
      },
      value: valueModel?.currentValue,
    );
  }

  static void pushTempSettings(final BuildContext context, final int id,
      final LayoutBasePropertyInfo e, final WidgetRef ref) async {
    final res = await Navigator.push(
        context,
        MaterialPageRoute<Tuple2<bool, List<HeaterConfig>>>(
            builder: (final BuildContext context) => TempScheduling(id),
            fullscreenDialog: true));
    if (res == null || !res.item1) return;
    final info = e.editInfo!;
    final message = Message(id, MessageType.options, Command.temp,
        ["store", ...res.item2.map((final f) => jsonEncode(f)).toList()]);
    ref
        .read(hubConnectionConnectedProvider)
        ?.invoke(info.hubMethod ?? "Update", args: [message.toJson()]);
  }

  static final _sliderValueProvider =
      StateProvider.family<double, Tuple2<String, int>>((final _, final __) {
    return 0.0;
  });
  static Widget buildSlider(
      final BuildContext context,
      final int id,
      final ValueStore? valueModel,
      final LayoutBasePropertyInfo e,
      final WidgetRef ref) {
    final info = e.editInfo!;
    final edit = info.editParameter.first;
    final json = edit.$value;
    if (json is! Map<String, dynamic>) return const SizedBox();
    var sliderTheme = SliderTheme.of(context);
    if (info.extensionData?.containsKey("GradientColors") ?? false) {
      final gradients = info.extensionData!["GradientColors"] as List<dynamic>;
      final List<Color> colors = [];
      for (final grad in gradients) {
        if (grad is int) {
          colors.add(Color(grad));
        } else if (grad is List<dynamic>) {
          colors.add(Color.fromARGB(grad[0], grad[1], grad[2], grad[3]));
        }
      }
      sliderTheme = sliderTheme.copyWith(
        trackShape:
            GradientRoundedRectSliderTrackShape(LinearGradient(colors: colors)),
      );
    }

    if (json.containsKey("Divisions") && json.containsKey("Values")) {
      final customLabels = (json["Values"]);
      final currentValue = ref.watch(_sliderValueProvider(Tuple2(e.name, id)));
      return SliderTheme(
        data: sliderTheme,
        child: Slider(
          min: json["Min"] as double,
          max: json["Max"] as double,
          divisions: json["Divisions"],
          onChanged: (final value) {
            ref.read(_sliderValueProvider(Tuple2(e.name, id)).notifier).state =
                value;
          },
          onChangeEnd: (final value) async {
            final message = Message(edit.id ?? id,
                edit.messageType ?? info.editCommand, edit.command, [
              customLabels[value.round()].values.first,
              ...?edit.parameters
            ]);
            await ref.read(hubConnectionConnectedProvider)?.invoke(
                info.hubMethod ?? "Update",
                args: <Object>[message.toJson()]);
          },
          value: currentValue,
          label: customLabels[currentValue.round()].keys.first,
        ),
      );
    }
    final double sliderVal;
    if (valueModel == null) {
      sliderVal = 0.0;
    } else {
      sliderVal = valueModel.currentValue is double
          ? valueModel.currentValue
          : valueModel.currentValue.toDouble();
    }
    return SliderTheme(
      data: sliderTheme,
      child: Slider(
        min: json["Min"] as double? ?? 0.0,
        max: json["Max"] as double? ?? 1.0,
        divisions: json["Divisions"] as int?,
        onChanged: (final value) {
          if (valueModel == null) return;
          if (valueModel.currentValue is double) {
            valueModel.setValue(value);
          } else if (valueModel.currentValue is int) {
            valueModel.setValue(value.toInt());
          }
        },
        onChangeEnd: (final value) async {
          final message = Message(
              edit.id ?? id,
              edit.messageType ?? info.editCommand,
              edit.command,
              [value, ...?edit.parameters]);
          await ref.read(hubConnectionConnectedProvider)?.invoke(
              info.hubMethod ?? "Update",
              args: <Object>[message.toJson()]);
        },
        value: sliderVal,
        label: info.display ??
            valueModel?.getValueAsString(precision: e.precision ?? 1) ??
            "",
      ),
    );
  }
}
