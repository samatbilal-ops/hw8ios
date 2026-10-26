import 'package:flutter/material.dart';

import '../data/catalog_generator.dart';
import '../data/products_data.dart';
import '../models/product.dart';
import '../widgets/catalog_grid_card.dart';
import '../widgets/catalog_list_item.dart';
import '../widgets/dismiss_background.dart';
import '../widgets/empty_catalog.dart';

enum CatalogViewMode { list, grid }

/// Lab 8: Smart Catalog & Infinite Feed.
///  - List Feed  : ListView.separated (lazy)
///  - Grid       : GridView.builder, 2 columns, childAspectRatio 0.72
///  - Pull-to-Refresh : RefreshIndicator + Future.delayed(1500 ms)
///  - Swipe-to-Delete : Dismissible(key: ValueKey(id)) + SnackBar UNDO
///  - Empty state with "Reset Catalog"
class CatalogTab extends StatefulWidget {
  final ValueChanged<Product> onOpen;
  const CatalogTab({super.key, required this.onOpen});

  @override
  State<CatalogTab> createState() => _CatalogTabState();
}

class _CatalogTabState extends State<CatalogTab> {
  // Local, mutable copy of the seed data (kProducts itself is never changed,
  // so Feed and Favorites tabs keep working).
  final List<Product> _items = List.of(kProducts);

  CatalogViewMode _mode = CatalogViewMode.list;
  int _generatedCount = 0;

  bool get _isGrid => _mode == CatalogViewMode.grid;

  // ---------- Pull-to-Refresh ----------
  Future<void> _refresh() async {
    // Simulated network request.
    await Future.delayed(const Duration(milliseconds: 1500));
    if (!mounted) return;
    setState(() {
      _generatedCount++;
      _items.insert(0, generateProduct(_generatedCount)); // very top, index 0
    });
  }

  // ---------- Swipe-to-Delete + UNDO ----------
  void _remove(Product product) {
    final index = _items.indexWhere((p) => p.id == product.id);
    if (index == -1) return;

    setState(() => _items.removeAt(index));

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 4),
          content: Text(
            '"${product.name}" removed',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          action: SnackBarAction(
            label: 'UNDO',
            onPressed: () {
              if (!mounted || _items.any((p) => p.id == product.id)) return;
              setState(() {
                // Back to the ORIGINAL index (clamped if the list got shorter).
                final at = index > _items.length ? _items.length : index;
                _items.insert(at, product);
              });
            },
          ),
        ),
      );
  }

  // ---------- Empty state: restore seed data ----------
  void _reset() {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    setState(() {
      _items
        ..clear()
        ..addAll(kProducts);
    });
  }

  // Shared Dismissible wrapper for list rows and grid cards.
  Widget _dismissible(Product p, Widget child, {double radius = 0}) {
    return Dismissible(
      key: ValueKey(p.id), // mandatory unique key
      direction: DismissDirection.endToStart, // right-to-left only
      background: DismissBackground(radius: radius),
      onDismissed: (_) => _remove(p),
      child: child,
    );
  }

  Widget _buildList() {
    return RefreshIndicator(
      key: const ValueKey('list-view'),
      onRefresh: _refresh,
      child: ListView.separated(
        // Needed so pull-to-refresh also works with few items.
        physics: const AlwaysScrollableScrollPhysics(),
        itemCount: _items.length,
        separatorBuilder: (_, __) => const Divider(height: 1, thickness: 1),
        itemBuilder: (context, i) {
          final p = _items[i];
          return _dismissible(
            p,
            CatalogListItem(product: p, onTap: () => widget.onOpen(p)),
          );
        },
      ),
    );
  }

  Widget _buildGrid() {
    return RefreshIndicator(
      key: const ValueKey('grid-view'),
      onRefresh: _refresh,
      child: GridView.builder(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(12),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.72,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
        ),
        itemCount: _items.length,
        itemBuilder: (context, i) {
          final p = _items[i];
          return _dismissible(
            p,
            CatalogGridCard(product: p, onTap: () => widget.onOpen(p)),
            radius: CatalogGridCard.radius,
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Catalog'),
        actions: [
          // Toggle List <-> Grid
          IconButton(
            tooltip: _isGrid ? 'Show as list' : 'Show as grid',
            onPressed: () => setState(() => _mode =
                _isGrid ? CatalogViewMode.list : CatalogViewMode.grid),
            icon: Icon(_isGrid ? Icons.view_list : Icons.grid_view),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: _items.isEmpty
          ? EmptyCatalog(onReset: _reset)
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 10, 16, 6),
                  child: Row(
                    children: [
                      Text(
                        '${_items.length} items',
                        style: theme.textTheme.titleSmall
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      const Spacer(),
                      Icon(Icons.swipe_left,
                          size: 16, color: Colors.grey.shade600),
                      const SizedBox(width: 4),
                      Text(
                        'swipe to delete · pull to refresh',
                        style: theme.textTheme.bodySmall
                            ?.copyWith(color: Colors.grey.shade600),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 250),
                    child: _isGrid ? _buildGrid() : _buildList(),
                  ),
                ),
              ],
            ),
    );
  }
}
