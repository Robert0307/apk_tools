import 'package:animate_do/animate_do.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AppToolsBack extends StatelessWidget {
  Widget child;
  bool hasPadding;
  double width;

  AppToolsBack({required this.child, this.hasPadding = true, this.width = 520, key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Center(
        child: FadeInUp(
          child: Container(
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
            margin: EdgeInsets.symmetric(vertical: 40),
            width: width,
            child: Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 40, right: 40, top: 80, bottom: 40),
                  child: SingleChildScrollView(
                    child: FadeInUp(
                      child: child,
                    ),
                  ),
                ),
                Positioned(
                    left: 8,
                    top: 8,
                    child: CloseButton(
                      color: Colors.blue,
                    )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
