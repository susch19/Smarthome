import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:smarthome/helper/settings_manager.dart';

class SetupPage extends HookConsumerWidget {
  const SetupPage({super.key});

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final settingsProv = ref.watch(settingsManagerProvider);
    final nameController = useTextEditingController(text: settingsProv.name);
    final urlController =
        useTextEditingController(text: settingsProv.serverUrl);
    final urlError = useState<String?>(null);
    final nameError = useState<String?>(null);

    return Scaffold(
      body: Center(
        child: Card(
          elevation: 2,
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 8,
              vertical: 40,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Flexible(
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ListTile(
                          title: Text(
                            "Bitte geben Sie die Daten für das Setup ein.",
                          ),
                        ),
                        ListTile(
                          title: TextField(
                            onChanged: (final value) {
                              validateInput(urlController.text, urlError,
                                  nameController.text, nameError);
                            },
                            controller: nameController,
                            decoration: InputDecoration(
                                errorText: nameError.value,
                                label: Text("Name"),
                                border: const OutlineInputBorder()),
                          ),
                        ),
                        ListTile(
                          title: TextField(
                            onChanged: (final value) {
                              validateInput(urlController.text, urlError,
                                  nameController.text, nameError);
                            },
                            controller: urlController,
                            decoration: InputDecoration(
                                errorText: urlError.value,
                                
                                label: Text("URL"),
                                border: const OutlineInputBorder()),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox.fromSize(
                  size: const Size.fromHeight(48),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: FilledButton(
                      onPressed: () {
                        if (!validateInput(urlController.text, urlError,
                            nameController.text, nameError)) {
                          return;
                        }

                        final settingsManager =
                            ref.read(settingsManagerProvider.notifier);
                        settingsManager.setServerUrl(urlController.text);
                        settingsManager.setName(nameController.text);
                      },
                      child: Text(
                        "Weiter",
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  bool validateInput(final String url, final ValueNotifier<String?> urlError, final String name,
      final ValueNotifier<String?> nameError) {
    final uri = Uri.tryParse(url);
    bool anyError = false;
    if (uri == null ||
        !uri.hasScheme ||
        !uri.hasAuthority ||
        uri.host.isEmpty) {
      urlError.value = "URL has wrong format";
      anyError = true;
    } else {
      urlError.value = null;
    }
    if (name.isEmpty) {
      nameError.value = "Name eingeben";
      anyError = true;
    } else {
      nameError.value = null;
    }

    return !anyError;
  }
}
