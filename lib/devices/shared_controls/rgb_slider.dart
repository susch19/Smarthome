// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';

// class RGBSlider extends StatefulWidget {
//   final RGB rgb;

//   const RGBSlider(this.rgb, {Key? key}) : super(key: key);

//   @override
//   State<StatefulWidget> createState() => _RGBSliderState();
// }

// class _RGBSliderState extends State<RGBSlider> {
//   late RGB rgb;

//   _RGBSliderState() {
//     rgb = widget.rgb;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         ListTile(
//           subtitle: Text("Red: ${rgb.hr} | ${rgb.r}"),
//           title: Slider(
//             value: rgb.dr,
//             onChanged: (final d) {
//               setState(() => rgb.dr = d);
//             },
//             onChangeEnd: (final a) => changeColor(),
//             max: 255.0,
//             label: 'R',
//           ),
//         ),
//         ListTile(
//           subtitle: Text("Green: ${rgb.hg} | ${rgb.g}"),
//           title: Slider(
//             value: rgb.dg,
//             onChanged: (final d) {
//               setState(() => rgb.dg = d);
//             },
//             onChangeEnd: (final a) => changeColor(),
//             max: 255.0,
//             label: 'G',
//           ),
//         ),
//         ListTile(
//           subtitle: Text("Blue: ${rgb.hb} | ${rgb.b}"),
//           title: Slider(
//             value: rgb.db,
//             onChanged: (final d) {
//               setState(() => rgb.db = d);
//             },
//             onChangeEnd: (final a) => changeColor(),
//             max: 255.0,
//             label: 'B',
//           ),
//         ),
//       ],
//     );
//   }
// }
