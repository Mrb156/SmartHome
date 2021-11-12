// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:smart_home/colors.dart';

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
      backgroundColor: Colors.transparent,
      centerTitle: false,
      title: Text(
        title,
        style: TextStyle(color: MyColors.primaryBlack, fontSize: 40),
      ),
      leading: leading,
      actions: actions,
      elevation: 0,
      bottom: tabBar,
    );
  }
}
