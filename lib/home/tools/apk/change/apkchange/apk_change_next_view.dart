import 'package:DogApkTools/home/common/status_callback.dart';
import 'package:DogApkTools/home/common/tools_dialog.dart';
import 'package:DogApkTools/home/item/base_item.dart';
import 'package:DogApkTools/home/tools/apk/change/apkchange/apk_change_logic.dart';
import 'package:DogApkTools/home/tools/apk/change/apkchange/apk_change_state.dart';
import 'package:DogApkTools/utils/file_utils.dart';
import 'package:DogApkTools/widget/app_tools_back.dart';
import 'package:DogApkTools/widget/tool_edit_input.dart';
import 'package:DogApkTools/widget/tools_button.dart';
import 'package:DogApkTools/widget/tools_select_sign_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ApkChangeNextView extends StatelessWidget {
  Function? close;
  ApkChangeNextView({Key? key, this.close}) : super(key: key);
  ApkChangeState pageStates = Get.find<ApkChangeLogic>().state;
  ApkChangeLogic logic = Get.find<ApkChangeLogic>();
  Map<String, TextEditingController> metaDatasController = {};

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ApkChangeLogic>(
      initState: (_) {
        pageStates.metaDatas.forEach((key, value) {
          TextEditingController newC = TextEditingController();
          newC.text = value;
          metaDatasController[key] = newC;
        });
      },
      builder: (logic) {
        pageStates = logic.state;
        return AppToolsBack(
          child: Column(
            children: [
              SizedBox(
                height: 10,
              ),
              BaseItem(
                content: FileUtils.getFileName(logic.state.selectSignTip),
                title: '签名',
                onTap: () async {
                  showSignDialog(context, select: (module) {
                    logic.getSignConfig(sign: module);
                  });
                },
              ),
              SizedBox(
                height: 10,
              ),
              Offstage(
                offstage: pageStates.metaDatas.length == 0,
                child: ListTile(
                  title: Text('基本参数'),
                  dense: true,
                ),
              ),
              SizedBox(
                height: 10,
              ),
              ListView.builder(
                  shrinkWrap: true, itemCount: pageStates.metaDatas.length, itemBuilder: _buildMetaDataChild),
              SizedBox(
                height: 30,
              ),
              ToolsButton(
                  content: '开始出包',
                  onPressed: () {
                    Map<String, String> metaDataParams = {};
                    metaDatasController.forEach((key, value) {
                      metaDataParams[key] = value.text;
                    });
                    Map<String, String> providerParams = {};
                    metaDatasController.forEach((key, value) {
                      providerParams[key] = value.text;
                    });

                    logic.changeParamsConfig(metaDataParams, providerParams,
                        callback: StatusCallback(
                            onSuccess: () {
                              showInfoDialog(context, '提示 ', '出包成功', onTap: () {
                                Navigator.pop(context);
                                if (close != null) {
                                  close!();
                                }
                              });
                            },
                            onError: (code) {
                              if (code == -2) {
                                showInfoDialog(context, '提示 ', '回编译成功\n签名失败,签名文件有问题');
                              } else {
                                showInfoDialog(context, '提示 ', '回编译失败');
                              }
                            },
                            onResult: (code, msg) {}));
                  }),
            ],
          ),
        );
      },
    );
  }

  Widget _buildMetaDataChild(BuildContext context, int index) {
    return Padding(
      padding: EdgeInsets.only(bottom: 10),
      child: ToolEditInput(
        controller: metaDatasController[pageStates.metaDatas.keys.toList()[index]],
        labelText: pageStates.metaDatas.keys.toList()[index],
      ),
    );
  }
}
