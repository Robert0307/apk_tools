import 'package:DogApkTools/utils/image_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';

class CommonPage extends StatefulWidget {
  String title;
  Widget child;
  List<Widget>? menu;

  CommonPage({Key? key, required this.title, required this.child, this.menu}) : super(key: key);

  @override
  _CommonPageState createState() => _CommonPageState();
}

class _CommonPageState extends State<CommonPage> with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        actions: widget.menu,
        elevation: 0,
        backgroundColor: Colors.transparent,
        centerTitle: false,
        title: Text(
          widget.title,
          style: TextStyle(
            fontSize: 20,
            color: Colors.blue,
            shadows: <Shadow>[
              Shadow(
                offset: Offset(1.0, 1.0),
                blurRadius: 1.0,
                color: Colors.blue.withOpacity(0.1),
              ),
            ],
          ),
        ),
      ),
      body: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
            bottom: 100,
            child: Image.asset(
              ImageUtils.getImgPath('back'),
              height: 120,
            ),
          ),
          Container(
            margin: EdgeInsets.all(20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18),
            ),
            child: CupertinoPopupSurface(
              isSurfacePainted: true,
              child: Padding(
                padding: EdgeInsets.all(12),
                child: widget.child,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
