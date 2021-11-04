import 'package:flutter/material.dart';

class appBar extends StatelessWidget {
  dynamic leading;
  final List<Widget>? actions;
  appBar({Key? key, this.leading, this.actions}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      centerTitle: true,
      title: Text(
        'Smart Home Control',
        style: TextStyle(color: Colors.black),
      ),
      leading: leading,
      actions: actions,
    );
  }
}
