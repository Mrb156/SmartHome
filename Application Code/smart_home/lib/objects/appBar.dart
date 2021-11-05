import 'package:flutter/material.dart';

class appBar extends StatelessWidget {
  dynamic leading;
  String title;
  final List<Widget>? actions;
  TabBar? tabBar;
  appBar(
      {Key? key, this.leading, this.actions, required this.title, this.tabBar})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.grey[50],
      centerTitle: false,
      title: Text(
        title,
        style: TextStyle(color: Colors.black, fontSize: 30),
      ),
      leading: leading,
      actions: actions,
      elevation: 0,
      bottom: tabBar,
    );
  }
}
