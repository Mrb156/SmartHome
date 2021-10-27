import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:smart_home/services/realtimeDatabaseService.dart';

class TurnOnOffButton extends StatefulWidget {
  Function onPressed;
  bool iconIsOn = true;
  TurnOnOffButton({Key? key, required this.onPressed, required this.iconIsOn})
      : super(key: key);

  @override
  State<TurnOnOffButton> createState() => _TurnOnOffButtonState();
}

class _TurnOnOffButtonState extends State<TurnOnOffButton> {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
        onPressed: () {
          setState(() {
            widget.iconIsOn = !widget.iconIsOn;
          });
          widget.onPressed();
        },
        icon: Icon(widget.iconIsOn
            ? Icons.light_mode_outlined
            : Icons.nightlight_outlined),
        label: Text(widget.iconIsOn ? 'On' : 'Off'));
  }
}

class SendButton extends StatelessWidget {
  final Function onPressed;
  const SendButton({Key? key, required this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () => onPressed(),
      child: const Text('Set color'),
    );
  }
}

class LightSwitch extends StatefulWidget {
  bool isSwitched;
  Function onChagned;
  LightSwitch({Key? key, required this.onChagned, required this.isSwitched})
      : super(key: key);

  @override
  _LightSwitchState createState() => _LightSwitchState();
}

class _LightSwitchState extends State<LightSwitch> {
  @override
  Widget build(BuildContext context) {
    return Switch(
      onChanged: widget.onChagned(),
      value: widget.isSwitched,
    );
  }
}

class AddEventButton extends StatelessWidget {
  int _currlogIndex = 0;
  AddEventButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        realTimeDatabase().addEvent(DateTime.now().toString(), _currlogIndex);
        _currlogIndex++;
      },
      child: const Text('Add event'),
    );
  }
}

class SecOnOffButton extends StatefulWidget {
  Function onPressed;
  bool iconIsOn = true;
  SecOnOffButton({Key? key, required this.onPressed, required this.iconIsOn})
      : super(key: key);

  @override
  State<SecOnOffButton> createState() => _SecOnOffButtonState();
}

class _SecOnOffButtonState extends State<SecOnOffButton> {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
        onPressed: () {
          setState(() {
            widget.iconIsOn = !widget.iconIsOn;
          });
          widget.onPressed();
        },
        icon: Icon(widget.iconIsOn
            ? Icons.verified_user_outlined
            : Icons.privacy_tip_outlined),
        label: Text(widget.iconIsOn ? 'On' : 'Off'));
  }
}
