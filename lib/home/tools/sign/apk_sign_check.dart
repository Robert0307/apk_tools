import 'dart:io';

import 'package:DogApkTools/app/app_config.dart';
import 'package:DogApkTools/home/common/status_callback.dart';
import 'package:DogApkTools/home/common/tools_dialog.dart';
import 'package:DogApkTools/home/item/base_item.dart';
import 'package:DogApkTools/utils/file_utils.dart';
import 'package:DogApkTools/utils/tools_run.dart';
import 'package:DogApkTools/widget/app_tools_back.dart';
import 'package:DogApkTools/widget/tools_button.dart';
import 'package:archive/archive_io.dart';
import 'package:file_selector/file_selector.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class ApkSignCheck extends StatefulWidget {
  @override
  _ApkSignCheckState createState() => _ApkSignCheckState();
}

class _ApkSignCheckState extends State<ApkSignCheck> {
  String checkApk = '点击选择APK文件';
  String msgTxt = '';
  String msgInfo = '签名信息输出目录';

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
            content: checkApk,
            title: '文件',
            dropType: DropType.apk,
            onDragDone: (value) {
              setState(() {
                checkApk = value;
                msgInfo = FileUtils.withoutExtensionFile(checkApk) + ".log";
              });
            },
            onTap: () async {
              final typeGroup = XTypeGroup(label: 'apk', extensions: ['.apk']);
              final file = await openFile(acceptedTypeGroups: [typeGroup]);
              setState(() {
                checkApk = file!.path;
                msgInfo = FileUtils.withoutExtensionFile(checkApk) + ".log";
              });
            },
          ),
          SizedBox(
            height: 20,
          ),
          BaseItem(
            content: msgInfo,
            title: '输出',
            dropType: DropType.file,
            onDragDone: (value) {
              if (!FileUtils.getExtension(checkApk).contains('.apk')) {
                return;
              }
              setState(() {
                msgInfo = value + FileUtils.getSeparator() + FileUtils.getFileNameWithoutExtension(checkApk) + ".log";
              });
            },
            onTap: () async {
              String? file = await FileUtils.getDirPath();
              if (file != null) {
                msgInfo = file + FileUtils.getSeparator() + FileUtils.getFileNameWithoutExtension(checkApk) + ".log";
              }
              setState(() {});
            },
          ),
          SizedBox(
            height: 100,
          ),
          ToolsButton(
            content: '开始查询',
            onPressed: () async {
              if (!checkApk.contains('.apk') || !File(checkApk).existsSync()) {
                EasyLoading.showToast('无效APK');
                return;
              }
              showLoading();

              File formAPKFile = File(checkApk);
              File zipFile = await formAPKFile.copy(formAPKFile.path.replaceAll('.apk', '.zip'));
              final bytes = zipFile.readAsBytesSync();
              final archive = ZipDecoder().decodeBytes(bytes);
              String yjqk = '';

              for (final file in archive) {
                final filename = file.name;
                if (filename.contains('.RSA') && file.isFile) {
                  final data = file.content as List<int>;
                  yjqk = FileUtils.getFilePath(checkApk) + '/' + filename;
                  File(yjqk)
                    ..createSync(recursive: true)
                    ..writeAsBytesSync(data);
                }
              }
              File file = File(yjqk);

              if (file.existsSync()) {
                ToolsRun.getSign(
                    fromFile: yjqk,
                    status: StatusCallback(
                        onSuccess: () {},
                        onResult: (code, msg) {
                          EasyLoading.dismiss();
                          showInfoDialog(context, '提示', '查询成功,点击下方打开文件查看内容');
                          formAPKFile.deleteSync();
                          zipFile.rename(formAPKFile.path.replaceAll('.zip', '.apk'));
                          File(msgInfo).writeAsString(msg);
                          Directory(file.parent.path).deleteSync(recursive: true);
                        },
                        onError: (code) {
                          showInfoDialog(context, '提示', '查询失败');
                        }));
              } else {
                EasyLoading.dismiss();
                showInfoDialog(context, '提示', '查询失败');
              }
            },
          ),
          SizedBox(
            height: 20,
          ),
          TextButton(
              child: Text('打开文件'),
              onPressed: () {
                if (File(msgInfo).existsSync()) {
                  ToolsRun.openFolder(folder: msgInfo);
                } else {
                  showInfoDialog(context, '提示', '查询失败');
                }
              }),
        ],
      ),
    );
  }
}
