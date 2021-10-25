import 'package:DogApkTools/home/setting/setting_page.dart';
import 'package:DogApkTools/home/tools/tools_page.dart';
import 'package:get/get.dart';

abstract class Routes {
  static const INITIAL = '/';
  static const HOME = '/home';
  static const SETTING = '/home/setting';
}

abstract class AppPages {
  static final pages = [
    GetPage(name: Routes.HOME, page: () => ToolsPage()),
    GetPage(name: Routes.SETTING, page: () => SettingPage()),
  ];
}
