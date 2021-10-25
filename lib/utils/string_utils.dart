import 'dart:io';

import 'package:xml/xml.dart';

class StringUtils {
  static getContent(String content, String start, String end) {
    int indexStart = content.indexOf(start);
    int indexEdn = content.indexOf(end);
    String str1 = content.substring(indexStart, indexEdn);

    String str2 = str1.replaceAll(new RegExp(r"\s+"), '');
    String str3 = str2.replaceAll('\'', '');

    return str3.replaceAll(start, '');
  }

  static inquireAppName(String fileName, String name) {
    String appName = '';
    File file = File('$fileName/res/values/strings.xml');

    final document = XmlDocument.parse(file.readAsStringSync());
    XmlDocument data = document.document!;

    XmlElement resources = data.getElement('resources')!;

    //获取所有权限
    resources.findAllElements('string').forEach((element) {
      if (element.getAttribute('name') == name) {
        appName = element.firstChild!.text;
      }
    });

    return appName;
  }

  static changeAppName(String fileName, String content, String name) {
    String appName = '';
    File file = File('$fileName/res/values/strings.xml');

    final document = XmlDocument.parse(file.readAsStringSync());
    XmlDocument data = document.document!;

    XmlElement resources = data.getElement('resources')!;

    //获取所有权限
    resources.findAllElements('string').forEach((element) {
      if (element.getAttribute('name') == name) {
        appName = element.firstChild!.text;
      }
    });

    print('appName $appName');
    print('appName $content');
    file.readAsStringSync().replaceAll(appName, content);
    file.writeAsStringSync(
        file.readAsStringSync().replaceAll(appName, content));
  }

  static change2(String fileName, String content, String name) {
    String appName = '';
    File file = File('$fileName/res/values/strings.xml');

    final document = XmlDocument.parse(file.readAsStringSync());
    XmlDocument data = document.document!;

    XmlElement resources = data.getElement('resources')!;

    //获取所有权限
    resources.findAllElements('string').forEach((element) {
      if (element.getAttribute('name') == name) {
        appName = element.firstChild!.text;
      }
    });

    file.readAsStringSync().replaceAll(appName, content);
    file.writeAsStringSync(
        file.readAsStringSync().replaceAll(appName, content));
  }
}
