import 'dart:io';

import 'package:DogApkTools/app/app_config.dart';
import 'package:DogApkTools/home/common/status_callback.dart';
import 'package:DogApkTools/home/common/tools_dialog.dart';
import 'package:DogApkTools/home/item/base_item.dart';
import 'package:DogApkTools/home/tools/module/sign.dart';
import 'package:DogApkTools/home/tools/tools_config.dart';
import 'package:DogApkTools/utils/file_utils.dart';
import 'package:DogApkTools/utils/tools_run.dart';
import 'package:DogApkTools/widget/app_tools_back.dart';
import 'package:DogApkTools/widget/tools_button.dart';
import 'package:DogApkTools/widget/tools_select_sign_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class ApkToolB extends StatefulWidget {
  @override
  _ApkToolBState createState() => _ApkToolBState();
}

class _ApkToolBState extends State<ApkToolB> {
  String bApkFile = '点击选择文件夹';
  String outApk = '反编译APK输出目录';
  String signFile = '点击选择签名';
  String status = '';
  Sign? selectSign;

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    if (signModule().sign.length > 0) {
      selectSign = signModule().sign[0];
      signFile = FileUtils.getFileName(selectSign!.storeFile);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppToolsBack(
      child: Column(
        children: [
          BaseItem(
            content: bApkFile,
            title: '文件',
            dropType: DropType.file,
            onDragDone: (value) {
              setState(() {
                bApkFile = value;
                outApk = '$bApkFile.apk';
              });
            },
            onTap: () async {
              var path = await FileUtils.getDirPath();
              if (path != null) {
                setState(() {
                  bApkFile = path;
                  outApk = '$bApkFile.apk';
                });
              }
            },
          ),
          SizedBox(
            height: 20,
          ),
          BaseItem(
            content: outApk,
            title: '输出',
            dropType: DropType.file,
            onDragDone: (value) {
              if (bApkFile.contains('点击选择文件夹')) {
                return;
              }
              setState(() {
                outApk = value;
                outApk = '$outApk.apk';
              });
            },
            onTap: () async {
              var path = await FileUtils.getDirPath();
              if (path != null) {
                setState(() {
                  outApk = path;
                  outApk = '$outApk.apk';
                });
              }
            },
          ),
          SizedBox(
            height: 20,
          ),
          BaseItem(
            content: signFile,
            title: '签名',
            onTap: () async {
              showSignDialog(context, select: (module) {
                signFile = FileUtils.getFileName(module.storeFile);
                setState(() {
                  selectSign = module;
                });
              });
            },
          ),
          SizedBox(
            height: 100,
          ),
          ToolsButton(
            content: '开始回编译',
            onPressed: () async {
              Directory dir = Directory(bApkFile);
              if (!dir.existsSync()) {
                EasyLoading.showToast('无效文件夹');

                return;
              }
              showLoading();
              await ToolsRun.compile(
                  fromPath: bApkFile,
                  outputApk: outApk,
                  status: StatusCallback(
                      onSuccess: () {
                        sign(outApk, outApk.replaceAll('.apk', '_release.apk'));
                      },
                      onError: (code) {
                        EasyLoading.dismiss(animation: true);
                        showInfoDialog(context, '提示', '回编译失败,检查是否有效文件夹');
                      },
                      onResult: (code, msg) {}));
            },
          ),
          SizedBox(
            height: 20,
          ),
          TextButton(
              child: Text('打开输出目录'),
              onPressed: () {
                ToolsRun.openFolder(folder: FileUtils.getFilePath(outApk));
              }),
        ],
      ),
    );
  }

  sign(String fromApk, String outputApk) {
    if (selectSign == null) {
      EasyLoading.dismiss(animation: true);
      showInfoDialog(context, '提示', '回编译成功,签名失败\n未选择签名文件');
      return;
    }

    if (!File(selectSign!.storeFile).existsSync()) {
      EasyLoading.dismiss(animation: true);
      showInfoDialog(context, '提示', '回编译成功,签名失败\n配置文件签名不存在\n${selectSign!.storeFile}');
      return;
    }

    ToolsRun.sign(
        fromApk: fromApk,
        outputApk: outputApk,
        status: new StatusCallback(onSuccess: () {
          showInfoDialog(context, '提示', '回编译并签名成功');
          File(fromApk).deleteSync();
        }, onError: (code) {
          showInfoDialog(context, '提示', '签名失败');
        }, onResult: (code, msg) {
          EasyLoading.dismiss(animation: true);
        }),
        v2Enabled: false,
        alias: selectSign!.keyAlias,
        signFile: selectSign!.storeFile,
        aliasPass: selectSign!.keyPassword,
        pass: selectSign!.storePassword);
  }
}
