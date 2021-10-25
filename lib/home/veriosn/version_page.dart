import 'package:animate_do/animate_do.dart';
import 'package:DogApkTools/utils/image_utils.dart';
import 'package:flutter/material.dart';

class VersionPage extends StatefulWidget {
  const VersionPage({Key? key}) : super(key: key);

  @override
  _VersionPageState createState() => _VersionPageState();
}

class _VersionPageState extends State<VersionPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: BounceInUp(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset(
                ImageUtils.getImgPath('back'),
                height: 120,
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              '自动打包工具',
              style: TextStyle(color: Colors.blue, fontSize: 16),
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              'Version 1.0.0',
              style: TextStyle(color: Colors.grey, fontSize: 14),
            ),
            SizedBox(
              height: 6,
            ),
            Text(
              '更新时间 2021-10-14',
              style: TextStyle(color: Colors.grey.withOpacity(0.6), fontSize: 11),
            )
          ],
        ),
      ),
    );
  }
}
