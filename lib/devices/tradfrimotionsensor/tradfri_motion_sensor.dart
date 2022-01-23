import 'package:flutter/material.dart';
import 'package:signalr_core/signalr_core.dart';
import 'package:smarthome/devices/device.dart';
import 'package:smarthome/devices/device_manager.dart';
import 'package:smarthome/helper/theme_manager.dart';
import 'package:smarthome/icons/icons.dart';
import '../device_manager.dart';
import 'tradfri_motion_sensor_model.dart';
import '../../helper/datetime_helper.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TradfriMotionSensor extends Device<TradfriMotionSensorModel> {
  TradfriMotionSensor(final int id, final String typeName, final TradfriMotionSensorModel model,
      final HubConnection connection, final IconData icon)
      : super(id, typeName, model, connection, iconData: icon);

  @override
  void navigateToDevice(final BuildContext context) {
    Navigator.push(
        context, MaterialPageRoute(builder: (final BuildContext context) => TradfriMotionSensorScreen(this)));
  }

  @override
  Widget getRightWidgets() {
    return Icon(
      (baseModel.battery > 80
          ? SmarthomeIcons.bat4
          : (baseModel.battery > 60
              ? SmarthomeIcons.bat3
              : (baseModel.battery > 40
                  ? SmarthomeIcons.bat2
                  : (baseModel.battery > 20 ? SmarthomeIcons.bat1 : SmarthomeIcons.bat_charge)))),
      size: 20,
    );
  }

  @override
  Widget dashboardCardBody() {
    return Column(
        children: (<Widget>[
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                Text((baseModel.occupancy ? "Blockiert" : "Frei"),
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 24)),
              ]),
              Container(
                height: 2,
              ),
              Wrap(
                alignment: WrapAlignment.center,
                runAlignment: WrapAlignment.spaceEvenly,
                children: [
                  Text(
                      (baseModel.lastReceived.millisecondsSinceEpoch == -62135600400000
                          ? ""
                          : baseModel.lastReceived.subtract(Duration(seconds: baseModel.noMotion)).toDate()),
                      style: const TextStyle()),
                ],
              ),
            ] +
            (DeviceManager.showDebugInformation
                ? <Widget>[
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                      Text(baseModel.lastReceived.toDate()),
                    ]),
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [Text(baseModel.id.toRadixString(16))]),
                  ]
                : <Widget>[])));
  }

  @override
  DeviceTypes getDeviceType() {
    return DeviceTypes.TradfriMotionSensor;
  }
}

class TradfriMotionSensorScreen extends ConsumerStatefulWidget {
  final TradfriMotionSensor device;
  const TradfriMotionSensorScreen(this.device, {final Key? key}) : super(key: key);

  @override
  _TradfriMotionSensorScreenState createState() => _TradfriMotionSensorScreenState();
}

class _TradfriMotionSensorScreenState extends ConsumerState<TradfriMotionSensorScreen> {
  DateTime dateTime = DateTime.now();

  @override
  Widget build(final BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.device.baseModel.friendlyName),
      ),
      body: Container(
        decoration: ThemeManager.getBackgroundDecoration(context),
        child: buildBody(),
      ),
    );
  }

  Widget buildBody() {
    final model = ref.watch(widget.device.baseModelTProvider(widget.device.id));

    if (model is! TradfriMotionSensorModel) return Container();

    return ListView(
      children: <Widget>[
        ListTile(
          title: Text("Blockiert: " + (model.occupancy ? "Ja" : "Nein")),
        ),
        ListTile(
          title: Text("Letzte Bewegung: " + model.lastReceived.subtract(Duration(seconds: model.noMotion)).toDate()),
        ),
        ListTile(
          title: Text("Battery: " + model.battery.toStringAsFixed(0) + " %"),
        ),
        ListTile(
          title: Text("Verfügbar: " + (model.available ? "Ja" : "Nein")),
        ),
        ListTile(
          title: Text("Verbindungsqualität: " + (model.linkQuality.toString())),
        ),
        ListTile(
          title: Text("Zuletzt empfangen: " + model.lastReceived.toDate()),
        ),
      ],
    );
  }
}
