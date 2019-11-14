import 'dart:io';
import 'package:path_provider/path_provider.dart';

class ReadWriteFile {
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<File> writeStringToFile(String fileName, String content) async {
    final path = await _localPath;
    final file = File(path + '/' + fileName);
    return file.writeAsString(content);
  }

  Future<String> readStringFromFile(String fileName) async {
    final path = await _localPath;
    final file = File(path + '/' + fileName);
    return file.readAsString();
  }
}
