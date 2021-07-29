// ignore_for_file: unnecessary_null_comparison

import 'package:flutter/material.dart';
// import 'package:signalr_client/signalr_client.dart';
import 'package:signalr_core/signalr_core.dart';
import 'package:smarthome/devices/device.dart';
import 'package:smarthome/devices/device_manager.dart';
import 'package:smarthome/models/message.dart' as sm;
import 'package:shared_preferences/shared_preferences.dart';

import '../device_manager.dart';
import 'floalt_panel_model.dart';

class FloaltPanel extends Device<FloaltPanelModel> {
  FloaltPanel(int? id, FloaltPanelModel model, HubConnection connection, IconData icon, SharedPreferences? prefs)
      : super(id, model, connection, icon, prefs);

  Function? func;

  @override
  State<StatefulWidget> createState() => _FloaltPanelState();

  @override
  Future sendToServer(sm.MessageType messageType, sm.Command command, [List<String>? parameters]) async {
    await super.sendToServer(messageType, command, parameters);
    var message = new sm.Message(id, messageType, command, parameters);
    await connection.invoke("Update", args: <Object>[message.toJson()]);
  }

  @override
  void updateFromServer(Map<String, dynamic> message) {
    baseModel = FloaltPanelModel.fromJson(message);
    if (func != null) func!(() {});
  }

  @override
  void navigateToDevice(BuildContext context) {
    Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => FloaltPanelScreen(this)));
  }

  @override
  Widget dashboardView() {
    return Column(
        children: getDefaultHeader(Container(
              margin: EdgeInsets.only(right: 32.0),
            ), baseModel.available) +
            (<Widget>[
              MaterialButton(
                child: Text("An/Aus"),
                onPressed: () async => await sendToServer(sm.MessageType.Update, sm.Command.Off),
              )
            ]));
  }

  @override
  DeviceTypes getDeviceType() {
    return DeviceTypes.FloaltPanel;
  }
}

class _FloaltPanelState extends State<FloaltPanel> {
  @override
  Widget build(BuildContext context) => FloaltPanelScreen(this.widget);
}

class FloaltPanelScreen extends DeviceScreen {
  final FloaltPanel floaltPanel;
  FloaltPanelScreen(this.floaltPanel);

  @override
  State<StatefulWidget> createState() => _FloaltPanelScreenState();
}

class _FloaltPanelScreenState extends State<FloaltPanelScreen> {
  DateTime dateTime = DateTime.now();

  void sliderChange(Function f, int dateTimeMilliseconds, [double? val]) {
    if (DateTime.now().isAfter(dateTime.add(new Duration(milliseconds: dateTimeMilliseconds)))) {
      Function.apply(f, val == null ? [] : [val]);
      dateTime = DateTime.now();
    }
  }

  @override
  void initState() {
    super.initState();
    this.widget.floaltPanel.func = setState;
  }

  @override
  void deactivate() {
    super.deactivate();
    this.widget.floaltPanel.func = null;
  }

  void changeDelay(double? delay) {
    this.widget.floaltPanel.sendToServer(sm.MessageType.Options, sm.Command.Delay, [delay.toString()]);
  }

  void changeBrightness(double brightness) {
    this.widget.floaltPanel.sendToServer(sm.MessageType.Update, sm.Command.Brightness, [brightness.round().toString()]);
  }

  void changeColorTemp(double colorTemp) {
    this.widget.floaltPanel.sendToServer(sm.MessageType.Update, sm.Command.Temp, [colorTemp.round().toString()]);
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        title: new Text(this.widget.floaltPanel.baseModel.friendlyName),
      ),
      body: buildBody(this.widget.floaltPanel.baseModel),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.power_settings_new),
        onPressed: () => this.widget.floaltPanel.sendToServer(sm.MessageType.Update, sm.Command.Off, []),
      ),
    );
  }

  Widget buildBody(FloaltPanelModel model) {
    return ListView(
      children: <Widget>[
        ListTile(
          title: Text("Angeschaltet: " + (model.state ? "Ja" : "Nein")),
        ),
        ListTile(
          title: Text("Verfügbar: " + (model.available ? "Ja" : "Nein")),
        ),
        ListTile(
          title: Text("Verbindungsqualität: " + (model.linkQuality.toString())),
        ),
        ListTile(
          title: Text("Helligkeit " + model.brightness.toStringAsFixed(0)),
          subtitle: GestureDetector(
            child: SliderTheme(
              child: Slider(
                value: model.brightness.toDouble(),
                onChanged: (d) {
                  setState(() => model.brightness = d.round());
                  sliderChange(changeBrightness, 500, d);
                },
                min: 0.0,
                max: 100.0,
                divisions: 100,
                label: '${model.brightness}',
              ),
              data: SliderTheme.of(context).copyWith(
                  trackShape: GradientRoundedRectSliderTrackShape(
                      LinearGradient(colors: [Colors.grey.shade800, Colors.white]))),
            ),
            onTapCancel: () => changeBrightness(model.brightness.toDouble()),
          ),
        ),
        ListTile(
          title: Text("Farbtemparatur " + (model.colorTemp - 204).toStringAsFixed(0)),
          subtitle: GestureDetector(
            child: SliderTheme(
              child: Slider(
                value: ((model.colorTemp - 204).clamp(0, 204)).toDouble(),
                onChanged: (d) {
                  setState(() => model.colorTemp = d.round() + 204);
                  sliderChange(changeColorTemp, 500, d + 204.0);
                },
                min: 0.0,
                max: 204.0,
                divisions: 204,
                label: '${model.colorTemp - 204}',
              ),
              data: SliderTheme.of(context).copyWith(
                  trackShape: GradientRoundedRectSliderTrackShape(
                      LinearGradient(colors: [Color.fromARGB(255, 255, 147, 44), Color.fromARGB(255, 255, 209, 163)]))),
            ),
            onTapCancel: () => changeColorTemp(model.colorTemp.toDouble()),
          ),
        ),
        ListTile(
          title: Text("Übergangszeit " + model.transitionTime.toStringAsFixed(1) + " Sekunden"),
          subtitle: GestureDetector(
            child: Slider(
              value: model.transitionTime,
              onChanged: (d) {
                setState(() => model.transitionTime = d);
                sliderChange(changeDelay, 500, d);
              },
              min: 0.0,
              max: 10.0,
              divisions: 100,
              label: '${model.transitionTime}',
            ),
            onTapCancel: () => changeDelay(model.transitionTime),
          ),
        ),
      ],
    );
  }
}

