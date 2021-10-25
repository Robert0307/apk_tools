import 'package:DogApkTools/widget/tool_edit_input.dart';
import 'package:DogApkTools/widget/tools_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class SettingInputPathPage extends StatefulWidget {
  String content;
  Function(String path)? path;

  SettingInputPathPage({Key? key, this.content = '点击选择目录', this.path}) : super(key: key);

  @override
  _SettingInputPathPageState createState() => _SettingInputPathPageState();
}

class _SettingInputPathPageState extends State<SettingInputPathPage> {
  late String path;
  TextEditingController textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20),
      alignment: Alignment.center,
      height: 200,
      width: 400,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ToolEditInput(
            controller: textEditingController,
            labelText: widget.content,
          ),
          SizedBox(
            height: 40,
          ),
          ToolsButton(
              onPressed: () {
                if (textEditingController.text.startsWith('http') && textEditingController.text.endsWith('/')) {
                  Navigator.pop(context);
                  widget.path!(textEditingController.text);
                } else {
                  EasyLoading.showToast('无效地址');
                }
              },
              content: '确定')
        ],
      ),
    );
  }
}
