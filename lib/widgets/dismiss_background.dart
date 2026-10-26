import 'package:flutter/material.dart';

/// Red background with a delete icon, revealed while swiping right-to-left.
class DismissBackground extends StatelessWidget {
  final double radius;
  const DismissBackground({super.key, this.radius = 0});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.centerRight,
      padding: const EdgeInsets.only(right: 24),
      decoration: BoxDecoration(
        color: Colors.red,
        borderRadius: BorderRadius.circular(radius),
      ),
      child: const Icon(Icons.delete, color: Colors.white, size: 28),
    );
  }
}
