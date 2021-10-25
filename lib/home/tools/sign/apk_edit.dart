import 'package:flutter/material.dart';

class ApkToolSignEdit extends StatefulWidget {
  @override
  _ApkToolSignEditState createState() => _ApkToolSignEditState();
}

class _ApkToolSignEditState extends State<ApkToolSignEdit> {
  TextEditingController controller = TextEditingController();
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      maxLength: 1000,
      maxLines: 200000,
    );
  }
}
