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
import 'package:file_selector/file_selector.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class ApkZipalign extends StatefulWidget {
  @override
  _ApkZipalignState createState() => _ApkZipalignState();
}

class _ApkZipalignState extends State<ApkZipalign> {
  String zApk = '点击选择APK文件';
  String zOutApk = '输出文件';
  String signFile = '点击选择签名';
  Sign? selectSign;

  @override
  void initState() {
    super.initState();
    if (signModule().sign.length > 0) {
      selectSign = signModule().sign[0];
      signFile = FileUtils.getFileName(selectSign!.storeFile);
    }
  }

  @override
  void dispose() {
    super.dispose();
    EasyLoading.dismiss();
  }

  @override
  Widget build(BuildContext context) {
    return AppToolsBack(
      child: Column(
        children: [
          BaseItem(
            content: zApk,
            title: '文件',
            dropType: DropType.apk,
            onDragDone: (value) {
              setState(() {
                zApk = value;
                zOutApk = zApk.replaceAll('.apk', '_zipalign.apk');
              });
            },
            onTap: () async {
              final typeGroup = XTypeGroup(label: 'apk', extensions: ['.apk']);
              final file = await openFile(acceptedTypeGroups: [typeGroup]);
              setState(() {
                zApk = file!.path;
                zOutApk = zApk.replaceAll('.apk', '_zipalign.apk');
              });
            },
          ),
          SizedBox(
            height: 20,
          ),
          BaseItem(
            content: zOutApk,
            title: '输出',
            dropType: DropType.file,
            onDragDone: (value) {
              if (!FileUtils.getExtension(zApk).contains('.apk')) {
                return;
              }
              setState(() {
                zOutApk = value + FileUtils.getSeparator() + FileUtils.getFileNameWithoutExtension(zApk) + '.apk';
              });
            },
            onTap: () async {
              zOutApk = (await FileUtils.getDirPath())!;
              zOutApk = zOutApk + FileUtils.getSeparator() + FileUtils.getFileNameWithoutExtension(zApk) + '.apk';
              setState(() {});
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
            content: '开始对齐',
            onPressed: () async {
              if (!zApk.contains('.apk')) {
                EasyLoading.showToast('无效APK');
                return;
              }
              showLoading();
              await ToolsRun.zipalign(
                  fromApk: zApk,
                  outputApk: zOutApk,
                  status: StatusCallback(onSuccess: () {
                    sign(zOutApk, zOutApk.replaceAll('.apk', '_release.apk'));
                  }, onError: (code) {
                    showInfoDialog(context, '提示', '对齐失败');
                  }, onResult: (code, msg) {
                    EasyLoading.dismiss();
                  }));
            },
          ),
          SizedBox(
            height: 20,
          ),
          TextButton(
              child: Text('打开输出目录'),
              onPressed: () {
                if (File(zOutApk).existsSync()) {
                  ToolsRun.openFolder(folder: zOutApk);
                }
              }),
        ],
      ),
    );
  }

  sign(String fromApk, String outputApk) {
    if (selectSign == null) {
      showInfoDialog(context, '提示', '对齐成功!\n 未选择签名文件,没进行签名');
      return;
    }

    if (!File(selectSign!.storeFile).existsSync()) {
      showInfoDialog(context, '提示', '对齐成功! \n配置文件签名不存在');
      return;
    }
    showLoading();
    ToolsRun.sign(
        fromApk: fromApk,
        outputApk: outputApk,
        signFile: selectSign!.storeFile,
        pass: selectSign!.storePassword,
        aliasPass: selectSign!.keyPassword,
        alias: selectSign!.keyAlias,
        v2Enabled: selectSign!.v2Enabled,
        status: new StatusCallback(onSuccess: () {
          File(zOutApk).deleteSync();
          showInfoDialog(context, '提示', '对齐并签名成功');
        }, onError: (code) {
          showInfoDialog(context, '提示', '签名失败');
        }, onResult: (code, msg) {
          EasyLoading.dismiss(animation: true);
        }));
  }
}
