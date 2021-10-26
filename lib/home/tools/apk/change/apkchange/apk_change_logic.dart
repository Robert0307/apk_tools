import 'dart:developer';
import 'dart:io';

import 'package:DogApkTools/app/app_config.dart';
import 'package:DogApkTools/home/common/status_callback.dart';
import 'package:DogApkTools/home/tools/module/sign.dart';
import 'package:DogApkTools/home/tools/tools_config.dart';
import 'package:DogApkTools/utils/android_manifest_utils.dart';
import 'package:DogApkTools/utils/file_utils.dart';
import 'package:DogApkTools/utils/tools_run.dart';
import 'package:DogApkTools/utils/yml_utils.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

import 'apk_change_state.dart';

class ApkChangeLogic extends GetxController {
  final ApkChangeState state = ApkChangeState();
  bool isNext = false;

  @override
  void onInit() {
    super.onInit();
    getSignConfig();
  }

  ///选择APK
  selectApk(String fromApk) {
    state.fromApk = fromApk;
    state.outPath = FileUtils.withoutExtensionFile(fromApk);
    state.taskStatus = TaskStatus.init;
    isNext = false;
    update();
  }

  ///开始反编译
  decompile() {
    if (state.fromApk.contains('.apk') && FileUtils.isFile(state.fromApk)) {
      EasyLoading.show();
      ToolsRun.decompiling(
          fromApk: state.fromApk,
          outputApk: state.outPath,
          status: StatusCallback(
              onSuccess: () {
                checkConfig();
              },
              onError: (code) {},
              onResult: (code, msg) {
                EasyLoading.dismiss();
              }));
    }
  }

  ///检查包体配置
  checkConfig() {
    state.appName = AndroidManifestUtils.inquireInfo(
      AndroidManifestInfo.label,
      fileName: state.outPath,
    );

    state.appPackName = AndroidManifestUtils.inquireInfo(
      AndroidManifestInfo.package,
      fileName: state.outPath,
    );
    state.appVersionCode = YmlUtils.inquireInfo(state.outPath, YmlInfo.versionCode);
    state.appVersionName = YmlUtils.inquireInfo(state.outPath, YmlInfo.versionName);
    state.targetSdkVersion = YmlUtils.inquireInfo(state.outPath, YmlInfo.targetSdkVersion);
    state.minSdkVersion = YmlUtils.inquireInfo(state.outPath, YmlInfo.minSdkVersion);
    isNext = true;
    checkParamsConfig();
  }

  ///修改包体配置
  bool changeConfig() {
    if (!state.appPackName.contains('.')) {
      EasyLoading.showToast('包名不合法');
      return false;
    }
    try {
      int target = int.parse(state.targetSdkVersion);
      if (target > 29) {
        EasyLoading.showToast('目标版本最高29');
        return false;
      }
    } catch (value) {
      EasyLoading.showToast('目标版本不合法,建议26');
      return false;
    }

    try {
      int min = int.parse(state.minSdkVersion);
      int target = int.parse(state.targetSdkVersion);

      if (target <= min) {
        EasyLoading.showToast('最低版必须小于目标版本');
        return false;
      }
    } catch (value) {
      EasyLoading.showToast('最低版本不合法,建议19');
      return false;
    }

    try {
      int version = int.parse(state.appVersionCode);
    } catch (value) {
      EasyLoading.showToast('版本号不合法 必须为数字');
      return false;
    }
    AndroidManifestUtils.change(state.outPath,
        metaDatas: state.metaDatas, label: state.appName, package: state.appPackName);

    YmlUtils.change(state.outPath,
        minSdkVersion: state.minSdkVersion,
        targetSdkVersion: state.targetSdkVersion,
        versionCode: state.appVersionCode,
        versionName: state.appVersionName);

    return true;
  }

  ///获取icon
  checkIcon() {
    String iconPath = AndroidManifestUtils.inquireInfo(
      AndroidManifestInfo.icon,
      fileName: state.outPath,
    );

    String ptah = iconPath.substring(1, iconPath.indexOf('/'));
    String iconName = iconPath.substring(iconPath.indexOf('/') + 1, iconPath.length);

    List<String> ptahDip = [];

    Directory('${state.outPath}/res').listSync().forEach((element) {
      if (FileUtils.isDirectory(element.path) && element.path.contains(ptah)) {
        ptahDip.add(element.path);
      }
    });

    ptahDip.forEach((element) {
      if (FileUtils.isFile(element + '/$iconName.png')) {
        state.exitIcon.add(element + '/$iconName.png');
      }
    });
    //比较icon大小
    state.icon = state.exitIcon[state.exitIcon.length - 1];
    update();
  }

  ///修改icon
  changeIcon(String icon) async {
    log(icon);
    state.icon = icon;
    state.changeIcon = icon;
    update();
    state.exitIcon.forEach((element) async {
      await File(icon).copy(element);
    });
    state.icon = state.exitIcon[state.exitIcon.length - 1];
    log(state.icon);
    update();
  }

  ///检查参数配置
  checkParamsConfig() {
    state.metaDatas = AndroidManifestUtils.inquireInfo(
      AndroidManifestInfo.metaDatas,
      fileName: state.outPath,
    );
    checkIcon();
  }

  ///修改参数配置
  changeParamsConfig(Map<String, String> metaDatas, Map<String, String> providers, {required StatusCallback callback}) {
    state.metaDatas = metaDatas;
    AndroidManifestUtils.change(state.outPath, metaDatas: metaDatas);
    outApk(callback: callback);
  }

  ///获取签名配置
  getSignConfig({Sign? sign}) {
    if (signModule().sign.length > 0) {
      state.selectSign = sign ?? signModule().sign[0];
      state.selectSignTip = FileUtils.getFileName(signModule().sign[0].storeFile);
    } else {
      state.selectSignTip = '选择签名';
    }
  }

  ///输出APK
  outApk({required StatusCallback callback}) {
    showLoading();
    String outApk = state.fromApk.replaceAll(".apk", '_temp.apk');
    ToolsRun.compile(
        fromPath: state.outPath,
        outputApk: outApk,
        status: StatusCallback(onSuccess: () {
          showToast('回编译成功');
          signAPK(outApk, callback: callback);
        }, onError: (code) {
          EasyLoading.dismiss();
          callback.onError(code);
        }, onResult: (code, msg) {
          EasyLoading.dismiss();
        }));
  }

  ///签名APK
  signAPK(String fromApk, {required StatusCallback callback}) {
    if (state.selectSign == null) {
      EasyLoading.dismiss(animation: true);
      callback.onError(-2);
      return;
    }
    if (!File(state.selectSign!.storeFile).existsSync()) {
      EasyLoading.dismiss(animation: true);
      callback.onError(-2);
      return;
    }
    ToolsRun.sign(
        fromApk: fromApk,
        outputApk: fromApk.replaceAll("_temp.apk", '_release.apk'),
        signFile: state.selectSign!.storeFile,
        pass: state.selectSign!.storePassword,
        aliasPass: state.selectSign!.keyPassword,
        alias: state.selectSign!.keyAlias,
        v2Enabled: state.selectSign!.v2Enabled,
        status: StatusCallback(onSuccess: () {
          File(fromApk).deleteSync();
          callback.onSuccess();
        }, onError: (code) {
          callback.onError(code);
        }, onResult: (code, msg) {
          EasyLoading.dismiss();
        }));
  }

  ///打开APK输出文件夹
  openOutApkDir() {}
}
