import 'package:flutter/material.dart';

// Widget para iconos en círculo
class CircleIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;
  final Color? backgroundColor;
  final Color? iconColor;
  final double? size;

  const CircleIconButton({
    super.key,
    required this.icon,
    required this.onPressed,
    this.backgroundColor,
    this.iconColor,
    this.size,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: backgroundColor ?? Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.white.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: IconButton(
        icon: Icon(icon, color: iconColor ?? Colors.white),
        iconSize: size ?? 24,
        onPressed: onPressed,
      ),
    );
  }
}
