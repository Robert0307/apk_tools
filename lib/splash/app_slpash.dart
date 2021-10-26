import 'package:DogApkTools/app/app_config.dart';
import 'package:DogApkTools/app/app_pages.dart';
import 'package:DogApkTools/splash/app_splash_controller.dart';
import 'package:DogApkTools/utils/image_utils.dart';
import 'package:animate_do/animate_do.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

class AppSlash extends StatefulWidget {
  const AppSlash({Key? key}) : super(key: key);

  @override
  _AppSlashState createState() => _AppSlashState();
}

class _AppSlashState extends State<AppSlash> with TickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(milliseconds: 2500), () {
      Get.offNamed(Routes.HOME);
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: GetBuilder<AppSplashController>(
        init: AppSplashController(),
        builder: (controller) {
          return Container(
            alignment: Alignment.center,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Lottie.asset('assets/json/display.json'),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    FlipInY(
                      child: Image.asset(
                        ImageUtils.getImgPath('yw', format: 'jpg'),
                        height: 70,
                        filterQuality: FilterQuality.high,
                      ),
                    ),
                    SizedBox(
                      height: 100,
                    ),
                    CupertinoPopupSurface(
                      isSurfacePainted: false,
                      child: Container(
                        width: 200,
                        height: kToolbarHeight * 0.6,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CupertinoActivityIndicator(),
                            SizedBox(
                              width: 20,
                            ),
                            Text('${controller.launchStatus}', style: Theme.of(context).textTheme.caption!)
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    CupertinoPopupSurface(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        child: Text('BABY WELCOME TO APK TOOLS',
                            style: Theme.of(context)
                                .textTheme
                                .headline4!
                                .copyWith(fontWeight: FontWeight.bold, color: Colors.blue, fontSize: 28)),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text('${controller.platform}  ${AppConfig.version}', style: Theme.of(context).textTheme.caption!),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
