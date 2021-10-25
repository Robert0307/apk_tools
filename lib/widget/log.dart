import 'package:animate_do/animate_do.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Log extends StatefulWidget {
  String log;

  Log({Key? key, required this.log}) : super(key: key);

  @override
  _LogState createState() => _LogState();
}

class _LogState extends State<Log> {
  @override
  Widget build(BuildContext context) {
    return Visibility(
        visible: widget.log != '',
        child: FlipInX(
          child: SingleChildScrollView(
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.all(15),
              decoration: BoxDecoration(color: Colors.black.withOpacity(0.05), borderRadius: BorderRadius.circular(4)),
              child: Text(
                widget.log,
                style: TextStyle(color: Colors.redAccent.withOpacity(0.8), fontSize: 12),
              ),
            ),
          ),
        ));
  }
}
