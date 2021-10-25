import 'dart:developer';
import 'dart:io';

import 'package:DogApkTools/app/app_config.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppData {
  static getConfigPath() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    AppConfig.jdkPath = sharedPreferences.getString('jdkPath') ?? '尚未设置';
    AppConfig.toolsPath = sharedPreferences.getString('toolsPath') ?? '尚未设置';
    Directory directory = Directory(AppConfig.jdkPath);
    if (!directory.existsSync()) {
      AppConfig.jdkPath = '尚未设置';
    }

    Directory directory3 = Directory(AppConfig.toolsPath);
    if (!directory3.existsSync()) {
      AppConfig.toolsPath = '尚未设置';
    }
  }

  static setConfigPath(int type, String content) async {
    //刷新设置
    log('检查基本配置 ${AppConfig.toolsPath}');
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    switch (type) {
      case 0:
        sharedPreferences.setString('jdkPath', content);
        return;

      case 1:
        sharedPreferences.setString('toolsPath', content);
        return;
    }
  }

  static Future<List<String>> getTopGame() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getStringList('YZXGamesTop') ?? [];
  }

  static setTopGame(List<String> data) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setStringList('YZXGamesTop', data);
  }
}
