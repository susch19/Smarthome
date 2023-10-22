import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smarthome/controls/blurry_card.dart';
import 'package:smarthome/helper/theme_manager.dart';

class LogScreen extends ConsumerWidget {
  final ProviderFamily<String, int> _logs;
  final int _id;
  final GlobalKey<FormState> _scaffoldKey = GlobalKey<FormState>();

  LogScreen(this._logs, this._id, {final Key? key}) : super(key: key);

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final logsArray = ref.watch(_logs(_id)).split('\n');
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: const Text("Logs"),
      ),
      body: Container(
          decoration: ThemeManager.getBackgroundDecoration(context),
          child: ListView(padding: const EdgeInsets.all(16.0), children: logsArray.map(_logLineWidget).toList())),
    );
  }

  Widget _logLineWidget(final String val) {
    return Container(
      padding: const EdgeInsets.only(top: 8.0),
      child: BlurryCard(
        child: Container(
          margin: const EdgeInsetsDirectional.only(bottom: 8.0),
          child: Text(
            val,
            style: const TextStyle(fontSize: 18),
          ),
          // crossAxisAlignment: CrossAxisAlignment.start,
        ),
      ),
    );
  }
}
