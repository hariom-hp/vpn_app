import 'package:flutter/material.dart';

class ConnectionButton extends StatelessWidget {
  final bool isConnected;
  final VoidCallback onPressed;

  const ConnectionButton({
    super.key,
    required this.isConnected,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: 160,
        height: 160,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Theme.of(context).colorScheme.surfaceContainerHighest,
          boxShadow: [
            BoxShadow(
              color: isConnected
                  ? Colors.green.withOpacity(0.3)
                  : Colors.grey.withOpacity(0.3),
              spreadRadius: 5,
              blurRadius: 10,
            ),
          ],
        ),
        child: Center(
          child: Container(
            width: 140,
            height: 140,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isConnected
                  ? Colors.green
                  : Theme.of(context).colorScheme.primary,
              border: Border.all(
                color: Colors.white,
                width: 3,
              ),
            ),
            child: Icon(
              isConnected ? Icons.power_settings_new : Icons.power_off,
              size: 60,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
