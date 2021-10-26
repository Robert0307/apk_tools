import 'dart:io';

import 'package:DogApkTools/home/item/base_item.dart';
import 'package:DogApkTools/home/tools/apk/change/apkchange/apk_change_next_view.dart';
import 'package:DogApkTools/home/tools/apk/change/apkchange/apk_change_state.dart';
import 'package:DogApkTools/widget/app_tools_back.dart';
import 'package:DogApkTools/widget/tool_edit_input.dart';
import 'package:DogApkTools/widget/tools_button.dart';
import 'package:file_selector/file_selector.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'apk_change_logic.dart';

class ApkChangePage extends StatelessWidget {
  ApkChangeState _pageState = Get.put(ApkChangeLogic()).state;

  //获取参数配置
  Map<String, TextEditingController> _configsValue = {};

  @override
  Widget build(BuildContext context) {
    _initConfigValue();
    return AppToolsBack(child: GetBuilder<ApkChangeLogic>(builder: (controller) {
      _pageState = controller.state;
      return Container(
        width: double.infinity,
        child: Column(
          children: [
            BaseItem(
              content: _pageState.fromApk,
              title: '文件',
              dropType: DropType.apk,
              onDragDone: (value) {
                controller.selectApk(value);
              },
              onTap: () async {
                final typeGroup = XTypeGroup(label: 'apk', extensions: ['.apk']);
                final file = await openFile(acceptedTypeGroups: [typeGroup]);
                if (file != null) {
                  controller.selectApk(file.path);
                }
              },
            ),
            SizedBox(
              height: 20,
            ),
            Visibility(
              visible: _pageState.icon.contains('.png'),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  InkWell(
                    child: Image.file(
                      File(
                        _pageState.changeIcon == '' ? _pageState.icon : _pageState.changeIcon,
                      ),
                      filterQuality: FilterQuality.high,
                      width: 140,
                    ),
                    onTap: () async {
                      final typeGroup = XTypeGroup(label: 'png', extensions: ['.png']);
                      final file = await openFile(acceptedTypeGroups: [typeGroup]);
                      if (file != null) {
                        controller.changeIcon(file.path);
                      }
                    },
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Expanded(
                      child: GridView.builder(
                          shrinkWrap: true,
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2, crossAxisSpacing: 10, mainAxisSpacing: 10, childAspectRatio: 3),
                          itemCount: _pageState.configsKeys.length,
                          itemBuilder: (context, index) {
                            addChange();
                            return _itemBuilder(context, index);
                          }))
                ],
              ),
            ),
            SizedBox(height: 50),
            ToolsButton(
              content: controller.isNext ? '下一步' : '开始解包',
              onPressed: () {
                if (!controller.isNext) {
                  controller.decompile();
                } else {
                  addChange2();
                  if (controller.changeConfig()) {
                    Get.dialog(ApkChangeNextView(
                      close: () => Navigator.pop(context),
                    ));
                  }
                }
              },
            )
          ],
        ),
      );
    }));
  }

  void addChange() {
    _configsValue.forEach((key, value) {
      switch (key) {
        case 'APP名':
          value.text = _pageState.appName;
          return;
        case '包名':
          value.text = _pageState.appPackName;
          return;
        case '目标版本':
          value.text = _pageState.targetSdkVersion;
          return;
        case '最低版本':
          value.text = _pageState.minSdkVersion;
          return;
        case '版本号':
          value.text = _pageState.appVersionCode;
          return;
        case '版本名':
          value.text = _pageState.appVersionName;
          return;
      }
    });
  }

  void addChange2() {
    _configsValue.forEach((key, value) {
      switch (key) {
        case 'APP名':
          _pageState.appName = value.text;
          return;
        case '包名':
          _pageState.appPackName = value.text;
          return;
        case '目标版本':
          _pageState.targetSdkVersion = value.text;
          return;
        case '最低版本':
          _pageState.minSdkVersion = value.text;
          return;
        case '版本号':
          _pageState.appVersionCode = value.text;
          return;
        case '版本名':
          _pageState.appVersionName = value.text;
          return;
      }
    });
  }

  //初始化配置
  void _initConfigValue() {
    _configsValue.clear();
    for (var element in _pageState.configsKeys) {
      _configsValue[element] = TextEditingController();
    }
  }

  //包体配置item
  Widget _itemBuilder(BuildContext context, int index) {
    return ToolEditInput(
      controller: _configsValue[_pageState.configsKeys[index]],
      labelText: _pageState.configsKeys[index],
    );
  }
}
