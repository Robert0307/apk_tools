import 'dart:developer';

import 'package:DogApkTools/app/app_config.dart';
import 'package:DogApkTools/app/app_data.dart';
import 'package:DogApkTools/app/app_status.dart';
import 'package:DogApkTools/utils/file_utils.dart';
import 'package:get/get.dart';

abstract class AppController<T> extends GetxController with StateMixin<T> {
  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }
}

class AppStatusController extends AppController<AppStatus> {
  final settingStatue = Rx<String>('检查设置');

  @override
  void onInit() {
    super.onInit();
    change(AppStatus(), status: RxStatus.success());
    checkSetting();
  }

  checkToolEnvironment() {
    if (!FileUtils.isDirectory(AppConfig.jdkPath)) {
      settingStatue.value = 'JDK目录设置错误';
      return false;
    } else if (!FileUtils.isDirectory(AppConfig.toolsPath)) {
      settingStatue.value = '工具目录设置错误';
      return false;
    }
    return true;
  }

  Future checkSetting() async {
    log("检查设置");
    await checkConfig();

    if (!FileUtils.isDirectory(AppConfig.jdkPath)) {
      settingStatue.value = 'JDK目录设置错误';
      change(state, status: RxStatus.error(settingStatue.value));
    } else if (!FileUtils.isDirectory(AppConfig.toolsPath)) {
      settingStatue.value = '工具目录设置错误';
      change(state, status: RxStatus.error(settingStatue.value));
    } else {
      settingStatue.value = '准备开车了...';
      change(state, status: RxStatus.success());
    }
    getHomeIndex();
  }

  checkConfig() async {
    await AppData.getConfigPath();
  }

  getHomeIndex() {
    if (status.isError) {
      state!.homeIndex = 2;
    } else {
      state!.homeIndex = 0;
    }
    log('获取索引 ${state!.homeIndex}');
    update();
  }
}
