import 'dart:io';

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

class ApkDexToJar extends StatefulWidget {
  @override
  _ApkDexToJarState createState() => _ApkDexToJarState();
}

class _ApkDexToJarState extends State<ApkDexToJar> {
  String formApk = '点击选择APK文件';
  String zOutJar = '输出文件';

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
            content: formApk,
            title: '文件',
            dropType: DropType.apk,
            onDragDone: (value) {
              setState(() {
                formApk = value;
                zOutJar = formApk.replaceAll('.apk', '.jar');
              });
            },
            onTap: () async {
              final typeGroup = XTypeGroup(label: 'apk', extensions: ['.apk']);
              final file = await openFile(acceptedTypeGroups: [typeGroup]);
              setState(() {
                formApk = file!.path;
                zOutJar = formApk.replaceAll('.apk', '.jar');
              });
            },
          ),
          SizedBox(
            height: 20,
          ),
          BaseItem(
            content: zOutJar,
            title: '输出',
            dropType: DropType.file,
            onDragDone: (value) {
              if (!FileUtils.getExtension(formApk).contains('.apk')) {
                return;
              }
              setState(() {
                zOutJar = value + FileUtils.getSeparator() + FileUtils.getFileNameWithoutExtension(formApk) + '.jar';
              });
            },
            onTap: () async {
              zOutJar = (await FileUtils.getDirPath())!;
              zOutJar = zOutJar + FileUtils.getSeparator() + FileUtils.getFileNameWithoutExtension(formApk) + '.jar';

              setState(() {});
            },
          ),
          SizedBox(
            height: 100,
          ),
          ToolsButton(
            content: '开始提取',
            onPressed: () async {
              if (!File(formApk).existsSync()) {
                EasyLoading.showToast('无效APK');
                return;
              }
              showLoading();
              await ToolsRun.dexToJar(
                  fromApk: formApk,
                  outJar: zOutJar,
                  status: StatusCallback(onSuccess: () {
                    EasyLoading.dismiss();

                    showInfoDialog(context, '提示', 'jar提取成功');
                  }, onError: (code) {
                    EasyLoading.dismiss();

                    showInfoDialog(context, '提示', 'jar提取失败');
                  }, onResult: (code, msg) {
                    EasyLoading.dismiss();
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
                if (File(zOutJar).existsSync()) {
                  ToolsRun.openFolder(folder: FileUtils.getFilePath(zOutJar));
                }
              }),
        ],
      ),
    );
  }
}
