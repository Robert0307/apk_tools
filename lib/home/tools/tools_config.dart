import 'dart:convert';
import 'dart:io';

import 'package:DogApkTools/app/app_config.dart';
import 'package:DogApkTools/home/tools/module/sign_module.dart';
import 'package:DogApkTools/utils/file_utils.dart';

String dexToJar() => '${FileUtils.getToolsPath()}/dex2jar/d2j-dex2jar.sh';

String dexToJarBat() => '${FileUtils.getToolsPath()}/dex2jar/d2j-dex2jar.bat';

String aapt() => '${FileUtils.getToolsPath()}/aapt/${Platform.isMacOS ? 'mac/aapt' : 'win/aapt.exe'}';

String aapt2() => '${FileUtils.getToolsPath()}/aapt/${Platform.isMacOS ? 'mac/aapt2' : 'win/aapt2.exe'}';

String androidJar() => '${FileUtils.getToolsPath()}/apk/android.jar';

String apksigner() => '${FileUtils.getToolsPath()}/sign/apksigner.jar';

String zipaligns() => '${FileUtils.getToolsPath()}/zipalign/${Platform.isMacOS ? 'mac/zipalign' : 'win/zipalign.exe'}';

String signPass() => 'yezixi_20180918';

String signAlias() => 'yjqk';

String apkanalyzer() => '${FileUtils.getToolsPath()}/apk/APKParser.jar';

String apktool() => '${FileUtils.getToolsPath()}/apk/apktool_2.5.0.jar';
String aarTools() => '${FileUtils.getToolsPath()}/aar/apkAutoTool.jar';
String aarToolsV4V7() => '${FileUtils.getToolsPath()}/aar/common-release.aar';
String log4j() => '${FileUtils.getToolsPath()}/aar/log4j.properties';

String signConfigPath() => '${FileUtils.getToolsPath()}/sign/signlist/sign_config.txt';

SignModule signModule() =>
    SignModule.fromJsonMap(jsonDecode(File('${AppConfig.toolsPath}/sign/signlist/sign_config.txt').readAsStringSync()));
