import 'package:DogApkTools/app/app_pages.dart';
import 'package:DogApkTools/app/theme/app_theme.dart';
import 'package:DogApkTools/splash/app_slpash.dart';
import 'package:desktop_window/desktop_window.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:oktoast/oktoast.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  windowFunctions();
  runApp(Container(child: MyApp()));
}

Future windowFunctions() async {
  await DesktopWindow.setWindowSize(Size(700, 600));
  await DesktopWindow.setMinWindowSize(Size(700, 600));
  await DesktopWindow.setMaxWindowSize(Size(700, 600));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    doEasyLoading();

    return OKToast(
        child: GetMaterialApp(
      home: AppSlash(),
      getPages: AppPages.pages,
      theme: appThemeData,
      debugShowCheckedModeBanner: false,
      initialRoute: Routes.INITIAL,
      builder: EasyLoading.init(),
    ));
  }

  doEasyLoading() {
    EasyLoading.instance
      ..displayDuration = const Duration(milliseconds: 2000)
      ..indicatorType = EasyLoadingIndicatorType.threeBounce
      ..loadingStyle = EasyLoadingStyle.light
      ..indicatorWidget = CupertinoActivityIndicator()
      ..maskType = EasyLoadingMaskType.custom
      ..radius = 10
      ..textColor = Colors.blueAccent
      ..maskColor = Colors.black.withOpacity(0.1)
      ..userInteractions = false
      ..dismissOnTap = false;
  }
}
