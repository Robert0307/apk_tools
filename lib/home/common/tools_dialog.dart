import 'package:animate_do/animate_do.dart';
import 'package:DogApkTools/widget/tools_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

showInfoDialog(BuildContext context, String title, String content, {Function? onTap}) {
  showDialog(
      barrierColor: Colors.black12,
      context: context,
      builder: (BuildContext context) {
        return FadeIn(
          child: AlertDialog(
            actionsPadding: EdgeInsets.only(bottom: 25),
            actionsAlignment: MainAxisAlignment.center,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            title: title == ''
                ? null
                : Text(
                    title,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16, color: Colors.black54),
                  ),
            content: SingleChildScrollView(
              child: Text(
                content,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14, color: Colors.blue),
              ),
            ),
            actions: [
              ToolsButton(
                onPressed: () {
                  if (onTap != null) {
                    onTap();
                  }
                  Navigator.pop(context);
                },
                content: '关闭',
              )
            ],
          ),
        );
      });
}
