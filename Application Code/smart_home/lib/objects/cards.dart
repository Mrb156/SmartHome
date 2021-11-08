import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:smart_home/colors.dart';

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

class ControlCard extends StatefulWidget {
  double height;
  double width;
  BoxConstraints constraints;
  String title;
  bool switchValue;
  Function onSwitchChange;
  String primaryProp;
  String secondaryProp;
  Widget primaryValue;
  String secondaryValue;
  Widget? wichPageToOpen;
  bool? only = false;
  ControlCard({
    Key? key,
    required this.constraints,
    required this.title,
    required this.switchValue,
    required this.onSwitchChange,
    required this.primaryProp,
    required this.secondaryProp,
    required this.primaryValue,
    required this.secondaryValue,
    required this.height,
    required this.width,
    this.wichPageToOpen,
    required this.only,
  }) : super(key: key);

  @override
  _ControlCardState createState() => _ControlCardState();
}

class _ControlCardState extends State<ControlCard> {
  bool absorbed = false;
  @override
  Widget build(BuildContext context) {
    if (widget.only!) {
      return SizedBox(
        height: widget.height,
        width: widget.width,
        child: Card(
          shape: RoundedRectangleBorder(
              borderRadius:
                  BorderRadius.circular(widget.constraints.maxHeight * 0.02),
              side: BorderSide(color: MyColors.middleGrey, width: 1)),
          elevation: 5,
          color: MyColors.background,
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Align(alignment: Alignment.center, child: Text(widget.title)),
                SafeArea(
                  child: Switch(
                    activeColor: Colors.white,
                    activeTrackColor: MyColors.primaryBlack,
                    inactiveTrackColor: MyColors.secondGrey,
                    value: widget.switchValue,
                    onChanged: (bool value) {
                      setState(() {
                        widget.switchValue = value;
                        absorbed = !value;
                      });
                      widget.onSwitchChange;
                    },
                  ),
                )
              ],
            ),
          ),
        ),
      );
    } else {
      return GestureDetector(
        onTap: () {
          Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => widget.wichPageToOpen!));
        },
        child: SizedBox(
          height: widget.height,
          width: widget.width,
          child: Card(
            shape: RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.circular(widget.constraints.maxHeight * 0.02),
                side: BorderSide(color: MyColors.middleGrey, width: 1)),
            elevation: 5,
            color: MyColors.background,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Align(
                        alignment: Alignment.center, child: Text(widget.title)),
                    SafeArea(
                      child: Switch(
                        activeColor: Colors.white,
                        activeTrackColor: MyColors.primaryBlack,
                        inactiveTrackColor: MyColors.secondGrey,
                        value: widget.switchValue,
                        onChanged: (bool value) {
                          setState(() {
                            widget.switchValue = value;
                            absorbed = !value;
                          });
                          widget.onSwitchChange();
                        },
                      ),
                    )
                  ],
                ),
                Padding(
                  padding: EdgeInsets.only(
                      bottom: widget.constraints.maxHeight * 0.03),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text(widget.primaryProp),
                            widget.primaryValue
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text(widget.secondaryProp),
                            Text(widget.secondaryValue),
                          ],
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      );
    }
  }
}

class TempPropCard extends StatefulWidget {
  BoxConstraints constraints;
  String dataType;
  String data;
  TempPropCard(
      {Key? key,
      required this.constraints,
      required this.dataType,
      required this.data})
      : super(key: key);

  @override
  _TempPropCardState createState() => _TempPropCardState();
}

class _TempPropCardState extends State<TempPropCard> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: widget.constraints.maxHeight * 0.2,
        width: widget.constraints.maxWidth * 0.4,
        child: Card(
          color: MyColors.background,
          shape: RoundedRectangleBorder(
              borderRadius:
                  BorderRadius.circular(widget.constraints.maxHeight * 0.02),
              side: BorderSide(color: MyColors.middleGrey, width: 1)),
          elevation: 5,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text(
                'Jelenlegi ${widget.dataType}',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: widget.constraints.maxHeight * 0.02),
              ),
              Text(
                widget.data,
                style: TextStyle(fontSize: widget.constraints.maxHeight * 0.04),
              ),
            ],
          ),
        ));
  }
}
