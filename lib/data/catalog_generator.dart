import 'dart:math';

import '../models/product.dart';
import 'products_data.dart';

final Random _rng = Random();

const List<String> _names = [
  'Neo Runner',
  'Skyline Low',
  'Street Pulse',
  'Retro Wave',
  'Cloud Walker',
  'Metro Classic',
  'Turbo Dash',
  'Canvas Drift',
];

const List<String> _categories = ['Sport', 'Classic', 'Casual'];

/// Simulates "a new item arrived from the server" (used by Pull-to-Refresh).
/// [n] is a running counter, so every generated id is unique: new1, new2, ...
Product generateProduct(int n) {
  final category = _categories[_rng.nextInt(_categories.length)];
  final rating = double.parse((3.8 + _rng.nextDouble() * 1.2).toStringAsFixed(1));
  final price = 60 + _rng.nextInt(120) + 0.99;

  return Product(
    id: 'new$n',
    name: '${_names[_rng.nextInt(_names.length)]} #$n',
    brand: 'SoleLab',
    category: category,
    price: price,
    rating: rating,
    reviews: 20 + _rng.nextInt(500),
    tags: ['New Arrival', category],
    sizes: const [39, 40, 41, 42, 43, 44, 45],
    description:
        'Freshly loaded from the "server" by pull-to-refresh. A brand new arrival in the SoleStore catalog.',
    imageUrl: kProducts[n % kProducts.length].imageUrl,
  );
}
