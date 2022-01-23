import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smarthome/devices/base_model.dart';

@immutable
class FriendlyNameDisplay extends ConsumerWidget {
  final int id;

  const FriendlyNameDisplay(this.id, {final Key? key}) : super(key: key);

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final friendlyName = ref.watch(baseModelFriendlyNameProvider(id));
    return Text(friendlyName ?? "");
  }
}
