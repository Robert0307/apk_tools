import 'dart:developer';
import 'dart:io';

import 'package:DogApkTools/app/app_status_controller.dart';
import 'package:get/get.dart';

class AppSplashController extends AppController {
  //局部响应式刷新 obs 等于就是一个被观察者
  //响应式的不需要去update 每次更改都自动刷新

  final platform = Rx<String>('');

  final launchStatus = Rx<String>('启动中');

  bool isOnline = true;

  final AppStatusController logic = Get.put(AppStatusController());

  //局部更新
  //获取当前操作系统的应用安装地址
  String? platformPath;

  //获取操作平台
  getPlatformPath() {
    if (Platform.isMacOS) {
      platform.value = 'MacOS';
    } else if (Platform.isWindows) {
      platform.value = 'Windows';
    } else {
      platform.value = '暂不支持';
    }
  }

  checkEnvironment() {
    launchStatus.value = '开始检测环境';
    checkSetting();
  }

  checkSetting() {
    launchStatus.value = logic.settingStatue.value;

    logic.checkSetting().whenComplete(() {
      launchStatus.value = logic.settingStatue.value;
    });
  }

  @override
  void onInit() {
    super.onInit();
    log('初始化');
    getPlatformPath();
    launchStatus.value = '初始化中...';
    checkEnvironment();
  }

  @override
  void onReady() {
    super.onReady();
    log('准备');
  }

  @override
  void onClose() {
    super.onClose();
    log('关闭');
  }
}
