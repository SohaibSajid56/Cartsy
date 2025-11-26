class ProductModel {
  final String image;
  final String title;
  final double price;
  final double? originalPrice;
  final double rating;
  final int reviews;
  final String? badge;
  final String category; // <-- Added category

  ProductModel({
    required this.image,
    required this.title,
    required this.price,
    this.originalPrice,
    required this.rating,
    required this.reviews,
    this.badge,
    required this.category, // <-- make it required
  });
}
