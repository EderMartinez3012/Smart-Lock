import 'package:flutter/material.dart';

const Color accentColor = Color(0xFF1E88E5);

class BackgroundDesign extends StatelessWidget {
  final Widget child;

  const BackgroundDesign({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          top: -100,
          left: -100,
          child: _DesignCircle(size: 250, color: accentColor.withOpacity(0.05)),
        ),
        Positioned(
          bottom: -80,
          right: -80,
          child: _DesignCircle(size: 180, color: accentColor.withOpacity(0.08)),
        ),
        Positioned(
          top: MediaQuery.of(context).size.height / 3,
          right: 30,
          child: _DesignCircle(size: 100, color: accentColor.withOpacity(0.03)),
        ),
        child,
      ],
    );
  }
}

class _DesignCircle extends StatelessWidget {
  final double size;
  final Color color;

  const _DesignCircle({required this.size, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    );
  }
}
