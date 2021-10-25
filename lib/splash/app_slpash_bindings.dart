import 'package:DogApkTools/splash/app_splash_controller.dart';
import 'package:get/get.dart';

//注册控制器 在使用的时候才初始化
class AppSplashBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => AppSplashController());
  }
}
