import 'dart:io';
import 'dart:typed_data';
import 'package:path/path.dart' as p;

class CacheFileManager {
  final String _path;
  final String _fileExtension;

  CacheFileManager(this._path, this._fileExtension);

  Future<void> ensureDirectoryExists() async {
    final tempPathDir = Directory(_path);
    if (!await tempPathDir.exists()) {
      await tempPathDir.create();
    }
  }

  Future<String?> readHashCode(final String fileName) async {
    final file = File(p.join(_path, "$fileName.$_fileExtension.md5"));
    if (!await file.exists()) return null;
    return file.readAsString();
  }

  Future<void> writeHashCode(final String fileName, final String hashCode) async {
    final file = File(p.join(_path, "$fileName.$_fileExtension.md5"));
    await file.writeAsString(hashCode);
  }

  Future<void> deleteHashCode(final String fileName) async {
    final file = File(p.join(_path, "$fileName.$_fileExtension.md5"));
    await file.delete();
  }

  Future<String?> readContentAsString(final String fileName) async {
    final file = File(p.join(_path, "$fileName.$_fileExtension"));
    if (!await file.exists()) return null;
    return file.readAsString();
  }

  Future<Uint8List?> readContentAsBytes(final String fileName) async {
    final file = File(p.join(_path, "$fileName.$_fileExtension"));
    return file.readAsBytes();
  }

  Future<void> writeContentAsString(final String fileName, final String content) async {
    final file = File(p.join(_path, "$fileName.$_fileExtension"));
    await file.writeAsString(content);
  }

  Future<void> writeContentAsBytes(final String fileName, final Uint8List content) async {
    final file = File(p.join(_path, "$fileName.$_fileExtension"));
    await file.writeAsBytes(content);
  }

  Future<void> deleteContent(final String fileName) async {
    final file = File(p.join(_path, "$fileName.$_fileExtension"));
    if (!await file.exists()) return;
    await file.delete();
  }
}
