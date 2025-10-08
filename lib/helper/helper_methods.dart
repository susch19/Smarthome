import 'package:url_launcher/url_launcher_string.dart';

class HelperMethods {
  static void openUrl(final String url) async {
    await launchUrlString(url, mode: LaunchMode.externalApplication);
  }
}
