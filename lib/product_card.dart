import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'cart.dart';
import 'product_model.dart';
import 'sign_in_screen.dart';

class ProductCard extends StatelessWidget {
  final String image;
  final String title;
  final double price;
  final double? originalPrice;
  final double rating;
  final int reviews;
  final String? badge;
  final String category;

  const ProductCard({
    super.key,
    required this.image,
    required this.title,
    required this.price,
    this.originalPrice,
    required this.rating,
    required this.reviews,
    this.badge,
    required this.category,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final user = FirebaseAuth.instance.currentUser; // ✅ Firebase login check

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 2,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Product image
          Expanded(
            child: Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                  child: Image.asset(
                    image,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (c, e, s) => Container(
                      color: theme.colorScheme.surfaceVariant,
                      child: const Center(child: Icon(Icons.image, size: 40)),
                    ),
                  ),
                ),
                if (badge != null)
                  Positioned(
                    top: 8,
                    left: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primary,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        badge!,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),

          // Info area
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Product title
                Text(
                  title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 6),

                // Price & rating row
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        '\$${price.toStringAsFixed(0)}',
                        style: TextStyle(
                          color: theme.colorScheme.primary,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 6),
                    if (originalPrice != null)
                      Flexible(
                        child: Text(
                          '\$${originalPrice!.toStringAsFixed(0)}',
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            decoration: TextDecoration.lineThrough,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                    const Spacer(),
                    Icon(Icons.star, size: 16, color: Colors.amber.shade700),
                    const SizedBox(width: 4),
                    Text(
                      rating.toString(),
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
                const SizedBox(height: 6),

                // Add to Cart button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      if (user == null) {
                        // ✅ Redirect to Sign In if user not logged in
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const SignInScreen()),
                        );
                        return;
                      }

                      // ✅ Add item to cart
                      Cart.add(ProductModel(
                        image: image,
                        title: title,
                        price: price,
                        originalPrice: originalPrice,
                        rating: rating,
                        reviews: reviews,
                        badge: badge,
                        category: category,
                      ));

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('$title added to cart!')),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size.fromHeight(40),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text('Add to Cart'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
