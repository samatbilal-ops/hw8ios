import 'package:flutter/material.dart';

import '../models/product.dart';
import 'category_tag.dart';
import 'rating_stars.dart';

/// One row of the List Feed: avatar, title, category tag, stars, price.
class CatalogListItem extends StatelessWidget {
  final Product product;
  final VoidCallback onTap;

  const CatalogListItem({super.key, required this.product, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    // Opaque surface colour: otherwise the red Dismissible background
    // would shine through the row while swiping.
    return Material(
      color: theme.colorScheme.surface,
      child: ListTile(
        onTap: onTap,
        leading: CircleAvatar(
          backgroundColor: theme.colorScheme.primaryContainer,
          foregroundColor: theme.colorScheme.onPrimaryContainer,
          child: Icon(categoryIcon(product.category)),
        ),
        title: Text(
          product.name,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Wrap(
            spacing: 8,
            runSpacing: 4,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              CategoryTag(category: product.category),
              RatingStars(rating: product.rating, size: 14),
            ],
          ),
        ),
        trailing: Text(
          '\$${product.price.toStringAsFixed(2)}',
          style: theme.textTheme.titleSmall?.copyWith(
            color: theme.colorScheme.primary,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
