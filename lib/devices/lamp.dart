// import 'dart:async';

// import 'package:flutter/material.dart';
// import 'package:smarthome/devices/device.dart';
// import 'package:web_socket_channel/src/channel.dart';

// class Lamp extends Device {
//   Lamp(int id, String url, Icon icon, List<String> printableInformation) : super(id, url, icon, printableInformation);

//   @override
//   _LampState createState() => _LampState();

//   @override
//   void sendUpdateToServer(WebSocketChannel channel) {
//   }

//   @override
//   void updateFromServer(Map<String, dynamic> message) {
//     return null;
//   }

//   @override
//   void navigateToDevice(BuildContext context) {
//     // TODO: implement navigateToDevice
//   }

  
// }

// class _LampState extends State<Lamp> {
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       child: Column(
//         children: <Widget>[
//           this.widget.icon,
//           Column(
//             children: this.widget.printableInformation.map((s) => Text(s)).toList(),
//           ),
//         ],
//       ),
//     );
//   }
// }
