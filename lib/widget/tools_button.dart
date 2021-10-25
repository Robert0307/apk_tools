import 'package:flutter/material.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

class ToolsButton extends StatelessWidget {
  String content;
  Function onPressed;
  RoundedLoadingButtonController controller = RoundedLoadingButtonController();
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
