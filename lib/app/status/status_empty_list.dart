import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class StatusEmptyList extends StatelessWidget {
  String content;
  StatusEmptyList({Key? key, this.content = '暂无数据'}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Lottie.asset('assets/json/alert.json', width: 100, height: 100),
          SizedBox(height: 10),
          Text(content)
        ],
      ),
    );
  }
}
