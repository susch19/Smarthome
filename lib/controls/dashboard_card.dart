// ignore_for_file: prefer_const_constructors

import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
import 'package:smarthome/devices/device_exporter.dart';
import 'package:smarthome/controls/controls_exporter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tuple/tuple.dart';

class StatelessDashboardCard extends ConsumerWidget {
  final Device device;
  final VoidCallback onLongPress;
  final Object tag;

  const StatelessDashboardCard({
    final Key? key,
    required this.device,
    required this.onLongPress,
    required this.tag,
  }) : super(key: key);
  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final friendlyName = ref.watch(BaseModel.friendlyNameProvider(device.id));
    final typeNames = ref.watch(BaseModel.typeNamesProvider(device.id));
    final isConnected = ref.watch(BaseModel.isConnectedProvider(device.id));

    final deviceIcon = ref.watch(iconWidgetProvider(Tuple3(typeNames ?? [], device, AdaptiveTheme.of(context))));
    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: Card(
        color: Colors.transparent,
        child: BlurryContainer(
          color: AdaptiveTheme.of(context).brightness == Brightness.light ? Colors.white54 : Colors.black38,
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
                        margin: const EdgeInsets.only(left: 4, top: 8.0, bottom: 8.0),
                        child: SizedBox(width: 32, height: 40, child: deviceIcon //icon,
                            )),
                    Expanded(
                      child: Container(
                        margin: const EdgeInsets.only(top: 4.0),
                        child: device.dashboardCardBody(),
                      ),
                    ),
                    Container(
                      // width: 16,
                      // height: 16,
                      child: device.getRightWidgets(),
                      margin: const EdgeInsets.only(right: 8.0, top: 8.0, bottom: 8.0),
                    ),
                  ],
                ),
                Container(
                  margin: const EdgeInsets.only(left: 8.0, bottom: 8.0),
                  child: Row(
                    children: [
                      Container(
                        margin: const EdgeInsets.only(left: 12, top: 8),
                        child: CustomPaint(
                          painter: CircleBlurPainter(
                            isConnected ?? false ? Colors.greenAccent : Colors.red,
                            const Offset(0, 8),
                            blurSigma: 2,
                            circleWidth: 10,
                          ),
                        ),
                        height: 16,
                        width: 12,
                      ),
                      Expanded(
                        child: Container(
                          margin: const EdgeInsets.only(top: 8.0),
                          child: Text(
                            friendlyName,
                            style: const TextStyle(),
                            softWrap: true,
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                      SizedBox(
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
