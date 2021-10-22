import 'package:flutter/material.dart';

class TurnOnOffButton extends StatefulWidget {
  Function onPressed;
  bool iconIsOn = true;
  TurnOnOffButton({Key? key, required this.onPressed}) : super(key: key);

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
