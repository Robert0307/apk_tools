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

class ApkToolSign extends StatefulWidget {
  @override
  _ApkToolSignState createState() => _ApkToolSignState();
}

class _ApkToolSignState extends State<ApkToolSign> {
  String signApk = '选择APK';
  String signFile = '点击选择签名';
  Sign? selectSign;

  String outApk = '输出APK';

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
  }

  @override
  Widget build(BuildContext context) {
    return AppToolsBack(
      child: Column(
        children: [
          BaseItem(
            content: signApk,
            title: 'APK',
            dropType: DropType.apk,
            onDragDone: (value) {
              setState(() {
                signApk = value;
                outApk = signApk.replaceAll('.apk', '_release.apk');
              });
            },
            onTap: () async {
              final typeGroup = XTypeGroup(label: 'apk', extensions: ['.apk']);
              final file = await openFile(acceptedTypeGroups: [typeGroup]);
              setState(() {
                signApk = file!.path;
                outApk = signApk.replaceAll('.apk', '_release.apk');
              });
            },
          ),
          SizedBox(
            height: 10,
          ),
          BaseItem(
            content: outApk,
            title: '输出',
            dropType: DropType.file,
            onDragDone: (value) {
              if (!FileUtils.getExtension(signApk).contains('.apk')) {
                return;
              }
              setState(() {
                outApk = '$value${FileUtils.getSeparator()}${FileUtils.getFileName(signApk)}'
                    .replaceAll('.apk', '_release.apk');
              });
            },
            onTap: () async {
              outApk = (await FileUtils.getDirPath())!;
              setState(() {
                outApk = '$outApk${FileUtils.getSeparator()}${FileUtils.getFileName(signApk)}'
                    .replaceAll('.apk', '_release.apk');
              });
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
            content: '开始签名',
            onPressed: () async {
              if (!signApk.contains('.apk')) {
                EasyLoading.showToast('无效APK');
                return;
              }

              if (selectSign == null) {
                EasyLoading.showToast('未选择签名文件');
                return;
              }

              if (!File(selectSign!.storeFile).existsSync()) {
                showInfoDialog(context, '提示', '配置文件签名不存在,请检查签名配置文件\n ${selectSign!.storeFile}');
                return;
              }
              showLoading();
              ToolsRun.sign(
                  fromApk: signApk,
                  outputApk: outApk,
                  signFile: selectSign!.storeFile,
                  pass: selectSign!.storePassword,
                  aliasPass: selectSign!.keyPassword,
                  alias: selectSign!.keyAlias,
                  v2Enabled: selectSign!.v2Enabled,
                  status: StatusCallback(onSuccess: () {
                    showInfoDialog(context, '提示', '签名成功');
                  }, onError: (code) {
                    EasyLoading.dismiss();

                    showInfoDialog(context, '提示', '签名失败');
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
                ToolsRun.openFolder(folder: FileUtils.getFilePath(outApk));
              }),
        ],
      ),
    );
  }
}
