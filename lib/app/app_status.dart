class AppStatus {
  SettingStatus settingStatus = SettingStatus.checking;
  int homeIndex = 0;
}

enum SettingStatus { checking, jdkPathErr, toolsPathErr, success }
