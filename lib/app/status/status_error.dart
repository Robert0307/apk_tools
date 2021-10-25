import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class StatusError extends StatelessWidget {
  String error;
  StatusError({Key? key, this.error = ''}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      alignment: Alignment.center,
      child: CupertinoPopupSurface(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Text(error),
        ),
      ),
    );
  }
}
