import 'dart:convert';
import 'dart:io';
import 'package:yaml/yaml.dart';

class YmlUtils {
  static inquireInfo(String fileName, YmlInfo info) {
    File file = File('$fileName/apktool.yml');
    YamlNode doc = loadYaml(file
        .readAsStringSync()
        .replaceAll('!!brut.androlib.meta.MetaInfo', ''));
    YamlMap map = doc.value;

    var sdkInfo = json.decode(json.encode(map['sdkInfo']));

    if (info == YmlInfo.minSdkVersion) {
      return sdkInfo['minSdkVersion'];
    }

    if (info == YmlInfo.targetSdkVersion) {
      return sdkInfo['targetSdkVersion'];
    }

    var versionInfo = json.decode(json.encode(map['versionInfo']));
    if (info == YmlInfo.versionCode) {
      return versionInfo['versionCode'];
    }

    if (info == YmlInfo.versionName) {
      return versionInfo['versionName'];
    }

    return null;
  }

  static change(
    String fileName, {
    String? minSdkVersion,
    String? targetSdkVersion,
    String? versionCode,
    String? versionName,
  }) {
    File file = File('$fileName/apktool.yml');

    YamlNode doc = loadYaml(file
        .readAsStringSync()
        .replaceAll('!!brut.androlib.meta.MetaInfo', ''));
    YamlMap map = doc.value;

    var sdkInfo = json.decode(json.encode(map['sdkInfo']));
    var versionInfo = json.decode(json.encode(map['versionInfo']));

    String data = file
        .readAsStringSync()
        .replaceAll('targetSdkVersion: \'${sdkInfo['targetSdkVersion']}\'',
            'targetSdkVersion: \'$targetSdkVersion\'')
        .replaceAll('versionCode: \'${versionInfo['versionCode']}\'',
            'versionCode: \'$versionCode\'')
        .replaceAll('versionName: ${versionInfo['versionName']}',
            'versionName: $versionName')
        .replaceAll('minSdkVersion: \'${sdkInfo['minSdkVersion']}\'',
            'minSdkVersion: \'$minSdkVersion\'');

    file.writeAsStringSync(data);
  }
}

enum YmlInfo {
  minSdkVersion,
  apkFileName,
  targetSdkVersion,
  versionCode,
  versionName,
}
