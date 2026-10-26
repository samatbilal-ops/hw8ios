import 'package:flutter/material.dart';

/// Icon used for a category (avatar in the list, tag in the grid).
IconData categoryIcon(String category) {
  switch (category) {
    case 'Sport':
      return Icons.directions_run;
    case 'Classic':
      return Icons.workspace_premium_outlined;
    case 'Casual':
      return Icons.weekend_outlined;
    default:
      return Icons.label_outline;
  }
}

/// Small rounded "pill" with the category name.
class CategoryTag extends StatelessWidget {
  final String category;
  const CategoryTag({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: scheme.secondaryContainer,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        category,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: scheme.onSecondaryContainer,
        ),
      ),
    );
  }
}
