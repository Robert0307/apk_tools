import 'dart:io';

import 'package:DogApkTools/utils/file_utils.dart';
import 'package:desktop_drop/desktop_drop.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

enum DropType { apk, file, any, no, fileOrDir, apkOrApkDir, png }

class BaseItem extends StatefulWidget {
  String title;
  String content;
  double maxWidth;
  Function? onTap;
  Color contentColor;
  DropType dropType;
  Function(String)? onDragDone;

  BaseItem(
      {Key? key,
      required this.title,
      this.maxWidth = 300,
      this.content = '',
      this.contentColor = Colors.black,
      this.dropType = DropType.no,
      this.onDragDone,
      this.onTap})
      : super(key: key);

  @override
  _BaseItemState createState() => _BaseItemState();
}

class _BaseItemState extends State<BaseItem> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        widget.onTap!();
      },
      child: DropTarget(
        onDragDone: (detail) {
          if (detail.urls.length > 0) {
            String content = Uri.decodeComponent(detail.urls[0].path);
            if (Platform.isWindows) {
              content = content.replaceFirst('/', '');
            }
            switch (widget.dropType) {
              case DropType.apk:
                if (FileUtils.getExtension(content) == '.apk') {
                  if (widget.onDragDone != null) {
                    widget.onDragDone!(content);
                  }
                } else {
                  EasyLoading.showToast('仅支持APK');
                }
                return;
              case DropType.png:
                if (FileUtils.getExtension(content) == '.png') {
                  if (widget.onDragDone != null) {
                    widget.onDragDone!(content);
                  }
                } else {
                  EasyLoading.showToast('仅支持.png文件');
                }
                return;
              case DropType.file:
                if (FileUtils.isDirectory(content)) {
                  if (widget.onDragDone != null) {
                    if (Platform.isMacOS) {
                      widget.onDragDone!(content.replaceRange(content.length - 1, content.length, ''));
                    } else {
                      widget.onDragDone!(content);
                    }
                  } else {
                    EasyLoading.showToast('仅支持文件夹');
                  }
                }
                return;

              case DropType.fileOrDir:
                if (widget.onDragDone != null) {
                  if (File(content).existsSync()) {
                    widget.onDragDone!(content);
                  } else {
                    if (Platform.isMacOS) {
                      widget.onDragDone!(content.replaceRange(content.length - 1, content.length, ''));
                    } else {
                      widget.onDragDone!(content);
                    }
                  }
                }
                return;
              case DropType.apkOrApkDir:
                if (File(content).existsSync()) {
                  if (FileUtils.getExtension(content) == '.apk') {
                    if (widget.onDragDone != null) {
                      widget.onDragDone!(content);
                    }
                  } else {
                    EasyLoading.showToast('文件仅支持APK');
                  }
                } else {
                  if (Platform.isMacOS) {
                    widget.onDragDone!(content.replaceRange(content.length - 1, content.length, ''));
                  } else {
                    widget.onDragDone!(content);
                  }
                }

                return;
              default:
                return;
            }
          }
        },
        onDragEntered: (detail) {},
        onDragExited: (detail) {},
        child: Container(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            alignment: Alignment.center,
            decoration: BoxDecoration(color: Colors.black.withOpacity(0.05), borderRadius: BorderRadius.circular(6)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.title,
                  style: TextStyle(
                    color: Colors.blue.withOpacity(0.8),
                    fontSize: 14,
                  ),
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ConstrainedBox(
                      constraints: BoxConstraints(maxWidth: widget.maxWidth),
                      child: Text(
                        widget.content,
                        textAlign: TextAlign.right,
                        maxLines: 4,
                        style: TextStyle(
                            color: widget.content == '尚未设置' ||
                                    widget.content.contains('选择') ||
                                    widget.content.contains('输出')
                                ? Colors.redAccent.withOpacity(0.66)
                                : widget.contentColor.withOpacity(0.66),
                            fontSize: 12),
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Icon(
                      Icons.more_vert,
                      color: Colors.blue.withOpacity(0.6),
                    )
                  ],
                )
              ],
            )),
      ),
    );
  }
}
