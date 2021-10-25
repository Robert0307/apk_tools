import 'dart:developer';

import 'package:DogApkTools/app/app_config.dart';
import 'package:DogApkTools/home/common/status_callback.dart';
import 'package:DogApkTools/home/common/tools_dialog.dart';
import 'package:DogApkTools/home/item/base_item.dart';
import 'package:DogApkTools/utils/file_utils.dart';
import 'package:DogApkTools/utils/tools_run.dart';
import 'package:DogApkTools/widget/app_tools_back.dart';
import 'package:DogApkTools/widget/tools_button.dart';
import 'package:file_selector/file_selector.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class ApkToolD extends StatefulWidget {
  @override
  _ApkToolDState createState() => _ApkToolDState();
}

class _ApkToolDState extends State<ApkToolD> {
  String dApk = '点击选择APK文件';
  String dApkFile = '反编译文件夹输出目录';

  String outName = '';
  String status = '';

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppToolsBack(
      child: Column(
        children: [
          BaseItem(
            content: dApk,
            title: '文件',
            dropType: DropType.apk,
            onDragDone: (value) {
              setState(() {
                dApk = value;
                dApkFile = FileUtils.withoutExtensionFile(dApk);
              });
            },
            onTap: () async {
              final typeGroup = XTypeGroup(label: 'apk', extensions: ['.apk']);
              final file = await openFile(acceptedTypeGroups: [typeGroup]);
              if (file != null) {
                setState(() {
                  dApk = file.path;
                  dApkFile = FileUtils.withoutExtensionFile(dApk);
                });
              }
            },
          ),
          SizedBox(
            height: 20,
          ),
          BaseItem(
            content: dApkFile,
            title: '输出',
            dropType: DropType.file,
            onDragDone: (value) {
              if (!FileUtils.getExtension(dApk).contains('.apk')) {
                return;
              }
              setState(() {
                dApkFile = value + FileUtils.getSeparator() + FileUtils.getFileNameWithoutExtension(dApk);
              });
            },
            onTap: () async {
              final file = await FileUtils.getDirPath();
              if (file != null) {
                setState(() {
                  dApkFile = file + FileUtils.getSeparator() + FileUtils.getFileNameWithoutExtension(dApk);
                });
              }
            },
          ),
          SizedBox(
            height: 100,
          ),
          ToolsButton(
            content: '开始反编译',
            onPressed: () async {
              log('开始反编译 ${AppConfig.toolsPath}');
              if (!dApk.contains('.apk')) {
                EasyLoading.showToast('无效APK');
                return;
              }
              showLoading();
              await ToolsRun.decompiling(
                  fromApk: dApk,
                  outputApk: dApkFile,
                  status: StatusCallback(onSuccess: () {
                    showInfoDialog(context, '提示', '反编译成功');
                  }, onError: (code) {
                    setState(() {
                      EasyLoading.showToast('反编译失败,确保APK名字无特殊符号');
                    });
                  }, onResult: (code, msg) {
                    EasyLoading.dismiss(animation: true);
                  }));

              setState(() {});
            },
          ),
          SizedBox(
            height: 20,
          ),
          TextButton(
              child: Text('打开输出目录'),
              onPressed: () {
                if (dApkFile != '反编译文件夹输出目录') {
                  ToolsRun.openFolder(folder: dApkFile);
                }
              }),
        ],
      ),
    );
  }
}
