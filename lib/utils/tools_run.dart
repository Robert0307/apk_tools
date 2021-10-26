import 'package:DogApkTools/home/common/status_callback.dart';
import 'package:DogApkTools/utils/run/apktool_run.dart';
import 'package:DogApkTools/utils/run/file_run.dart';

class ToolsRun {
  ///打开文件夹
  static void openFolder({required String folder}) {
    FileRun.openFolder(folder);
  }

  ///反编编译
  static Future<void> decompiling(
      {required String fromApk, required String outputApk, required StatusCallback status}) async {
    return ApkToolRun.decompiling(fromApk: fromApk, outputApk: outputApk, status: status);
  }

  ///回编译
  static compile({required String fromPath, required String outputApk, required StatusCallback status}) {
    ApkToolRun.compile(outputApk: outputApk, fromPath: fromPath, status: status);
  }

  ///签名APK
  static Future<void> sign(
      {required String fromApk,
      required String outputApk,
      required String signFile,
      required String pass,
      required String aliasPass,
      required String alias,
      required bool v2Enabled,
      required StatusCallback status}) {
    return ApkToolRun.sign(
        status: status,
        fromApk: fromApk,
        outputApk: outputApk,
        signFile: signFile,
        alias: alias,
        aliasPass: aliasPass,
        pass: pass,
        v2Enabled: v2Enabled);
  }

  ///获取签名信息
  static Future<void> getSign({required String fromFile, required StatusCallback status}) {
    return ApkToolRun.getSign(status: status, filePath: fromFile);
  }

  ///对齐
  static zipalign({required String fromApk, required String outputApk, required StatusCallback status}) {
    ApkToolRun.zipalign(outputApk: outputApk, fromApk: fromApk, status: status);
  }

  ///dex转jar
  static Future<void> dexToJar(
      {required String fromApk, required String outJar, required StatusCallback status}) async {
    return ApkToolRun.dex2Jar(status: status, fromApk: fromApk, outputJar: outJar);
  }

  ///检查APK AndroidManifest
  static Future<void> apkAnalyzers({required String fromApk, required StatusCallback status}) async {
    return ApkToolRun.apkanalyzers(fromApk: fromApk, status: status);
  }
}
