import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:smarthome/controls/controls_exporter.dart';
import 'package:smarthome/helper/connection_manager.dart';
import 'package:smarthome/helper/iterable_extensions.dart';
import 'package:smarthome/helper/theme_manager.dart';
import 'package:tuple/tuple.dart';

import 'heater_config.dart';
import 'heater_temp_settings.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum DismissDialogAction {
  cancel,
  discard,
  save,
}

final heaterConfigProvider = StateProvider.family<List<HeaterConfig>, int>((final ref, final id) {
  return [];
});

final _groupedHeaterConfigProvider =
    FutureProvider.family<Map<Tuple2<TimeOfDay?, double?>, List<HeaterConfig>>, int>((final ref, final id) async {
  final configs = ref.watch(heaterConfigProvider(id));

  if (configs.isEmpty) {
    final connection = ref.watch(hubConnectionConnectedProvider);

    final dc = await connection?.invoke("GetConfig", args: [id]);
    if (dc is! String) return {};
    if (dc != "[]") {
      final notifier = ref.read(heaterConfigProvider(id).notifier);
      notifier.state = List<HeaterConfig>.from(jsonDecode(dc).map((final f) => HeaterConfig.fromJson(f)));
    }
    return {};
  }
  configs.sort((final x, final y) => x.compareTo(y));
  return configs.groupBy((final x) => Tuple2(x.timeOfDay, x.temperature));
});

const List<HeaterConfig> emptyConfigs = [];

class TempScheduling extends ConsumerStatefulWidget {
  final int id;
  const TempScheduling(this.id, {final Key? key}) : super(key: key);

  @override
  TempSchedulingState createState() => TempSchedulingState();
}

// ignore: constant_identifier_names
enum Action { Add, Delete, TempChanged, TimeChanged, WeekdayChanged }

class HistoryAction<T> {
  Action action;
  HeaterConfig heaterConfig;
  T prevValue;
  HistoryAction(this.action, this.heaterConfig, this.prevValue);
}

class TempSchedulingState extends ConsumerState<TempScheduling> {
  TempSchedulingState();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool _saveNeeded = false;
  // late List<HistoryAction> actions;

  Future<bool> _onWillPop() async {
    if (!_saveNeeded) return true;

    final ThemeData theme = Theme.of(context);
    final TextStyle dialogTextStyle = theme.textTheme.subtitle1!.copyWith(color: theme.textTheme.caption!.color);

    return await (showDialog<bool>(
            context: context,
            builder: (final BuildContext context) => AlertDialog(
                    content: Text(
                        "Es wurden Änderungen an den Temperatur-Einstellungen vorgenommen.\r\nSollen diese verworfen werde?",
                        style: dialogTextStyle),
                    actions: <Widget>[
                      TextButton(
                          child: const Text("Abbrechen"),
                          onPressed: () {
                            Navigator.of(context).pop(false);
                          }),
                      TextButton(
                          child: const Text("Verwerfen"),
                          onPressed: () {
                            Navigator.of(context).pop(true);
                          })
                    ]))) ??
        false;
  }

