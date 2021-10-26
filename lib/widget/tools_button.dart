import 'package:flutter/material.dart';

class ToolsButton extends StatelessWidget {
  String content;
  Function onPressed;
  double size;
  ToolsButton({required this.content, required this.onPressed, this.size = 200});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ButtonStyle(minimumSize: MaterialStateProperty.all(Size(size, kTextTabBarHeight))),
      child: Text(content, style: TextStyle(color: Colors.white)),
      onPressed: () => onPressed(),
    );
  }
}
