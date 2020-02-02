import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:smarthome/controls/double_wheel.dart';

import 'heater_config.dart';

enum DismissDialogAction {
  cancel,
  discard,
  save,
}

class TempScheduling extends StatefulWidget {
  List<HeaterConfig> heaterConf = List<HeaterConfig>();

  TempScheduling({this.heaterConf});

  @override
  TempSchedulingState createState() => new TempSchedulingState();
}

enum Action { Add, Delete, TempChanged, TimeChanged, WeekdayChanged }

class HistoryAction<T> {
  Action action;
  HeaterConfig heaterConfig;
  T prevValue;
  HistoryAction(this.action, this.heaterConfig, this.prevValue);
}

class TempSchedulingState extends State<TempScheduling> {
  TempSchedulingState();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();

  bool _autovalidate = false;
  bool _saveNeeded = false;
  List<HeaterConfig> heaterConfigs;
  List<HistoryAction> actions;
  @override
  void initState() {
    super.initState();
    if (widget.heaterConf != null)
      heaterConfigs = widget.heaterConf;
    else
      heaterConfigs = List<HeaterConfig>();
    actions = List<HistoryAction>();
  }

  Future<bool> _onWillPop() async {
    if (!_saveNeeded) return true;

    final ThemeData theme = Theme.of(context);
    final TextStyle dialogTextStyle = theme.textTheme.subhead.copyWith(color: theme.textTheme.caption.color);

    return await showDialog<bool>(
            context: context,
            builder: (BuildContext context) =>
                new AlertDialog(content: Text("Einstellung abbrechen?", style: dialogTextStyle), actions: <Widget>[
                  FlatButton(
                      child: Text("Nein"),
                      onPressed: () {
                        Navigator.of(context).pop(false);
                      }),
                  FlatButton(
                      child: Text("Ja"),
                      onPressed: () {
                        Navigator.of(context).pop(true);
                      })
                ])) ??
        false;
  }

  void showInSnackBar(String value) {
    _scaffoldKey.currentState.showSnackBar(new SnackBar(content: new Text(value)));
  }

