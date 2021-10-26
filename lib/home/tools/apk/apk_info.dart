import 'package:DogApkTools/home/common/status_callback.dart';
import 'package:DogApkTools/home/item/base_item.dart';
import 'package:DogApkTools/utils/android_manifest_utils.dart';
import 'package:DogApkTools/utils/tools_run.dart';
import 'package:DogApkTools/widget/app_tools_back.dart';
import 'package:DogApkTools/widget/tool_edit_input.dart';
import 'package:DogApkTools/widget/tool_text_info.dart';
import 'package:file_selector/file_selector.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class ApkInfo extends StatefulWidget {
  @override
  _ApkInfoState createState() => _ApkInfoState();
}

class _ApkInfoState extends State<ApkInfo> {
  String dApk = '点击选择APK文件';
  String appPackNameController = '';
  String appVersionCodeController = '';
  String appVersionNameController = '';
  String targetSdkVersionController = '';
  String minSdkVersionController = '';
  String channelIdController = '';
  String channelVersionController = '';
  String gameIdController = '';
  late Map<String, String> metaData = {};

  @override
  void dispose() {
    super.dispose();
    EasyLoading.dismiss();
  }

  @override
  void initState() {
    super.initState();
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
                checkInfo(value, context);
              });
            },
            onTap: () async {
              final typeGroup = XTypeGroup(label: 'apk', extensions: ['.apk']);
              final file = await openFile(acceptedTypeGroups: [typeGroup]);
              dApk = file!.path;
              setState(() {
                checkInfo(dApk, context);
              });
            },
          ),
          SizedBox(
            height: 20,
          ),
          ToolsTextInfo(
            content: appPackNameController,
            des: '包名',
          ),
          SizedBox(
            height: 10,
          ),
          ToolsTextInfo(
            content: targetSdkVersionController,
            des: '目标版本',
          ),
          SizedBox(
            height: 10,
          ),
          ToolsTextInfo(
            content: minSdkVersionController,
            des: '最低版本',
          ),
          SizedBox(
            height: 10,
          ),
          ToolsTextInfo(
            content: appVersionCodeController,
            des: '版本号',
          ),
          SizedBox(
            height: 10,
          ),
          ToolsTextInfo(
            content: appVersionNameController,
            des: '版本名',
          ),
          SizedBox(
            height: 10,
          ),
          ListTile(
            title: Text('Provider配置(必需检查)'),
            dense: true,
          ),
          SizedBox(
            height: 10,
          ),
          Column(
            children: params(),
          )
        ],
      ),
    );
  }

  void checkInfo(String path, BuildContext context) {
    ToolsRun.apkanalyzers(
        fromApk: path,
        status: StatusCallback(
            onSuccess: () {},
            onError: (code) {},
            onResult: (code, msg) {
              channelVersionController =
                  AndroidManifestUtils.inquireInfo(AndroidManifestInfo.channelVersion, haContent: true, content: msg);
              appPackNameController =
                  AndroidManifestUtils.inquireInfo(AndroidManifestInfo.package, haContent: true, content: msg);
              minSdkVersionController =
                  AndroidManifestUtils.inquireInfo(AndroidManifestInfo.usesSdk, haContent: true, content: msg);
              targetSdkVersionController =
                  AndroidManifestUtils.inquireInfo(AndroidManifestInfo.targetSdkVersion, haContent: true, content: msg);

              appVersionCodeController =
                  AndroidManifestUtils.inquireInfo(AndroidManifestInfo.versionCode, haContent: true, content: msg);

              appVersionNameController =
                  AndroidManifestUtils.inquireInfo(AndroidManifestInfo.versionName, haContent: true, content: msg);
              metaData = AndroidManifestUtils.inquireInfo(AndroidManifestInfo.metaDatas, haContent: true, content: msg);
              setState(() {});
            }));
  }

  List<Widget> params() {
    List<Widget> widget = [];
    metaData.forEach((key, value) {
      widget.add(Padding(
        padding: EdgeInsets.only(top: 10),
        child: ToolEditInput(
          labelText: key,
          controller: TextEditingController(text: value),
        ),
      ));
    });

    return widget;
  }
}
