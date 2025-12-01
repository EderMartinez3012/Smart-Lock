import 'package:flutter/material.dart';

const Color primaryBlue = Color(0xFF1E3A8A);
const Color accentBlue = Color(0xFF3B82F6);
const Color lightBlue = Color(0xFF60A5FA);

class ModernGradientBackground extends StatelessWidget {
  final Widget child;
  final List<Color>? colors;

  const ModernGradientBackground({
    super.key,
    required this.child,
    this.colors,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: colors ??
              [
                primaryBlue,
                accentBlue,
                lightBlue,
              ],
        ),
      ),
      child: Stack(
        children: [
          // Círculos decorativos animados
          Align(
            alignment: AlignmentDirectional.topEnd,
            child: _DecorativeCircle(size: screenWidth * 0.8, opacity: 0.05),
          ),
          Align(
            alignment: AlignmentDirectional.bottomStart,
            child: _DecorativeCircle(size: screenWidth * 0.9, opacity: 0.05),
          ),
          Align(
            alignment: AlignmentDirectional(0.8, -0.3),
            child: _DecorativeCircle(size: screenWidth * 0.3, opacity: 0.03),
          ),
          child,
        ],
      ),
    );
  }
}

class _DecorativeCircle extends StatelessWidget {
  final double size;
  final double opacity;

  const _DecorativeCircle({
    required this.size,
    required this.opacity,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white.withOpacity(opacity),
      ),
    );
  }
}