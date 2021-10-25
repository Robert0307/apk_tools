import 'dart:io';
import 'package:props/props.dart';

class YzxConfigUtils {
  static String? inquireInfo(String fileName, YzxConfig info) {
    File file = File('$fileName/assets/yzx_config.properties');

    if (!file.existsSync()) {
      file.createSync(recursive: true);
    }
    final props = Properties.loadString(file.readAsStringSync());

    if (info == YzxConfig.isDebug) {
      return props['IS_DEBUG'];
    }
    if (info == YzxConfig.yzxChannelId) {
      return props['YZX_CHANNELID'];
    }
    if (info == YzxConfig.yzxGameId) {
      return props['YZX_GAME_ID'];
    }

    if (info == YzxConfig.sdkVer) {
      return props['SDK_VER'] ?? '103';
    }
    if (info == YzxConfig.privacy) {
      return props['PRIVACY'] ?? 'false';
    }
    return "";
  }

  static Future<void> change(String fileName,
      {String isDebug = 'false',
      String yzxChannelId = '1000',
      String yzxGameId = '1000',
      String sdkVer = '103',
      String privacy = 'false'}) async {
    File file = File('$fileName/assets/yzx_config.properties');

    if (!file.existsSync()) {
      file.createSync(recursive: true);
    }

    String newData = '''
IS_DEBUG=f
YZX_GAME_ID=$yzxGameId
YZX_CHANNELID=$yzxChannelId
SDK_VER=${sdkVer == '111' ? sdkVer : '103'}
PRIVACY=$privacy
    ''';

    file.writeAsString(newData);
  }

  static change2(String fileName,
      {String? isDebug,
      String? yzxChannelId,
      String? yzxGameId,
      String? sdkVer,
      bool? useOne,
      bool usePrivacy = false}) async {
    File file = File('$fileName/assets/yzx_config.properties');

    if (!file.existsSync()) {
      await file.create();
    } else {
      await file.delete();
      await file.create();
    }
    String newData = '''
IS_DEBUG=f
YZX_GAME_ID=$yzxGameId
YZX_CHANNELID=$yzxChannelId
SDK_VER=${useOne! ? '111' : '103'}
PRIVACY=$usePrivacy
    ''';

    file.writeAsString(newData);
  }
}

enum YzxConfig { isDebug, yzxGameId, yzxChannelId, sdkVer, privacy }
