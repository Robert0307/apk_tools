import 'package:DogApkTools/app/app_status_controller.dart';
import 'package:DogApkTools/app/status/status_empty_list.dart';
import 'package:DogApkTools/app/status/status_error.dart';
import 'package:DogApkTools/app/status/status_loading.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

abstract class AppBasePage<T extends AppController> extends GetView<T> {
  @protected
  Widget content = Container(
    alignment: Alignment.center,
    child: Text('未初始化界面'),
  );

  @override
  Widget build(BuildContext context) {
    initStatus();
    return controller.obx(
      (state) => buildContent(context),
      onLoading: StatusLoading(),
      onEmpty: StatusEmptyList(),
      onError: (error) => StatusError(
        error: error!,
      ),
    );
  }

  initStatus() {}

  Widget buildContent(BuildContext context) {
    return content;
  }
}
