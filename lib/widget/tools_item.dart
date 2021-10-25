import 'package:flutter/material.dart';

class ToolsItem extends StatelessWidget {
  String? content;
  String? des;
  Function? onTap;
  Function? onTapDes;
  Widget? leading;
  bool? enabled;
  Color? color;
  ToolsItem(
      {this.content,
      this.onTap,
      this.leading,
      this.enabled = true,
      this.des,
      this.onTapDes,
      this.color = Colors.black54});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 5),
      decoration: BoxDecoration(
        color: Colors.grey.withOpacity(0.1),
          borderRadius: BorderRadius.circular(6)
      ),
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(vertical: 0,horizontal: 5),
        dense: true,
        onTap: ()=>onTap!(),
          enabled: enabled!,
          shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          title: Text(
            content!,
            style: TextStyle(color: color, fontSize: 14,),
          ),
          trailing: TextButton(
              onPressed: ()=>onTapDes!(),
              child: Text(
                des!,
                style: TextStyle(color: Colors.redAccent, fontSize: 12),
              )),
          ),
    );
  }

}
