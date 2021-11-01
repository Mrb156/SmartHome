import 'package:flutter/material.dart';

//a biztonsági értesítések kártyái
class AlertCard extends StatefulWidget {
  String date;
  AlertCard({Key? key, required this.date}) : super(key: key);

  @override
  _AlertCardState createState() => _AlertCardState();
}

class _AlertCardState extends State<AlertCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Text(widget.date),
      ),
    );
  }
}
