import 'dart:io';

import 'package:DogApkTools/app/app_config.dart';
import 'package:DogApkTools/app/app_data.dart';
import 'package:DogApkTools/app/app_status_controller.dart';
import 'package:DogApkTools/home/item/base_item.dart';
import 'package:DogApkTools/home/setting/setting_select_path_page.dart';
import 'package:DogApkTools/utils/file_utils.dart';
import 'package:DogApkTools/widget/log.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({Key? key}) : super(key: key);

  @override
  _SettingPageState createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: kToolbarHeight * 1.5,
        leading: CloseButton(
          color: Colors.blue,
        ),
        title: Text(
          '环境设置',
          style: TextStyle(
            fontSize: 28,
            color: Colors.blue,
            shadows: <Shadow>[
              Shadow(
                offset: Offset(6.0, 6.0),
                blurRadius: 4.0,
                color: Colors.blue.withOpacity(0.1),
              ),
            ],
          ),
        ),
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 40),
        height: double.infinity,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Log(log: '设置以下目录工具才可以正常工作,如有疑问,请联系技术支持人员'),
              SizedBox(
                height: 10,
              ),
              BaseItem(
                title: '设置JDK目录',
                content: AppConfig.jdkPath,
                onTap: () => showSelect(0),
              ),
              SizedBox(
                height: 10,
              ),
              BaseItem(
                title: '设置工具目录',
                content: AppConfig.toolsPath,
                onTap: () => showSelect(1),
              ),
              SizedBox(
                height: 10,
              ),
              BaseItem(
                title: '当前电脑环境',
                content: Platform.isMacOS ? "MacOS" : "Windows",
                onTap: () => EasyLoading.showToast('当前电脑环境 ${Platform.isMacOS ? "MacOS" : "Windows"}'),
              ),
              SizedBox(
                height: 10,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // 0 jdk
  showSelect(int type) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              elevation: 0,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              content: SettingSelectPathPage(
                content: getContent(type),
                path: (path) {
                  setState(() {
                    switch (type) {
                      case 0:
                        AppConfig.jdkPath = path;
                        AppConfig.javaHomeBin = '${AppConfig.jdkPath}${FileUtils.getSeparator()}bin';
                        AppData.setConfigPath(0, path);
                        break;

                      case 1:
                        if (isChinese(path)) {
                          showToast('不能包含中文路径');
                        } else {
                          AppConfig.toolsPath = path;
                          AppData.setConfigPath(1, path);
                        }

                        break;
                    }

                    final logic = Get.find<AppStatusController>();
                    logic.checkSetting();
                  });
                },
              ),
            ));
  }

  final String CHINESE_REGEX = "[\u4e00-\u9fa5]";

  // 是否包含中文
  bool isChinese(String input) {
    if (input.isEmpty) return false;
    return new RegExp(CHINESE_REGEX).hasMatch(input);
  }

  getContent(int type) {
    switch (type) {
      case 0:
        return AppConfig.jdkPath.contains('设置') ? '选择目录' : AppConfig.jdkPath;
      case 1:
        return AppConfig.toolsPath.contains('设置') ? '选择目录' : AppConfig.toolsPath;
    }
  }
}
