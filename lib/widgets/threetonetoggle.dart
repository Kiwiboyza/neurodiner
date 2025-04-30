import 'package:flutter/material.dart';

class ThreeToneToggle extends StatefulWidget {
  final Function(int)
  onChanged; // Callback function to notify the parent widget about the change
  final int currentState; // Set initial state (0, 1, 2)

  const ThreeToneToggle({
    super.key,
    required this.onChanged,
    required this.currentState,
  });

  @override
  ThreeToneToggleState createState() => ThreeToneToggleState();
}

class ThreeToneToggleState extends State<ThreeToneToggle> {
  // 0 -> Neutral, 1 -> Avoid (Red), 2 -> Prioritise (Green)
  int _toggleState = 0;

  @override
  void initState() {
    super.initState();
    _toggleState = widget.currentState;
  }

  void _setState(int newState) {
    setState(() {
      _toggleState = newState;
    });
    widget.onChanged(newState);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Left Button (Avoid - Red)
        OutlinedButton(
          onPressed: () => _setState(1),
          style: OutlinedButton.styleFrom(
            side: BorderSide(
              color:
                  _toggleState == 1 ? Colors.red : Colors.grey, // Outline color
            ),
            backgroundColor:
                _toggleState == 1
                    ? Colors.red
                    : Colors.transparent, // Fill color
          ),
          child: Icon(
            Icons.close,
            size: 48,
            color: _toggleState == 1 ? Colors.white : Colors.red, // Icon color
          ),
        ),
        // Neutral Button (Middle - Neutral)
        OutlinedButton(
          onPressed: () => _setState(0),
          style: OutlinedButton.styleFrom(
            side: BorderSide(
              color:
                  _toggleState == 0
                      ? Colors.grey
                      : Colors.grey, // Outline color
            ),
            backgroundColor:
                _toggleState == 0
                    ? Colors.grey
                    : Colors.transparent, // Fill color
          ),
          child: Icon(
            Icons.remove,
            size: 48,
            color: _toggleState == 0 ? Colors.white : Colors.grey, // Icon color
          ),
        ),
        // Right Button (Prioritise - Green)
        OutlinedButton(
          onPressed: () => _setState(2),
          style: OutlinedButton.styleFrom(
            side: BorderSide(
              color:
                  _toggleState == 2
                      ? Colors.green
                      : Colors.grey, // Outline color
            ),
            backgroundColor:
                _toggleState == 2
                    ? Colors.green
                    : Colors.transparent, // Fill color
          ),
          child: Icon(
            Icons.check,
            size: 48,
            color:
                _toggleState == 2 ? Colors.white : Colors.green, // Icon color
          ),
        ),
      ],
    );
  }
}
