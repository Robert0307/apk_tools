import 'dart:convert';
import 'dart:io';

import 'package:DogApkTools/app/app_config.dart';
import 'package:file_selector/file_selector.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';

class FileUtils {
  static copy(File sourceFile, String newPath) async {
    var basNameWithExtension = path.basename(sourceFile.path);
    var file = await moveFile(sourceFile, newPath + "/" + basNameWithExtension);
  }

  //获取当前目录
  static Directory getDirectory(String path) {
    Directory directory = Directory(path);
    if (!directory.existsSync()) {
      directory.createSync(recursive: true);
    }

    return directory;
  }

  static Future<File> moveFile(File sourceFile, String newPath) async {
    try {
      return await sourceFile.rename(newPath);
    } catch (e) {
      final newFile = await sourceFile.copy(newPath);
      return newFile;
    }
  }

  static Future<String?> getDirPath() {
    return getDirectoryPath();
  }

  //获取下载目录
  static Future getDownloads() async {
    Directory? directory = await getDownloadsDirectory();
    String download = directory!.path;
    return download;
  }

  //获取Mac windows 分隔符
  static String getSeparator() {
    return path.separator;
  }

  //获取Mac windows 分隔符
  static bool isDirectory(String path) {
    Directory directory = Directory(path);
    return directory.existsSync();
  }

  //获取当前目录
  static String getToolsPath() {
    return AppConfig.toolsPath;
  }

  //获取当前目录
  static String getCurrent() {
    return Directory.current.toString();
  }

  //文件名
  static getFileName(String url) {
    return path.basename(url);
  }

  //获取扩展名
  static String getExtension(String file) {
    return path.extension(file);
  }

  //规范化路径
  static String canonicalizePath(String file) {
    return path.canonicalize(file);
  }

  //包含
  static bool isWithinPath(String parent, String child) {
    return path.isWithin(parent, child);
  }

  //去除扩展
  static String withoutExtensionFile(String file) {
    return path.withoutExtension(file);
  }

  //设置扩展
  static String setExtensionFile(String file, String extension) {
    return path.setExtension(file, extension);
  }

  //添加路径
  static String join(String file,
      [String part2 = '',
      String part3 = '',
      String part4 = '',
      String part5 = '',
      String part6 = '',
      String part7 = '',
      String part8 = '']) {
    return path.join(file, part2, part3, part4, part5, part6, part7, part8);
  }

  //是否是绝对路径
  static bool isAbsolute(String file) {
    return path.isAbsolute(file);
  }

  //文件是否存在
  static bool isFile(String filePath) {
    File file = File(filePath);

    return file.existsSync();
  }

  //是否是相对路径
  static bool isRelative(String file) {
    return path.isRelative(file);
  }

  static getParentPath(String file) {
    return File(file).parent.path;
  }

  //文件名不带扩展名
  static getFileNameWithoutExtension(String url) {
    return path.basenameWithoutExtension(url);
  }

  //当前文件夹路径
  static getFilePath(String url) {
    return path.dirname(url);
  }

  static readFile(filePath) {
    return new File('$filePath');
  }

  /// 读取json文件
  static Future<String> readJsonFile(filePath) async {
    try {
      final file = readFile(filePath);
      return await file.readAsString();
    } catch (err) {
      print(err);
      return '';
    }
  }

  /// 写入json文件
  static Future<File?> writeJsonFile(obj, filePath) async {
    try {
      final file = readFile(filePath);
      return await file.writeAsString(json.encode(obj));
    } catch (err) {
      print(err);
      return null;
    }
  }
}
