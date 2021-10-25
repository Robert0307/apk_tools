import 'package:flutter/material.dart';

class ToolEditInput extends StatelessWidget {
  TextEditingController? controller;
  String? labelText;
  Widget? suffix;
  bool? onlyRead;
  bool isExpanded = false;
  bool leftHelp = false;
  TextInputType keyboardType = TextInputType.multiline;

  ToolEditInput(
      {Key? key,
      this.controller,
      this.labelText,
      this.suffix,
      this.leftHelp = false,
      this.keyboardType = TextInputType.multiline,
      this.isExpanded = false,
      this.onlyRead = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return isExpanded ? Expanded(child: getChild()) : getChild();
  }

  Widget getChild() {
    return Container(
      alignment: Alignment.center,
      height: 46,
      decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.05),
          borderRadius: BorderRadius.circular(6)),
      child: TextField(
          enabled: true,
          maxLines: 100,
          minLines: 1,
          readOnly: onlyRead!,
          keyboardType: keyboardType,
          controller: controller,
          style: TextStyle(fontSize: 13, color: Colors.black.withOpacity(0.7)),
          cursorColor: Colors.blue,
          decoration: InputDecoration(
            suffix: suffix,
            contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            labelStyle:
                TextStyle(fontSize: 14, color: Colors.blue.withOpacity(0.8)),
            floatingLabelBehavior: FloatingLabelBehavior.auto,
            fillColor: Colors.transparent,
            filled: true,
            labelText: labelText,
            prefixStyle:
                TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
            focusedBorder: InputBorder.none,
            enabledBorder: InputBorder.none,
          )),
    );
  }
}
