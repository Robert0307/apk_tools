import 'package:DogApkTools/home/item/base_item.dart';
import 'package:DogApkTools/utils/file_utils.dart';
import 'package:DogApkTools/widget/tools_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SettingSelectPathPage extends StatefulWidget {
  String content;
  Function(String path)? path;

  SettingSelectPathPage({Key? key, this.content = '点击选择目录', this.path}) : super(key: key);

  @override
  _SettingSelectPathPageState createState() => _SettingSelectPathPageState();
}

class _SettingSelectPathPageState extends State<SettingSelectPathPage> {
  late String path;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20),
      alignment: Alignment.center,
      height: 140,
      width: widget.content.contains('选择目录') ? 400 : null,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          BaseItem(
            title: widget.content,
            onTap: () async {
              path = (await FileUtils.getDirPath())!;
              if (FileUtils.isDirectory(path)) {}
              setState(() {
                widget.content = path;
              });
            },
          ),
          Container(
            margin: EdgeInsets.symmetric(vertical: 20),
          ),
          ToolsButton(
              onPressed: () {
                Navigator.pop(context);
                widget.path!(path);
              },
              content: '确定')
        ],
      ),
    );
  }
}
