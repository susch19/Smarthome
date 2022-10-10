import 'package:version/version.dart';

class VersionAndUrl {
  Version version;
  bool upToDate;
  String? url;

  VersionAndUrl(this.version, this.upToDate, this.url);

  @override
  bool operator ==(final Object other) =>
      other is VersionAndUrl && version == other.version && upToDate == other.upToDate && url == other.url;

  @override
  int get hashCode => Object.hash(version.hashCode, upToDate.hashCode, url);
}
