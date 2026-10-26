import 'package:flutter/material.dart';

/// One place that shows a product photo.
/// - path starting with "assets/"  -> your own photo from the assets folder
/// - anything else (https://...)   -> photo from the internet
/// If the photo cannot be loaded, a neutral placeholder is shown (no crash).
class ProductImage extends StatelessWidget {
  final String path;
  final double? width;
  final double? height;
  final BoxFit fit;

  const ProductImage({
    super.key,
    required this.path,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
  });

  Widget _placeholder() {
    return Container(
      width: width,
      height: height,
      color: Colors.grey.shade300,
      child: const Center(
        child: Icon(Icons.image_not_supported, color: Colors.black38),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (path.startsWith('assets/')) {
      return Image.asset(
        path,
        width: width,
        height: height,
        fit: fit,
        errorBuilder: (c, e, s) => _placeholder(),
      );
    }
    return Image.network(
      path,
      width: width,
      height: height,
      fit: fit,
      loadingBuilder: (c, child, progress) => progress == null
          ? child
          : Container(
              width: width,
              height: height,
              color: Colors.grey.shade200,
              child: const Center(
                child: SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              ),
            ),
      errorBuilder: (c, e, s) => _placeholder(),
    );
  }
}
