import 'package:flutter/material.dart';
import 'package:neurodiner/functions/functions.dart';

class HomePageButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;

  const HomePageButton({
    super.key,
    required this.label,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: darkenColor(Theme.of(context).colorScheme.surface),
        foregroundColor: darkenColor(Theme.of(context).colorScheme.onSurface),
        minimumSize: Size(MediaQuery.of(context).size.width * 0.8, 100),
        textStyle: const TextStyle(fontSize: 18),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: const BorderSide(color: Colors.black, width: 2),
        ),
      ),
      child: Text(label),
    );
  }
}
