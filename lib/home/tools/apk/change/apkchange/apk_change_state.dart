import 'package:DogApkTools/home/tools/module/sign.dart';

class ApkChangeState {
  String fromApk = '选择APK';
  String outPath = '';
  TaskStatus taskStatus = TaskStatus.init;
  List<String> exitIcon = [];
  String appName = '';
  String appPackName = '';
  String appVersionCode = '';
  String appVersionName = '';
  String targetSdkVersion = '';
  String minSdkVersion = '';
  String icon = '';
  String changeIcon = '';

  String selectSignTip = '';
  Sign? selectSign;
  List<String> soDirectory = [];

  Map<String, String> metaDatas = {};

  List<String> configsKeys = [
    'APP名',
    '包名',
    '目标版本',
    '最低版本',
    '版本号',
    '版本名',
  ];
}

enum TaskStatus { init, laodConfig, loading, success, error, finish, refresh, outLoading, outError, outSuccess }
