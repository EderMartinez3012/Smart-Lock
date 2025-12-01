import 'package:flutter/material.dart';

const Color accentPink = Color(0xFFEC4899);
const Color accentRed = Color(0xFFF43F5E);

// Widget para botones con gradiente
class GradientButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final List<Color>? colors;
  final IconData? icon;
  final double? width;
  final double? height;

  const GradientButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.colors,
    this.icon,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width ?? double.infinity,
      height: height ?? 55,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: colors ?? [accentPink, accentRed],
        ),
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: (colors?.first ?? accentPink).withOpacity(0.4),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        ),
        child: icon != null
            ? Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(icon, color: Colors.white),
                  const SizedBox(width: 8),
                  Text(
                    text,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.5,
                    ),
                  ),
                ],
              )
            : Text(
                text,
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.5,
                ),
              ),
      ),
    );
  }
}
