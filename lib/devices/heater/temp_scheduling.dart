import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:smarthome/controls/controls_exporter.dart';
import 'package:smarthome/helper/iterable_extensions.dart';
import 'package:smarthome/helper/theme_manager.dart';

import 'heater_config.dart';
import 'heater_temp_settings.dart';

enum DismissDialogAction {
  cancel,
  discard,
  save,
}

class TempScheduling extends StatefulWidget {
  final List<HeaterConfig> heaterConfigs;

  TempScheduling(this.heaterConfigs);

  @override
  TempSchedulingState createState() => new TempSchedulingState(heaterConfigs);
}

enum Action { Add, Delete, TempChanged, TimeChanged, WeekdayChanged }

class HistoryAction<T> {
  Action action;
  HeaterConfig heaterConfig;
  T prevValue;
  HistoryAction(this.action, this.heaterConfig, this.prevValue);
}

class TempSchedulingState extends State<TempScheduling> {
  TempSchedulingState(this.heaterConfigs);
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();

  bool _saveNeeded = false;
  late Map<Tuple<TimeOfDay?, double?>, List<HeaterConfig>> hConfig;
  List<HeaterConfig> heaterConfigs;
  // late List<HistoryAction> actions;
  @override
  void initState() {
    super.initState();
    heaterConfigs = widget.heaterConfigs;
    // actions = <HistoryAction>[];

    sortAndGroupHeaterConfigs();
  }

  void sortAndGroupHeaterConfigs() {
    heaterConfigs.sort((x, y) => x.compareTo(y));
    hConfig =
        heaterConfigs.groupBy((x) => new Tuple(x.timeOfDay, x.temperature));
  }

  Future<bool> _onWillPop() async {
    if (!_saveNeeded) return true;

    final ThemeData theme = Theme.of(context);
    final TextStyle dialogTextStyle = theme.textTheme.subtitle1!
        .copyWith(color: theme.textTheme.caption!.color);

    return await (showDialog<bool>(
            context: context,
            builder: (BuildContext context) => new AlertDialog(
                    content: Text(
                        "Es wurden Änderungen an den Temperatur-Einstellungen vorgenommen.\r\nSollen diese verworfen werde?",
                        style: dialogTextStyle),
                    actions: <Widget>[
                      TextButton(
                          child: Text("Abbrechen"),
                          onPressed: () {
                            Navigator.of(context).pop(false);
                          }),
                      TextButton(
                          child: Text("Verwerfen"),
                          onPressed: () {
                            Navigator.of(context).pop(true);
                          })
                    ]))) ??
        false;
  }

  void showInSnackBar(String value) {
    ScaffoldMessenger.of(context)
        .showSnackBar(new SnackBar(content: new Text(value)));
  }

  Future<bool> _handleSubmitted() async {
    final FormState form = _formKey.currentState!;
    if (!form.validate()) {
      return false;
    } else {
      form.save();
      if (!_saveNeeded) {
        Navigator.of(context).pop(Tuple(false, heaterConfigs));
        return true;
      }

      //double realWeight = recursiveParsing(weight);
      Navigator.of(context).pop(Tuple(true, heaterConfigs));
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      key: _scaffoldKey,
      appBar: new AppBar(
          title: new Text("Temperatur Einstellungen"),
          actions: <Widget>[
            new IconButton(
                icon: Icon(Icons.save), onPressed: () => _handleSubmitted())
          ]),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () async {
          var res = await Navigator.push(
              context,
              new MaterialPageRoute<Tuple<bool, List<HeaterConfig>>>(
                  builder: (BuildContext context) =>
                      HeaterTempSettings(Tuple(TimeOfDay.now(), 21.0), []),
                  fullscreenDialog: true));
          storeNewTempConfigs(res, []);
        },
      ),
      body: Container(
        decoration: ThemeManager.getBackgroundDecoration(context),
        child: new Form(
            key: _formKey,
            onWillPop: _onWillPop,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: new ListView(
                padding: const EdgeInsets.all(16.0),
                children: hConfig.entries
                    .map((x) => newHeaterConfigToWidget(x.key, x.value))
                    .toList())),
      ),
    );
  }

  Widget newHeaterConfigToWidget(
      Tuple<TimeOfDay?, double?> x, List<HeaterConfig> value) {
    return Container(
      padding: EdgeInsets.only(top: 8.0),
      child: BlurryCard(
        child: GestureDetector(
          child: MaterialButton(
            onPressed: () async {
              var res = await Navigator.push(
                  context,
                  new MaterialPageRoute<Tuple<bool, List<HeaterConfig>>>(
                      builder: (BuildContext context) =>
                          HeaterTempSettings(x, value),
                      fullscreenDialog: true));
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
                        children: value
                            .map((x) => dayOfWeekChip(x.dayOfWeek))
                            .toList(growable: false),
                      ),
                    ),
                    Container(
                      child: IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () {
                          heaterConfigs.removeElements(value);
                          _saveNeeded = true;
                          sortAndGroupHeaterConfigs();
                          setState(() {});
                        },
                      ),
                    ),
                  ],
                ),
                Container(
                  margin: EdgeInsetsDirectional.only(bottom: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        x.item1!.format(context),
                        style: TextStyle(fontSize: 18),
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 8.0),
                      ),
                      Text(
                        x.item2!.toStringAsFixed(1) + "°C",
                        style: TextStyle(fontSize: 18),
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

  Widget dayOfWeekChip(DayOfWeek dOW) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.0, vertical: 4.0),
      child: Chip(
        padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 4.0),
        label: Text(DayOfWeekToStringMap[dOW]!),
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
    var menuItems = <DropdownMenuItem>[];
    for (double d = 5.0; d <= 35.0; d += 0.1) {
      menuItems.add(DropdownMenuItem(
          child: Text(d.toStringAsFixed(1)), value: (d * 10).round()));
    }
    return menuItems;
  }

  void storeNewTempConfigs(
      Tuple<bool, List<HeaterConfig>>? res, List<HeaterConfig> value) {
    if (res == null || res.item1 == false) return;
    heaterConfigs.removeElements(value);

    res.item2.forEach((element) {
      var hc = heaterConfigs.firstOrNull((x) =>
          x.dayOfWeek.index == element.dayOfWeek.index &&
          x.timeOfDay == element.timeOfDay);
      if (hc != null) heaterConfigs.remove(hc);
      heaterConfigs.add(element);
    });
    _saveNeeded = true;
    sortAndGroupHeaterConfigs();
    setState(() {});
  }

  // void addHeaterConfig(HeaterConfig hc) {
  //   heaterConfigs!.add(hc);
  //   actions.add(HistoryAction<bool>(Action.Add, hc, false));
  //   setState(() {});
  // }
}

class Tuple<T1, T2> extends Equatable {
  final T1 item1;
  final T2 item2;

  Tuple(this.item1, this.item2);

  @override
  List<Object?> get props => [item1, item2];
}
