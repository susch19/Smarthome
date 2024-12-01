import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:smarthome/controls/gradient_rounded_rect_slider_track_shape.dart';
import 'package:smarthome/devices/device_exporter.dart';
import 'package:smarthome/devices/generic/stores/value_store.dart';
import 'package:smarthome/devices/heater/heater_config.dart';
import 'package:smarthome/devices/heater/temp_scheduling.dart';
import 'package:smarthome/helper/connection_manager.dart';
import 'package:smarthome/models/message.dart';
import 'package:smarthome/restapi/swagger.swagger.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

class BasicIcon extends ConsumerWidget {
  const BasicIcon({
    super.key,
    required this.valueModel,
    required this.info,
  });
  final ValueStore? valueModel;
  final LayoutBasePropertyInfo info;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final edit = GenericDevice.getEditParameter(valueModel, info.editInfo!);
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
}

class BasicButton extends ConsumerWidget {
  const BasicButton({
    super.key,
    required this.id,
    required this.valueModel,
    required this.info,
    required this.raisedButton,
  });
  final int id;
  final ValueStore? valueModel;
  final LayoutBasePropertyInfo info;

  final bool raisedButton;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final editInfo = info.editInfo!;
    final tempSettingsDialog = editInfo.dialog == "HeaterConfig";

    if (raisedButton) {
      return ElevatedButton(
        onPressed: (() async {
          if (tempSettingsDialog) {
            pushTempSettings(context, id, info, ref);
          } else {
            await ref
                .read(hubConnectionConnectedProvider)
                ?.invoke(editInfo.hubMethod ?? "Update", args: <Object>[
              GenericDevice.getMessage(
                      editInfo, editInfo.editParameter.first, id)
                  .toJson()
            ]);
          }
        }),
        child: Text(editInfo.display!,
            style: TextStyle(
                fontWeight: valueModel?.currentValue == editInfo.activeValue
                    ? FontWeight.bold
                    : FontWeight.normal)),
      );
    }

    return MaterialButton(
      onPressed: (() async {
        if (tempSettingsDialog) {
          pushTempSettings(context, id, info, ref);
        } else {
          await ref
              .read(hubConnectionConnectedProvider)
              ?.invoke(editInfo.hubMethod ?? "Update", args: <Object>[
            GenericDevice.getMessage(editInfo, editInfo.editParameter.first, id)
                .toJson()
          ]);
        }
      }),
      child: Text(editInfo.display!,
          style: TextStyle(
              fontWeight: valueModel?.currentValue == editInfo.activeValue
                  ? FontWeight.bold
                  : FontWeight.normal)),
    );
  }

  static void pushTempSettings(final BuildContext context, final int id,
      final LayoutBasePropertyInfo e, final WidgetRef ref) async {
    final res = await Navigator.push(
        context,
        MaterialPageRoute<(bool, List<HeaterConfig>)>(
            builder: (final BuildContext context) => TempScheduling(id),
            fullscreenDialog: true));
    if (res == null || !res.$1) return;

    ref.read(apiProvider).appSmarthomePost(
            message: JsonSmarthomeMessage(
          parameters: ["store", ...res.$2.map((final f) => jsonEncode(f))],
          nodeId: id,
          longNodeId: id,
          messageType: MessageType.options,
          command: Command2.temp,
        ));
  }
}

class BasicDropdown extends ConsumerWidget {
  const BasicDropdown({
    super.key,
    required this.id,
    required this.valueModel,
    required this.info,
  });
  final int id;
  final ValueStore? valueModel;
  final LayoutBasePropertyInfo info;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final editInfo = info.editInfo!;
    return DropdownButton(
      items: editInfo.editParameter
          .map((final e) => DropdownMenuItem(
                value: e.$value,
                child: Text(e.displayName ?? e.$value.toString()),
              ))
          .toList(),
      onChanged: (final value) async {
        final edit = editInfo.editParameter
            .firstWhere((final element) => element.$value == value);
        await ref
            .read(hubConnectionConnectedProvider)
            ?.invoke(editInfo.hubMethod ?? "Update", args: <Object>[
          GenericDevice.getMessage(editInfo, edit, id).toJson()
        ]);
      },
      value: valueModel?.currentValue,
    );
  }
}

