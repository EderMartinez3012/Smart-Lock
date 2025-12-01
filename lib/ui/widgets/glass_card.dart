import 'package:flutter/material.dart';

// Widget reutilizable para tarjetas con glassmorphism
class GlassCard extends StatelessWidget {
  final Widget child;
  final EdgeInsets? padding;
  final double? width;
  final double? height;
  final EdgeInsets? margin;

  const GlassCard({
    super.key,
    required this.child,
    this.padding,
    this.width,
    this.height,
    this.margin,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      padding: padding ?? const EdgeInsets.all(20),
      margin: margin,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.white.withOpacity(0.2),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            spreadRadius: 5,
          ),
        ],
      ),
      child: child,
    );
  }
}
