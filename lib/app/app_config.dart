import 'package:DogApkTools/utils/file_utils.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class AppConfig {
  static String version = 'v1.0.0';
  static String jdkPath = '尚未设置';
  static String toolsPath = '尚未设置';
  static String javaHomeBin = '$jdkPath${FileUtils.getSeparator()}bin';
}

showLoading() {
  EasyLoading.show();
}

showToast(String status) {
  EasyLoading.showToast(status);
}
