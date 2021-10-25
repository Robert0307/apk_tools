import 'dart:io';

import 'package:DogApkTools/utils/string_utils.dart';
import 'package:xml/xml.dart';

class AndroidManifestUtils {
  static dynamic inquireInfo(
    AndroidManifestInfo info, {
    bool haContent = false,
    String? content,
    String? fileName,
  }) {
    XmlDocument document;
    if (haContent) {
      document = XmlDocument.parse(content!);
    } else {
      File file = File('$fileName/Androidmanifest.xml');
      document = XmlDocument.parse(file.readAsStringSync());
    }

    XmlDocument? data = document.document;

    XmlElement? manifest = data!.getElement('manifest');
    if (info == AndroidManifestInfo.package) {
      return manifest!.getAttribute('package');
    }
    if (info == AndroidManifestInfo.versionCode) {
      return manifest!.getAttribute('android:versionCode');
    }
    if (info == AndroidManifestInfo.versionName) {
      return manifest!.getAttribute('android:versionName');
    }
    if (info == AndroidManifestInfo.platformBuildVersionCode) {
      return manifest!.getAttribute('platformBuildVersionCode');
    }
    if (info == AndroidManifestInfo.platformBuildVersionName) {
      return manifest!.getAttribute('platformBuildVersionName');
    }

    if (info == AndroidManifestInfo.permissions) {
      List permissions = [];
      //获取所有权限
      manifest!.findAllElements('uses-permission').forEach((element) {
        permissions.add(element.getAttribute('android:name'));
      });

      return permissions.toString();
    }

    if (info == AndroidManifestInfo.usesSdk) {
      late String usesSdk;
      //获取所有权限
      manifest!.findAllElements('uses-sdk').forEach((element) {
        usesSdk = element.getAttribute('android:minSdkVersion')!;
      });

      return usesSdk;
    }
    if (info == AndroidManifestInfo.targetSdkVersion) {
      late String targetSdkVersion;
      //获取所有权限
      manifest!.findAllElements('uses-sdk').forEach((element) {
        targetSdkVersion = element.getAttribute('android:targetSdkVersion')!;
      });

      return targetSdkVersion;
    }

    XmlElement? application = manifest!.getElement('application');

    if (info == AndroidManifestInfo.label) {
      if (application!.getAttribute('android:label')!.contains('@string/')) {
        return StringUtils.inquireAppName(
            fileName!, application.getAttribute('android:label')!.replaceAll('@string/', ''));
      }

      return application.getAttribute('android:label');
    }

    if (info == AndroidManifestInfo.icon) {
      return application!.getAttribute('android:icon');
    }

    if (info == AndroidManifestInfo.metaDatas) {
      Map<String, String> metaDatas = {};

      //获取所有权限
      application!.findAllElements('meta-data').forEach((element) {
        String name = element.getAttribute('android:name')!;

        if (!name.contains('com.yzx.') &&
            !name.contains('aspec') &&
            !name.contains('com.huawei') &&
            !name.contains('android.support') &&
            !name.contains('android.app') &&
            !name.contains('unity') &&
            !name.contains('com.google') &&
            !name.contains('com.epi') &&
            !name.contains('PUSH')) {
          if (element.getAttribute('android:value') != null) {
            metaDatas[name] = element.getAttribute('android:value')!;
          }
        }
      });

      return metaDatas;
    }

    if (info == AndroidManifestInfo.splash) {
      bool yzxSplash = false;

      if (application!.toXmlString().contains('SDKActivity')) {
        yzxSplash = false;
      } else {
        yzxSplash = true;
      }
      return yzxSplash;
    }

    if (info == AndroidManifestInfo.providers) {
      Map<String, String> providers = {};

      //获取所有权限
      application!.findAllElements('provider').forEach((element) {
        String? name = element.getAttribute('android:name');

        providers[name!] = element.getAttribute('android:authorities')!;
      });

      return providers;
    }

    if (info == AndroidManifestInfo.channelVersion) {
      String channelVersion = '0_0';

      //获取所有权限
      application!.findAllElements('meta-data').forEach((element) {
        if (element.getAttribute('android:name') == 'com.yzx.net.channel') {
          channelVersion = element.getAttribute('android:value')!;
        }
      });

      return channelVersion;
    }

    return '';
  }

  static void change(String fileName,
      {String? package,
      String? label,
      String? logo,
      String? channelVersion,
      Map<String, String>? metaDatas,
      Map<String, String>? providers,
      bool? hasSlash}) {
    File file = File('$fileName/Androidmanifest.xml');

    final document = XmlDocument.parse(file.readAsStringSync());
    XmlDocument? data = document.document;

    XmlElement? manifest = data!.getElement('manifest');
    if (package != null) {
    } else {
      package = manifest!.getAttribute("package");
    }

    XmlElement? application = manifest!.getElement('application');
    if (label != null) {
      if (application!.getAttribute('android:label')!.contains('@string/')) {
        StringUtils.changeAppName(
            fileName, label, application.getAttribute('android:label')!.replaceAll('@string/', ''));
      } else {
        application.setAttribute('android:label', label);
      }
    }
    if (logo != null) {
      if (application!.getAttribute('android:icon') != '@mipmap/logo') {
        application.setAttribute('android:icon', logo);
      } else {
        print('logo 无需处理');
      }
    }

    //获取所有权限
    application!.findAllElements('meta-data').forEach((element) {
      if (channelVersion != null) {
        if (element.getAttribute('android:name') == 'com.yzx.net.channel') {
          element.setAttribute('android:value', channelVersion);
        }
      }

      if (metaDatas != null) {
        if (metaDatas.containsKey(element.getAttribute('android:name'))) {
          element.setAttribute('android:value', metaDatas[element.getAttribute('android:name')]);
        }
      }
    });

    //获取所有权限
    application.findAllElements('provider').forEach((element) {
      if (providers != null) {
        if (providers.containsKey(element.getAttribute('android:name'))) {
          element.setAttribute('android:authorities', providers[element.getAttribute('android:name')]);
        }
      }
    });

    String dataStr = data.toXmlString();

    file.writeAsString(changePackName(dataStr, package!, manifest.getAttribute("package")!));
  }

  static String changePackName(String data, String package, String old) {
    String newData;
    if (data.contains(old)) {
      newData = data.replaceAll(old, package);
    } else {
      newData = data;
    }

    return newData;
  }
}

enum AndroidManifestInfo {
  package,
  platformBuildVersionCode,
  platformBuildVersionName,
  label,
  icon,
  metaDatas,
  providers,
  permissions,
  channelVersion,
  splash,
  usesSdk,
  targetSdkVersion,
  versionName,
  versionCode
}
