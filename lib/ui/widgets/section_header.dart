import 'package:flutter/material.dart';

// Widget para sección de título
class SectionHeader extends StatelessWidget {
  final String title;
  final Color? color;

  const SectionHeader({
    super.key,
    required this.title,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Text(
        title.toUpperCase(),
        style: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: color ?? Colors.grey.shade600,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}
