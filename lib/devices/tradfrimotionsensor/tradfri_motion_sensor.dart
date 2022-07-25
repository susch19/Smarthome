import 'package:flutter/material.dart';
import 'package:smarthome/devices/device_exporter.dart';
import 'package:smarthome/devices/device_manager.dart';
import 'package:smarthome/helper/theme_manager.dart';
import 'package:smarthome/icons/icons.dart';
import '../device_manager.dart';
import '../../helper/datetime_helper.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TradfriMotionSensor extends Device<TradfriMotionSensorModel> {
  TradfriMotionSensor(final int id, final String typeName, final IconData icon) : super(id, typeName, iconData: icon);

  @override
  void navigateToDevice(final BuildContext context) {
    Navigator.push(
        context, MaterialPageRoute(builder: (final BuildContext context) => TradfriMotionSensorScreen(this)));
  }

  @override
  Widget getRightWidgets() {
    return Consumer(
      builder: (final context, final ref, final child) {
        final battery = ref.watch(TradfriMotionSensorModel.batteryProvider(id));
        return Icon(
          (battery > 80
              ? SmarthomeIcons.bat4
              : (battery > 60
                  ? SmarthomeIcons.bat3
                  : (battery > 40
                      ? SmarthomeIcons.bat2
                      : (battery > 20 ? SmarthomeIcons.bat1 : SmarthomeIcons.bat_charge)))),
          size: 20,
        );
      },
    );
  }

  @override
  Widget dashboardCardBody() {
    return Column(
      children: (<Widget>[
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              Consumer(
                builder: (final context, final ref, final child) {
                  return Text((ref.watch(TradfriMotionSensorModel.occupancyProvider(id)) ? "Blockiert" : "Frei"),
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 24));
                },
              )
            ]),
            Container(
              height: 2,
            ),
            Wrap(
              alignment: WrapAlignment.center,
              runAlignment: WrapAlignment.spaceEvenly,
              children: [
                Consumer(
                  builder: (final context, final ref, final child) {
                    final lastReceived = ref.watch(ZigbeeModel.lastReceivedProvider(id));

                    return Text(
                        (lastReceived.millisecondsSinceEpoch == -62135600400000
                            ? ""
                            : lastReceived
                                .subtract(Duration(seconds: ref.watch(TradfriMotionSensorModel.noMotionProvider(id))))
                                .toDate()),
                        style: const TextStyle());
                  },
                ),
              ],
            ),
          ] +
          (DeviceManager.showDebugInformation
              ? <Widget>[
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                    Consumer(
                      builder: (final context, final ref, final child) {
                        return Text(ref.watch(ZigbeeModel.lastReceivedProvider(id)).toDate());
                      },
                    ),
                  ]),
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [Text(id.toRadixString(16))]),
                ]
              : <Widget>[])),
    );
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
    final friendlyName = ref.watch(BaseModel.friendlyNameProvider(widget.device.id));
    return Scaffold(
      appBar: AppBar(
        title: Text(friendlyName),
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