  Future<bool> _handleSubmitted() async {
    final FormState form = _formKey.currentState;
    if (!form.validate()) {
      _autovalidate = true;
      return false;
    } else {
      form.save();
      //double realWeight = recursiveParsing(weight);
      Navigator.of(context).pop(heaterConfigs);
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return new Scaffold(
      key: _scaffoldKey,
      appBar: new AppBar(title: new Text("Temperatur Einstellungen"), actions: <Widget>[
        new IconButton(
          icon: Icon(Icons.undo),
          onPressed: () => undoAction(),
        ),
        new IconButton(
          icon: Icon(Icons.sort),
          onPressed: () {
            heaterConfigs.sort((x, y) => x.compareTo(y));
            setState(() {});
          },
        ),
        new IconButton(icon: Icon(Icons.save), onPressed: () => _handleSubmitted())
      ]),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          setState(() {
            var hc = HeaterConfig();
            addHeaterConfig(hc);
          });
        },
      ),
      body: new Form(
          key: _formKey,
          onWillPop: _onWillPop,
          autovalidate: _autovalidate,
          child: new ListView(
              padding: const EdgeInsets.all(16.0),
              children: heaterConfigs.map((x) => heaterConfigToWidget(x)).toList())),
    );
  }

  undoAction() {
    if (actions.length == 0) return;
    var action = actions.last;
    actions.remove(action);
    switch (action.action) {
      case Action.Add:
        heaterConfigs.remove(action.heaterConfig);
        break;
      case Action.Delete:
        // heaterConfigs.insert(action.prevValue, action.heaterConfig);
        break;
      case Action.TimeChanged:
        action.heaterConfig.timeOfDay = action.prevValue;
        break;
      case Action.WeekdayChanged:
        action.heaterConfig.dayOfWeek = action.prevValue;
        break;
      case Action.TempChanged:
        action.heaterConfig.temperature = action.prevValue;
        break;
      default:
    }
    setState(() {});
  }

  final List<String> weekdayListText = ["Mo", "Di", "Mi", "Do", "Fr", "Sa", "So"];
  final List<DropdownMenuItem> itemsForDropdown = buildItems();
  Widget heaterConfigToWidget(HeaterConfig conf) {
    double width = MediaQuery.of(context).size.width;
    var val = null;
    return Dismissible(
      key: ValueKey(conf),
      child: ListTile(
        title: Row(
          children: <Widget>[
            DropdownButton(
              value: conf.dayOfWeek.index,
              onChanged: (newValue) {
                setState(() {
                  actions.add(HistoryAction<DayOfWeek>(Action.WeekdayChanged, conf, conf.dayOfWeek));
                  conf.dayOfWeek = DayOfWeek.values[newValue];
                });
              },
              items: DayOfWeek.values.map((val) {
                return DropdownMenuItem(
                  child: new Text(weekdayListText[val.index]),
                  value: val.index,
                );
              }).toList(),
            ),
            FlatButton(
              child: Text(
                "${conf.timeOfDay.hour}:${conf.timeOfDay.minute}",
              ),
              onPressed: () async {
                var tod = await showTimePicker(context: context, initialTime: conf.timeOfDay);
                if (tod == null) return;
                actions.add(HistoryAction<TimeOfDay>(Action.TimeChanged, conf, conf.timeOfDay));
                conf.timeOfDay = tod;
                setState(() {});
              },
            ),
            // WheelChooser.double(
            //   onValueChanged: (s) {
            //     // if (actions.last.heaterConfig != conf || actions.last.action != Action.TempChanged)
            //     //   actions.add(HistoryAction<double>(Action.TempChanged, conf, conf.temperature));
            //     conf.temperature = s + 0.005;
            //   },
            //   horizontal: false,
            //   listWidth: 40.0,
            //   listHeight: width / 2.55,
            //   minValue: 5.0,
            //   maxValue: 35.1,
            //   step: 0.1,
            //   initValue: conf.temperature + 0.005,
            //   diameter: 2,
            //   itemSize: 48,
            //   selectTextStyle: TextStyle(color: Colors.black, fontSize: 14),
            //   unSelectTextStyle: TextStyle(color: Colors.black45, fontSize: 11),
            // ),
            DropdownButton(
                items: itemsForDropdown,
                onChanged: (s) => setState(() {
                      conf.temperature = (s/10.0);
                    }),
                value: (conf.temperature * 10).round()), // ,)

            IconButton(
              icon: Icon(Icons.content_copy),
              onPressed: () {
                var hc = new HeaterConfig();
                hc.dayOfWeek = conf.dayOfWeek;
                hc.temperature = conf.temperature;
                hc.timeOfDay = conf.timeOfDay;
                addHeaterConfig(hc);
              },
            )
            //  WheelChooser.integer(onValueChanged: (d){}, minValue: 5, maxValue: 35, step: 1, horizontal: true,)
            //  WheelChooser.double(onValueChanged: (d){}, minValue: 5.0, maxValue: 35.0, step: 0.1, horizontal: true,)
          ],
        ),
      ),
      confirmDismiss: (dir) async {
        var index = heaterConfigs.indexOf(conf);
        var ha = HistoryAction<Future<bool> Function(int, HistoryAction)>(Action.Delete, conf, (i, ha) async {
          HistoryAction before;
          if (actions.length > 1) before = actions.elementAt(actions.length - 2);
          while (true) {
            if (actions.last == ha && actions.last.action == Action.Delete) {
              await Future.delayed(Duration(milliseconds: 16));
            } else if (before != null && actions.last == before) {
              return false;
            } else if (before == null && actions.length > 1) {
              actions.remove(ha);
              return true;
            } else if (before == null && actions.length < 1) {
              return false;
            } else {
              return true;
            }
          }
        });
        actions.add(ha);
        return await ha.prevValue(index, ha);
      },
      onDismissed: (DismissDirection d) {
        heaterConfigs.remove(conf);
      },
      direction: DismissDirection.horizontal,
      background: Container(
        decoration: BoxDecoration(color: Theme.of(context).primaryColor),
        child: ListTile(
          leading: Icon(Icons.delete, color: Theme.of(context).accentIconTheme.color, size: 36.0),
        ),
      ),
    );
  }

  static List<DropdownMenuItem> buildItems() {
    var menuItems = List<DropdownMenuItem>();
    for (double d = 5.0; d <= 35.0; d += 0.1) {
      menuItems.add(DropdownMenuItem(child: Text(d.toStringAsFixed(1)), value: (d * 10).round()));
    }
    return menuItems;
  }

  void addHeaterConfig(HeaterConfig hc) {
    heaterConfigs.add(hc);
    actions.add(HistoryAction<bool>(Action.Add, hc, false));
    setState(() {});
  }
}
