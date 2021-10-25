import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class StatusLoading extends StatelessWidget {
  const StatusLoading({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: Colors.white),
          child: CupertinoActivityIndicator()),
    );
  }
}
