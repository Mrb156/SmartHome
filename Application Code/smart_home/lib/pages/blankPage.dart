import 'package:flutter/material.dart';

class Blank extends StatelessWidget {
  const Blank({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Text('TEszt'),
      onTap: () => Navigator.of(context).pop(),
    );
  }
}
