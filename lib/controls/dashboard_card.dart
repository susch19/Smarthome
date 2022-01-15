import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
import 'package:smarthome/devices/device_exporter.dart';
import 'package:smarthome/controls/controls_exporter.dart';

class StatelessDashboardCard extends StatelessWidget {
  final Device device;
  late final BaseModel _model;
  final Widget? icon;
  late final Widget _lowerLeftWidget;
  final VoidCallback onLongPress;
  final Object tag;

  StatelessDashboardCard(
      {Key? key, required this.device, required this.onLongPress, required this.tag, required this.icon}) {
    _model = device.baseModel;
    _lowerLeftWidget = device.rightWidgets();
  }
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: Card(
        color: Colors.transparent,
        // color: Colors.white.withOpacity(0.5),
        // shadowColor: ThemeManager.isLightTheme ?  Colors.white.withOpacity(0) : Colors.black,
        // color: ThemeManager.isLightTheme ?  Colors.indigo.shade100.withOpacity(1) : Colors.indigo.shade800.withOpacity(0.25),
        child: BlurryContainer(
          color: AdaptiveTheme.of(context).mode.isLight ? Colors.white54 : Colors.black38,
          child: MaterialButton(
            splashColor: Colors.transparent,
            disabledColor: Colors.transparent,
            // child: Stack(
            //   children: [
            //     Positioned.fill(
            //       child: Container(
            //         alignment: Alignment.centerLeft,
            //         // This child will fill full height, replace it with your leading widget
            //         child: Container(
            //           color: Colors.grey.shade100,
            //         ),
            //       ),
            //     ),
            //     IntrinsicHeight(
            //       child: Row(
            //         // crossAxisAlignment: CrossAxisAlignment.stretch,
            //         // mainAxisAlignment: MainAxisAlignment.,
            //         // mainAxisSize: MainAxisSize.max,
            //         crossAxisAlignment: CrossAxisAlignment.start,
            //         children: [
            //           Flexible(
            //             flex: 2,
            //             // fit: FlexFit.tight,
            //             child: Container(
            //               color: Colors.yellow,
            //               child: Column(
            //                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //                 children: [
            //                   Container(
            //                     margin: EdgeInsets.only(
            //                         left: 4, top: 8.0, bottom: 8.0),
            //                     child: Container(
            //                       width: 32,
            //                       height: 40,
            //                       child: _icon,
            //                     ),
            //                   ),
            //                   Container(
            //                     margin: EdgeInsets.only(
            //                         left: 12, bottom: 8, top: 8),
            //                     child: CustomPaint(
            //                       painter: CircleBlurPainter(
            //                         device.isConnected
            //                             ? Colors.greenAccent
            //                             : Colors.red,
            //                         Offset(0, 8),
            //                         blurSigma: 2,
            //                         circleWidth: 10,
            //                       ),
            //                     ),
            //                     height: 16,
            //                     width: 12,
            //                   ),
            //                 ],
            //               ),
            //             ),
            //           ),
            //           Flexible(
            //             flex: 8,
            //             child: Container(
            //               color: Colors.red,
            //               height: 124,
            //               child: Column(
            //                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //                 children: [
            //                   // Flexible(
            //                   // child:
            //                   device.dashboardCardBody(),
            //                   // ),
            //                   Container(
            //                     margin: EdgeInsets.symmetric(vertical: 8.0),
            //                     child: Text(
            //                       _model.friendlyName.toString(),
            //                       style: TextStyle(),
            //                       softWrap: true,
            //                       textAlign: TextAlign.center,
            //                     ),
            //                   ),
            //                 ],
            //               ),
            //             ),
            //           ),
            //           Expanded(
            //             flex: 1,
            //             child: Container(
            //               child: Column(
            //                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //                 children: [_lowerLeftWidget],
            //               ),
            //               color: Colors.green,
            //             ),
            //           ),
            //         ],
            //       ),
            //     ),
            //   ],
            // ),
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                        margin: EdgeInsets.only(left: 4, top: 8.0, bottom: 8.0),
                        child: Container(
                          width: 32,
                          height: 40,
                          child: icon,
                        )),
                    Expanded(
                      child: Container(
                        margin: EdgeInsets.only(top: 4.0),
                        child: device.dashboardCardBody(),
                      ),
                    ),
                    Container(
                      // width: 16,
                      // height: 16,
                      child: _lowerLeftWidget,
                      margin: EdgeInsets.only(right: 8.0, top: 8.0, bottom: 8.0),
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
                          painter: CircleBlurPainter(
                            device.isConnected ? Colors.greenAccent : Colors.red,
                            Offset(0, 8),
                            blurSigma: 2,
                            circleWidth: 10,
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
            // ),
            onPressed: () => device.navigateToDevice(context),
            onLongPress: onLongPress,
          ),
        ),
      ),
    );
  }
}
