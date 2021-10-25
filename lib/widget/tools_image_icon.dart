import 'package:flutter/material.dart';

class ToolsImageIcon extends StatelessWidget {
  String image;
  double size;

  ToolsImageIcon(this.image, {this.size = 30});

  @override
  Widget build(BuildContext context) {
    return Image(
      image: AssetImage(
        'assets/$image.png',
      ),
      width: size,
      height: size,
      fit: BoxFit.cover,
    );
  }
}
