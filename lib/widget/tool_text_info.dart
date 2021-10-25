import 'package:flutter/material.dart';

class ToolsTextInfo extends StatelessWidget {
  String? content;
  String? des;
  Function? onTap;

  ToolsTextInfo({
    this.content,
    this.onTap,
    this.des,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.06),
          borderRadius: BorderRadius.circular(6)),
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 5),
        dense: true,
        onTap: () => onTap!(),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        title: Text(
          des!,
          style: TextStyle(color: Colors.grey, fontSize: 13),
        ),
        trailing: Text(content!,style: TextStyle(color: Colors.blue, fontSize: 16),),

      ),
    );
  }
}