  void showInSnackBar(final String value) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(value)));
  }

  Future<bool> _handleSubmitted() async {
    final FormState form = _formKey.currentState!;
    if (!form.validate()) {
      return false;
    } else {
      form.save();
      final configs = ref.read(heaterConfigProvider(widget.id));
      if (!_saveNeeded) {
        Navigator.of(context).pop(Tuple2(false, configs));
        return true;
      }

      Navigator.of(context).pop(Tuple2(true, configs));
    }
    return true;
  }

  @override
  Widget build(final BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
          title: const Text("Temperatur Einstellungen"),
          actions: <Widget>[IconButton(icon: const Icon(Icons.save), onPressed: () => _handleSubmitted())]),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () async {
          final res = await Navigator.push(
              context,
              MaterialPageRoute<Tuple2<bool, List<HeaterConfig>>>(
                  builder: (final BuildContext context) => HeaterTempSettings(Tuple2(TimeOfDay.now(), 21.0), const []),
                  fullscreenDialog: true));
          storeNewTempConfigs(res, []);
        },
      ),
      body: Container(
        decoration: ThemeManager.getBackgroundDecoration(context),
        child: Form(
          key: _formKey,
          onWillPop: _onWillPop,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: Consumer(
            builder: (final context, final ref, final child) {
              final hConfig = ref.watch(_groupedHeaterConfigProvider(widget.id));
              return hConfig.when(
                data: (final data) {
                  return ListView(
                      padding: const EdgeInsets.all(16.0),
                      children: data.entries.map((final x) => newHeaterConfigToWidget(x.key, x.value)).toList());
                },
                error: (final error, final stackTrace) => ListView(padding: const EdgeInsets.all(16.0)),
                loading: () => Container(
                  margin: const EdgeInsets.only(top: 25),
                  child: const CircularProgressIndicator(),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget newHeaterConfigToWidget(final Tuple2<TimeOfDay?, double?> x, final List<HeaterConfig> value) {
    return Container(
      padding: const EdgeInsets.only(top: 8.0),
      child: BlurryCard(
        child: GestureDetector(
          child: MaterialButton(
            onPressed: () async {
              final res = await Navigator.push(
                  context,
                  MaterialPageRoute<Tuple2<bool, List<HeaterConfig>>>(
                      builder: (final BuildContext context) => HeaterTempSettings(x, value), fullscreenDialog: true));
              storeNewTempConfigs(res, value);
            },
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Wrap(
                        children: value.map((final x) => dayOfWeekChip(x.dayOfWeek)).toList(growable: false),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () {
                        final heaterConfigsNotifier = ref.read(heaterConfigProvider(widget.id).notifier);
                        final heaterConfigs = heaterConfigsNotifier.state.toList();
                        heaterConfigs.removeElements(value);
                        heaterConfigsNotifier.state = heaterConfigs;
                        _saveNeeded = true;
                      },
                    ),
                  ],
                ),
                Container(
                  margin: const EdgeInsetsDirectional.only(bottom: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        x.item1!.format(context),
                        style: const TextStyle(fontSize: 18),
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 8.0),
                      ),
                      Text(
                        x.item2!.toStringAsFixed(1) + "°C",
                        style: const TextStyle(fontSize: 18),
                      ),
                    ],
                  ),
                ),
              ],
              // crossAxisAlignment: CrossAxisAlignment.start,
            ),
          ),
        ),
      ),
    );
  }

  Widget dayOfWeekChip(final DayOfWeek dOW) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 4.0),
      child: Chip(
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 4.0),
        label: Text(dayOfWeekToStringMap[dOW]!),
      ),
    );
  }

  // final List<String> weekdayListText = ["Mo", "Di", "Mi", "Do", "Fr", "Sa", "So"];
  // final List<DropdownMenuItem> itemsForDropdown = buildItems();
  // Widget heaterConfigToWidget(HeaterConfig conf) {
  //   // double width = MediaQuery.of(context).size.width;
  //   // var val = null;
  //   return Dismissible(
  //     key: ValueKey(conf),
  //     child: ListTile(
  //       title: Row(
  //         children: <Widget>[
  //           DropdownButton(
  //             value: conf.dayOfWeek!.index,
  //             onChanged: (dynamic newValue) {
  //               setState(() {
  //                 actions.add(HistoryAction<DayOfWeek?>(Action.WeekdayChanged, conf, conf.dayOfWeek));
  //                 conf.dayOfWeek = DayOfWeek.values[newValue];
  //               });
  //             },
  //             items: DayOfWeek.values.map((val) {
  //               return DropdownMenuItem(
  //                 child: new Text(weekdayListText[val.index]),
  //                 value: val.index,
  //               );
  //             }).toList(),
  //           ),
  //           TextButton(
  //             child: Text(
  //               "${conf.timeOfDay!.hour}:${conf.timeOfDay!.minute}",
  //             ),
  //             onPressed: () async {
  //               var tod = await showTimePicker(context: context, initialTime: conf.timeOfDay!);
  //               if (tod == null) return;
  //               actions.add(HistoryAction<TimeOfDay?>(Action.TimeChanged, conf, conf.timeOfDay));
  //               conf.timeOfDay = tod;
  //               setState(() {});
  //             },
  //           ),

  //           DropdownButton(
  //               items: itemsForDropdown,
  //               onChanged: (dynamic s) => setState(() {
  //                     conf.temperature = (s / 10.0);
  //                   }),
  //               value: (conf.temperature! * 10).round()), // ,)

  //           IconButton(
  //             icon: Icon(Icons.content_copy),
  //             onPressed: () {
  //               var hc = new HeaterConfig();
  //               hc.dayOfWeek = conf.dayOfWeek;
  //               hc.temperature = conf.temperature;
  //               hc.timeOfDay = conf.timeOfDay;
  //               addHeaterConfig(hc);
  //             },
  //           )
  //           //  WheelChooser.integer(onValueChanged: (d){}, minValue: 5, maxValue: 35, step: 1, horizontal: true,)
  //           //  WheelChooser.double(onValueChanged: (d){}, minValue: 5.0, maxValue: 35.0, step: 0.1, horizontal: true,)
  //         ],
  //       ),
  //     ),
  //     confirmDismiss: (dir) async {
  //       var index = heaterConfigs!.indexOf(conf);
  //       var ha = HistoryAction<Future<bool> Function(int, HistoryAction)>(Action.Delete, conf, (i, ha) async {
  //         HistoryAction? before;
  //         if (actions.length > 1) before = actions.elementAt(actions.length - 2);
  //         while (true) {
  //           if (actions.last == ha && actions.last.action == Action.Delete) {
  //             await Future.delayed(Duration(milliseconds: 16));
  //           } else if (before != null && actions.last == before) {
  //             return false;
  //           } else if (before == null && actions.length > 1) {
  //             actions.remove(ha);
  //             return true;
  //           } else if (before == null && actions.length < 1) {
  //             return false;
  //           } else {
  //             return true;
  //           }
  //         }
  //       });
  //       actions.add(ha);
  //       return await ha.prevValue(index, ha);
  //     },
  //     onDismissed: (DismissDirection d) {
  //       heaterConfigs!.remove(conf);
  //     },
  //     direction: DismissDirection.horizontal,
  //     background: Container(
  //       decoration: BoxDecoration(color: Theme.of(context).primaryColor),
  //       child: ListTile(
  //         leading: Icon(Icons.delete, color: Theme.of(context).accentIconTheme.color, size: 36.0),
  //       ),
  //     ),
  //   );
  // }

  static List<DropdownMenuItem> buildItems() {
    final menuItems = <DropdownMenuItem>[];
    for (double d = 5.0; d <= 35.0; d += 0.1) {
      menuItems.add(DropdownMenuItem(child: Text(d.toStringAsFixed(1)), value: (d * 10).round()));
    }
    return menuItems;
  }

  void storeNewTempConfigs(final Tuple2<bool, List<HeaterConfig>>? res, final List<HeaterConfig> value) {
    if (res == null || res.item1 == false) return;
    final heaterConfigsNotifier = ref.read(heaterConfigProvider(widget.id).notifier);
    final heaterConfigs = heaterConfigsNotifier.state.toList();
    heaterConfigs.removeElements(value);

    for (final element in res.item2) {
      final hc = heaterConfigs
          .firstOrNull((final x) => x.dayOfWeek.index == element.dayOfWeek.index && x.timeOfDay == element.timeOfDay);
      if (hc != null) heaterConfigs.remove(hc);
      heaterConfigs.add(element);
    }
    _saveNeeded = true;
    heaterConfigsNotifier.state = heaterConfigs;
  }

  // void addHeaterConfig(HeaterConfig hc) {
  //   heaterConfigs!.add(hc);
  //   actions.add(HistoryAction<bool>(Action.Add, hc, false));
  //   setState(() {});
  // }
}