class GradientRoundedRectSliderTrackShape extends SliderTrackShape with BaseSliderTrackShape {
  final LinearGradient gradient;

  /// Create a slider track that draws two rectangles with rounded outer edges.

  const GradientRoundedRectSliderTrackShape(this.gradient);

  @override
  void paint(
    PaintingContext context,
    Offset offset, {
    required RenderBox parentBox,
    required SliderThemeData sliderTheme,
    required Animation<double> enableAnimation,
    required TextDirection textDirection,
    required Offset thumbCenter,
    bool isDiscrete = false,
    bool isEnabled = false,
    double additionalActiveTrackHeight = 2,
  }) {
    assert(offset != null);
    assert(parentBox != null);
    assert(sliderTheme != null);
    assert(sliderTheme.disabledActiveTrackColor != null);
    assert(sliderTheme.disabledInactiveTrackColor != null);
    assert(sliderTheme.activeTrackColor != null);
    assert(sliderTheme.inactiveTrackColor != null);
    assert(sliderTheme.thumbShape != null);
    assert(enableAnimation != null);
    assert(textDirection != null);
    assert(thumbCenter != null);
    // If the slider [SliderThemeData.trackHeight] is less than or equal to 0,
    // then it makes no difference whether the track is painted or not,
    // therefore the painting  can be a no-op.
    if (sliderTheme.trackHeight == null || sliderTheme.trackHeight! <= 0) {
      return;
    }

    final Rect trackRect = getPreferredRect(
      parentBox: parentBox,
      offset: offset,
      sliderTheme: sliderTheme,
      isEnabled: isEnabled,
      isDiscrete: isDiscrete,
    );

    // Assign the track segment paints, which are leading: active and
    // trailing: inactive.
    final ColorTween activeTrackColorTween =
        ColorTween(begin: sliderTheme.disabledActiveTrackColor, end: sliderTheme.activeTrackColor);
    final ColorTween inactiveTrackColorTween =
        ColorTween(begin: sliderTheme.disabledInactiveTrackColor, end: sliderTheme.inactiveTrackColor);
    final Paint activePaint = Paint()
      ..shader = gradient.createShader(trackRect)
      ..color = activeTrackColorTween.evaluate(enableAnimation)!;
    final Paint inactivePaint = Paint()
      ..shader = gradient.createShader(trackRect)
      ..color = inactiveTrackColorTween.evaluate(enableAnimation)!;
    final Paint leftTrackPaint;
    final Paint rightTrackPaint;
    switch (textDirection) {
      case TextDirection.ltr:
        leftTrackPaint = activePaint;
        rightTrackPaint = inactivePaint;
        break;
      case TextDirection.rtl:
        leftTrackPaint = inactivePaint;
        rightTrackPaint = activePaint;
        break;
    }

    final Radius trackRadius = Radius.circular(trackRect.height / 2);
    final Radius activeTrackRadius = Radius.circular((trackRect.height + additionalActiveTrackHeight) / 2);

    context.canvas.drawRRect(
      RRect.fromLTRBAndCorners(
        trackRect.left,
        (textDirection == TextDirection.ltr) ? trackRect.top - (additionalActiveTrackHeight / 2) : trackRect.top,
        thumbCenter.dx,
        (textDirection == TextDirection.ltr) ? trackRect.bottom + (additionalActiveTrackHeight / 2) : trackRect.bottom,
        topLeft: (textDirection == TextDirection.ltr) ? activeTrackRadius : trackRadius,
        bottomLeft: (textDirection == TextDirection.ltr) ? activeTrackRadius : trackRadius,
      ),
      leftTrackPaint,
    );
    context.canvas.drawRRect(
      RRect.fromLTRBAndCorners(
        thumbCenter.dx,
        (textDirection == TextDirection.rtl) ? trackRect.top - (additionalActiveTrackHeight / 2) : trackRect.top,
        trackRect.right,
        (textDirection == TextDirection.rtl) ? trackRect.bottom + (additionalActiveTrackHeight / 2) : trackRect.bottom,
        topRight: (textDirection == TextDirection.rtl) ? activeTrackRadius : trackRadius,
        bottomRight: (textDirection == TextDirection.rtl) ? activeTrackRadius : trackRadius,
      ),
      rightTrackPaint,
    );
  }
}
