import 'package:DogApkTools/home/tools/module/sign.dart';
import 'package:DogApkTools/home/tools/module/sign_module.dart';
import 'package:DogApkTools/home/tools/tools_config.dart';
import 'package:DogApkTools/utils/file_utils.dart';
import 'package:DogApkTools/utils/tools_run.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

showSignDialog(BuildContext context, {required Function(Sign) select}) {
  showDialog(
      context: context,
      builder: (_) => ToolsSelectSign(
            select: select,
          ));
}

class ToolsSelectSign extends StatefulWidget {
  Function(Sign) select;

  ToolsSelectSign({Key? key, required this.select}) : super(key: key);

  @override
  _ToolsSelectSignState createState() => _ToolsSelectSignState();
}

class _ToolsSelectSignState extends State<ToolsSelectSign> {
  SignModule? signMould;

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Center(
        child: Text('选择签名文件'),
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      content: signMould!.sign.length == 0
          ? Container(
              height: 120,
              alignment: Alignment.center,
              child: Column(
                children: [
                  SizedBox(
                    height: 20,
                  ),
                  Lottie.asset('assets/json/error.json', width: 40, height: 40),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    '未配置签名',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.redAccent.withOpacity(0.8)),
                  )
                ],
              ),
            )
          : Column(
              mainAxisSize: MainAxisSize.min,
              children: signMould!.sign.map((e) => _buildItem(e)).toList(),
            ),
      actions: [
        TextButton(
          child: Text('编辑'),
          onPressed: () {
            Navigator.pop(context);
            ToolsRun.openFolder(folder: signConfigPath());
          },
        ),
        TextButton(
          child: Text('关闭'),
          onPressed: () {
            Navigator.pop(context);
          },
        )
      ],
    );
  }

  getData() async {
    signMould = signModule();
    setState(() {});
  }

  Widget _buildItem(Sign sign) {
    return Container(
      width: 220,
      margin: EdgeInsets.only(top: 10),
      child: OutlinedButton(
        style: ButtonStyle(minimumSize: MaterialStateProperty.all(Size(200, 46))),
        child: Text(FileUtils.getFileName(sign.storeFile)),
        onPressed: () {
          Navigator.pop(context);
          widget.select(sign);
        },
      ),
    );
  }
}
