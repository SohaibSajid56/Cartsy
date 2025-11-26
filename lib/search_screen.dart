import 'package:flutter/material.dart';
import 'product_model.dart';
import 'product_card.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<ProductModel> _allProducts = [];
  List<ProductModel> _filteredProducts = [];

  @override
  void initState() {
    super.initState();
    _allProducts = _buildProducts();
    _filteredProducts = _allProducts;
    _searchController.addListener(_onSearchChanged);
  }

  void _onSearchChanged() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredProducts = _allProducts
          .where((p) => p.title.toLowerCase().contains(query))
          .toList();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search Products'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                hintText: 'Search for products...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
            ),
          ),
          Expanded(
            child: _filteredProducts.isEmpty
                ? const Center(child: Text('No products found'))
                : GridView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: _filteredProducts.length,
              gridDelegate:
              const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 0.66,
              ),
              itemBuilder: (context, index) {
                final p = _filteredProducts[index];
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
        ],
      ),
    );
  }

  List<ProductModel> _buildProducts() {
    return [
      ProductModel(
        image: 'assets/images/product-phone.jpg',
        title: 'Premium Smartphone with Advanced Camera System',
        price: 799,
        originalPrice: 999,
        rating: 4.5,
        reviews: 234,
        badge: 'Hot Deal',
        category: 'Mobile Phones', // ✅ added category
      ),
      ProductModel(
        image: 'assets/images/product-laptop.jpg',
        title: 'Professional Laptop - High Performance Computing',
        price: 1299,
        originalPrice: 1599,
        rating: 4.8,
        reviews: 189,
        badge: 'Best Seller',
        category: 'Electronics', // ✅ added category
      ),
      ProductModel(
        image: 'assets/images/product-fashion.jpg',
        title: 'Casual Fashion Collection - Complete Outfit Set',
        price: 89,
        originalPrice: 149,
        rating: 4.3,
        reviews: 456,
        category: 'Fashion', // ✅ added category
      ),
      ProductModel(
        image: 'assets/images/product-bike.jpg',
        title: 'Sports Motorcycle - Premium Edition',
        price: 8999,
        originalPrice: 10999,
        rating: 4.9,
        reviews: 67,
        badge: 'New',
        category: 'Bikes', // ✅ added category
      ),
      ProductModel(
        image: 'assets/images/product-grocery.jpg',
        title: 'Fresh Organic Grocery Basket - Farm Fresh',
        price: 45,
        rating: 4.7,
        reviews: 892,
        category: 'Groceries', // ✅ added category
      ),
      ProductModel(
        image: 'assets/images/product-car.jpg',
        title: 'Luxury Sedan Car - Latest Model',
        price: 45999,
        originalPrice: 49999,
        rating: 4.6,
        reviews: 23,
        badge: 'Featured',
        category: 'Cars', // ✅ added category
      ),
    ];
  }

}
