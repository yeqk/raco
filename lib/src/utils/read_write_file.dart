import 'dart:io';
import 'dart:typed_data';
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

  Future<File> wirteBytesToFile(String fileName, ByteData content) async {
    final path = await _localPath;
    final file = File(path + '/' + fileName);
    return file.writeAsBytes(content.buffer.asUint8List(), flush: true);
  }

  Future<String> readStringFromFile(String fileName) async {
    final path = await _localPath;
    final file = File(path + '/' + fileName);
    return file.readAsString();
  }

  Future<bool> exists(String fileName) async{
    final path = await _localPath;
    return File(path + '/' + fileName).exists();
  }

  Future<String> getPaht(String fileName) async {
    final path = await _localPath;
    return path + '/' + fileName;
  }
}
