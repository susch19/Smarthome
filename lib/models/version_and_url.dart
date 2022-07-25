import 'package:version/version.dart';

class VersionAndUrl {
  Version version;
  String? url;

  VersionAndUrl(this.version, this.url);

  @override
  bool operator ==(final Object other) => other is VersionAndUrl && version == other.version && url == other.url;

  @override
  int get hashCode => Object.hash(version.hashCode, url);
}
