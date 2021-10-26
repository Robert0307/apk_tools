import 'package:DogApkTools/app/app_pages.dart';
import 'package:DogApkTools/app/app_status_controller.dart';
import 'package:DogApkTools/home/item/base_item.dart';
import 'package:DogApkTools/home/tools/apk/apk_b.dart';
import 'package:DogApkTools/home/tools/apk/apk_dex2jar.dart';
import 'package:DogApkTools/home/tools/apk/apk_info.dart';
import 'package:DogApkTools/home/tools/apk/apk_zipalign.dart';
import 'package:DogApkTools/home/tools/apk/change/apkchange/apk_change_view.dart';
import 'package:DogApkTools/home/tools/sign/apk_sign.dart';
import 'package:DogApkTools/home/tools/sign/apk_sign_check.dart';
import 'package:DogApkTools/utils/image_utils.dart';
import 'package:DogApkTools/widget/log.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

import 'apk/apk_d.dart';

class ToolsPage extends StatelessWidget {
  //, "批量更新"
  List<String> titles = ['反编译', '回编译', '签名', '签名查询', '包对齐', 'Dex转jar', '包信息', "更新配置"];
  String tipMessage = '''
  必须配置外挂工具目录和JDK环境 由于是本机操作,建议工作目录放在固态硬盘 
  APK不要选择名字有特殊符号的APK''';

  final logic = Get.find<AppStatusController>();

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Image.asset(
          ImageUtils.getImgPath('back', format: 'jpg'),
          filterQuality: FilterQuality.high,
          fit: BoxFit.fill,
        ),
        CupertinoPopupSurface(
          isSurfacePainted: false,
          child: Container(
            height: double.infinity,
            child: Scaffold(
              backgroundColor: Colors.transparent,
              appBar: AppBar(
                toolbarHeight: kToolbarHeight * 1.5,
                actions: [
                  Padding(
                    padding: EdgeInsets.all(15),
                    child: IconButton(
                        onPressed: () {
                          Get.toNamed(Routes.SETTING);
                        },
                        icon: Icon(
                          Icons.settings,
                          color: Colors.blue,
                        )),
                  )
                ],
                title: Text(
                  '包体处理工具',
                  style: TextStyle(
                    fontSize: 28,
                    color: Colors.blue,
                    fontWeight: FontWeight.bold,
                    shadows: <Shadow>[
                      Shadow(
                        offset: Offset(4.0, 4.0),
                        blurRadius: 4.0,
                        color: Colors.blue.withOpacity(0.1),
                      ),
                    ],
                  ),
                ),
              ),
              body: Container(
                padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 40),
                child: Column(
                  children: [
                    Log(
                      log: tipMessage,
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    GridView.builder(
                        shrinkWrap: true,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2, crossAxisSpacing: 10, mainAxisSpacing: 10, childAspectRatio: 6),
                        itemCount: titles.length,
                        itemBuilder: buildChild)
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget buildChild(BuildContext context, int index) {
    return BaseItem(
      title: titles[index],
      onTap: () {
        if (logic.checkToolEnvironment()) {
          Get.dialog(getContent(index));
        } else {
          EasyLoading.showToast(logic.settingStatue.value);
        }
      },
    );
  }

  getContent(int index) {
    switch (index) {
      case 0:
        return ApkToolD();
      case 1:
        return ApkToolB();
      case 2:
        return ApkToolSign();
      case 3:
        return ApkSignCheck();
      case 4:
        return ApkZipalign();
      case 5:
        return ApkDexToJar();
      case 6:
        return ApkInfo();
      case 7:
        return ApkChangePage();
    }
  }
}
