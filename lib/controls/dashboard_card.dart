import 'package:flutter/material.dart';
import 'package:smarthome/devices/device_exporter.dart';

import 'cicle_painter.dart';

class StatelessDashboardCard extends StatelessWidget {
  final Device device;
  late final BaseModel _model;
  late final IconData _icon;
  late final Widget? _lowerLeftWidget;
  final VoidCallback onLongPress;
  final Object tag;

  StatelessDashboardCard({Key? key, required this.device, required this.onLongPress, required this.tag }) {
    _model = device.baseModel;
    _icon = device.icon;
    _lowerLeftWidget = device.lowerLeftWidget();
  }

  static int test = 0;
  static bool color() {
    test++;
    return (test % 5) == 0;
  }

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: tag,
      child: Card(
        child: MaterialButton(
          child: Container(
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      children: [
                        Container(
                          margin: EdgeInsets.only(top: 8.0, bottom: 8.0),
                          child: Icon(
                            _icon,
                            // color: color() ? Colors.red : Colors.green,
                            size: 40,
                          ),
                        ),
                      ],
                    ),
                    Expanded(
                      child: Container(
                        margin: EdgeInsets.only(top: 4.0),
                        child: device.dashboardCardBody(),
                      ),
                    ),
                    _lowerLeftWidget == null
                        ? Container()
                        : Container(
                            width: 16,
                            height: 16,
                            child: _lowerLeftWidget,
                            margin: EdgeInsets.only(right: 8.0, top: 8.0),
                          ),
                  ],
                ),
                Container(
                  margin: EdgeInsets.only(left: 8.0, bottom: 8.0),
                  child: Row(
                    children: [
                      Container(
                        margin: EdgeInsets.only(left: 12, bottom: 0, top: 8),
                        child: CustomPaint(
                          painter: CirclePainter(
                            8,
                            device.isConnected ? Colors.green : Colors.red,
                            Offset(0, 8),
                          ),
                        ),
                        height: 16,
                        width: 12,
                      ),
                      Expanded(
                        child: Container(
                          margin: EdgeInsets.only(top: 8.0),
                          child: Text(
                            _model.friendlyName.toString(),
                            style: TextStyle(),
                            softWrap: true,
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                      Container(
                        height: 16,
                        width: 12,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          onPressed: () => device.navigateToDevice(context),
          onLongPress: onLongPress,
        ),
      ),
    );
  }
}
