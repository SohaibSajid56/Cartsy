import 'package:flutter/material.dart';
import 'product_card.dart';
import 'product_model.dart';

class CategoryScreen extends StatelessWidget {
  final String categoryName;
  final List<ProductModel> products;

  const CategoryScreen({
    super.key,
    required this.categoryName,
    required this.products,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(categoryName)),
      body: products.isEmpty
          ? const Center(child: Text('No products available'))
          : Padding(
        padding: const EdgeInsets.all(12.0),
        child: GridView.builder(
          itemCount: products.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 0.66,
          ),
          itemBuilder: (context, index) {
            final p = products[index];
            return ProductCard(
              image: p.image,
              title: p.title,
              price: p.price,
              originalPrice: p.originalPrice,
              rating: p.rating,
              reviews: p.reviews,
              badge: p.badge,
              category: p.category,
            );
          },
        ),
      ),
    );
  }
}