class BasicIconButton extends ConsumerWidget {
  const BasicIconButton({
    super.key,
    required this.id,
    required this.valueModel,
    required this.info,
  });

  final int id;
  final ValueStore? valueModel;
  final LayoutBasePropertyInfo info;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final editInfo = info.editInfo!;
    final edit = editInfo.editParameter.firstWhere(
        (final element) =>
            valueModel != null && element.$value == valueModel!.currentValue,
        orElse: () => editInfo.editParameter.first);
    final raw = edit.extensionData ?? {};
    final color = raw["Color"] as int?;
    if (raw["Disable"] == true) return const SizedBox();

    return IconButton(
      onPressed: (() async {
        await ref
            .read(hubConnectionConnectedProvider)
            ?.invoke(editInfo.hubMethod ?? "Update", args: <Object>[
          GenericDevice.getMessage(editInfo, edit, id).toJson()
        ]);
      }),
      icon: Icon(
        IconData(raw["CodePoint"] as int,
            fontFamily: raw["FontFamily"] ?? 'MaterialIcons'),
        color: color == null ? null : Color(color),
        size: raw["Size"],
      ),
    );
  }
}

class BasicToggle extends ConsumerWidget {
  const BasicToggle(
      {super.key,
      required this.id,
      required this.valueModel,
      required this.info});

  final int id;
  final ValueStore? valueModel;
  final LayoutBasePropertyInfo info;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final editInfo = info.editInfo!;
    final edit = editInfo.editParameter.firstWhere(
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
                ?.invoke(editInfo.hubMethod ?? "Update", args: <Object>[
              GenericDevice.getMessage(editInfo, edit, id).toJson()
            ]);
          }),
          value: valueModel?.currentValue == editInfo.activeValue,
        ),
      ],
    );
  }
}

class BasicSlider extends HookConsumerWidget {
  const BasicSlider({
    super.key,
    required this.id,
    required this.valueModel,
    required this.info,
  });

  final int id;
  final ValueStore? valueModel;
  final LayoutBasePropertyInfo info;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sliderValue = useState(0.0);
    final editInfo = this.info.editInfo!;
    final edit = editInfo.editParameter.first;
    final json = edit.$value;
    final valueModel = this.valueModel;
    if (json is! Map<String, dynamic>) return const SizedBox();
    var sliderTheme = SliderTheme.of(context);
    if (editInfo.extensionData?.containsKey("GradientColors") ?? false) {
      final gradients =
          editInfo.extensionData!["GradientColors"] as List<dynamic>;
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
      return SliderTheme(
        data: sliderTheme,
        child: Slider(
          min: json["Min"] as double,
          max: json["Max"] as double,
          divisions: json["Divisions"],
          onChanged: (final value) {
            sliderValue.value = value;
          },
          onChangeEnd: (final value) async {
            final message = Message(edit.id ?? id,
                edit.messageType ?? editInfo.editCommand, edit.command, [
              customLabels[value.round()].values.first,
              ...?edit.parameters
            ]);
            await ref.read(hubConnectionConnectedProvider)?.invoke(
                editInfo.hubMethod ?? "Update",
                args: <Object>[message.toJson()]);
          },
          value: sliderValue.value,
          label: customLabels[sliderValue.value.round()].keys.first,
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
              edit.messageType ?? editInfo.editCommand,
              edit.command,
              [value, ...?edit.parameters]);
          await ref.read(hubConnectionConnectedProvider)?.invoke(
              editInfo.hubMethod ?? "Update",
              args: <Object>[message.toJson()]);
        },
        value: sliderVal,
        label: editInfo.display ??
            valueModel?.getValueAsString(precision: info.precision ?? 1) ??
            "",
      ),
    );
  }
}
