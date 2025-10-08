// ignore_for_file: prefer_const_constructors

import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
import 'package:smarthome/devices/device_exporter.dart';
import 'package:smarthome/controls/controls_exporter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smarthome/devices/generic/stores/store_service.dart';

class DashboardCard extends ConsumerWidget {
  final Device device;
  final VoidCallback onLongPress;

  const DashboardCard({
    super.key,
    required this.device,
    required this.onLongPress,
  });

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final typeNames = ref.watch(BaseModel.typeNamesProvider(device.id));
    final deviceIcon = ref.watch(iconWidgetProvider(
      typeNames ?? [],
      device,
      AdaptiveTheme.of(context),
      false,
    ));
    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: Card(
        color: Colors.transparent,
        child: BlurryContainer(
          color: AdaptiveTheme.of(context).brightness == Brightness.light
              ? Colors.white54
              : Colors.black38,
          child: MaterialButton(
            splashColor: Colors.transparent,
            disabledColor: Colors.transparent,
            onPressed: () => device.navigateToDevice(context),
            onLongPress: onLongPress,
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin:
                          const EdgeInsets.only(left: 4, top: 8.0, bottom: 8.0),
                      child: SizedBox(
                        width: 32,
                        height: 40,
                        child: IconButton(
                          padding: EdgeInsets.all(2),
                          onPressed: () {
                            device.iconPressed(context, ref);
                          },
                          icon: deviceIcon,
                        ), //icon,
                      ),
                    ),
                    Expanded(
                      child: Container(
                        margin: const EdgeInsets.only(top: 4.0),
                        child: device.dashboardCardBody(),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(
                        right: 8.0,
                        top: 8.0,
                        bottom: 8.0,
                      ),
                      child: device.getRightWidgets(),
                    ),
                  ],
                ),
                Container(
                  margin: const EdgeInsets.only(left: 8.0, bottom: 8.0),
                  child: Row(
                    children: [
                      Container(
                          margin: const EdgeInsets.only(left: 12, top: 8),
                          height: 16,
                          width: 12,
                          child: Consumer(
                            builder: (final _, final ref, final __) {
                              final bool? isConnected;
                              if (device is GenericDevice) {
                                isConnected = ref
                                    .watch(valueStoreChangedProvider(
                                        "isConnected", device.id))
                                    ?.currentValue;
                              } else {
                                isConnected = ref.watch(
                                    ConnectionBaseModel.isConnectedProvider(
                                        device.id));
                              }

                              if (isConnected == null) return const SizedBox();
                              return CustomPaint(
                                painter: CircleBlurPainter(
                                  isConnected ? Colors.greenAccent : Colors.red,
                                  const Offset(0, 8),
                                  blurSigma: 2,
                                  circleWidth: 10,
                                ),
                              );
                            },
                          )),
                      Expanded(
                        child: Container(
                            margin: const EdgeInsets.only(top: 8.0),
                            child: Consumer(
                              builder: (final _, final ref, final __) {
                                final friendlyName = ref.watch(
                                    BaseModel.friendlyNameProvider(device.id));
                                return Text(
                                  friendlyName,
                                  style: const TextStyle(),
                                  softWrap: true,
                                  textAlign: TextAlign.center,
                                );
                              },
                            )),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
