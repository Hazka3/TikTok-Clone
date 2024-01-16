import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

class FlashModeButton extends StatelessWidget {
  final FlashMode flashMode;
  final FlashMode selectedFlashMode;
  final IconData icon;
  final Function onPressed;

  const FlashModeButton({
    super.key,
    required this.icon,
    required this.onPressed,
    required this.flashMode,
    required this.selectedFlashMode,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      color: flashMode == selectedFlashMode ? Colors.yellow : Colors.white,
      onPressed: () => onPressed(flashMode),
      icon: Icon(icon),
    );
  }
}
