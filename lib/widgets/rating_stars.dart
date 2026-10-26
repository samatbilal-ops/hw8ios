import 'package:flutter/material.dart';

/// Star rating. [compact] = one star + number (for the grid card),
/// otherwise five stars (full / half / empty) + number (for the list row).
class RatingStars extends StatelessWidget {
  final double rating;
  final bool compact;
  final double size;

  const RatingStars({
    super.key,
    required this.rating,
    this.compact = false,
    this.size = 16,
  });

  @override
  Widget build(BuildContext context) {
    final label = Text(
      rating.toStringAsFixed(1),
      style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
    );

    if (compact) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.star, size: size, color: Colors.amber.shade700),
          const SizedBox(width: 2),
          label,
        ],
      );
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (var i = 1; i <= 5; i++)
          Icon(
            rating >= i
                ? Icons.star
                : (rating >= i - 0.5 ? Icons.star_half : Icons.star_border),
            size: size,
            color: Colors.amber.shade700,
          ),
        const SizedBox(width: 4),
        label,
      ],
    );
  }
}
