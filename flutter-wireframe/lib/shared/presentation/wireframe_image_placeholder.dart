import 'package:flutter/material.dart';

class WireframeImagePlaceholder extends StatelessWidget {
  const WireframeImagePlaceholder({
    super.key,
    this.semanticLabel = 'Dish image placeholder',
  });

  final String semanticLabel;

  @override
  Widget build(BuildContext context) => Semantics(
    label: semanticLabel,
    image: false,
    child: ColoredBox(
      color: Colors.grey.shade300,
      child: const Center(child: Icon(Icons.image_outlined, color: Colors.grey)),
    ),
  );
}
