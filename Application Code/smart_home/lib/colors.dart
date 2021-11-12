import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class MyColors {
  static Color primaryBlack = Color(0xff16121f);
  static Color background = Colors.grey.shade50;
  static Color middleGrey = Color(0xff848082);
  static Color secondGrey = Colors.grey.shade200;
}

BoxDecoration linearDec = BoxDecoration(
    gradient: LinearGradient(
        colors: [Color(0xFFd6d6d6), Color(0xFFfafafa)],
        begin: Alignment.bottomCenter,
        end: Alignment.topCenter));
