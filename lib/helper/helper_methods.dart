import 'package:url_launcher/url_launcher.dart';

class HelperMethods {
  static void openUrl(String url) async {
    await launch(url, forceWebView: false);
  }
}
