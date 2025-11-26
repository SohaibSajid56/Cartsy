import 'package:flutter/material.dart';
import 'navbar.dart';
import 'hero_section.dart';
import 'category_card.dart';
import 'product_card.dart';
import 'footer.dart';
import 'category_model.dart';
import 'product_model.dart';
import 'category_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();
  final GlobalKey _featuredKey = GlobalKey(); // 👈 for locating "Featured Products"

  late AnimationController _heroAnimationController;
  late AnimationController _categoryAnimationController;
  late AnimationController _productAnimationController;

  late Animation<double> _heroAnimation;
  late Animation<double> _categoryAnimation;
  late Animation<double> _productAnimation;

  @override
  void initState() {
    super.initState();

    // Animations
    _heroAnimationController = AnimationController(vsync: this, duration: const Duration(milliseconds: 800));
    _heroAnimation = CurvedAnimation(parent: _heroAnimationController, curve: Curves.easeIn);
    _heroAnimationController.forward();

    _categoryAnimationController = AnimationController(vsync: this, duration: const Duration(milliseconds: 1000));
    _categoryAnimation = CurvedAnimation(parent: _categoryAnimationController, curve: Curves.easeIn);
    _categoryAnimationController.forward();

    _productAnimationController = AnimationController(vsync: this, duration: const Duration(milliseconds: 1200));
    _productAnimation = CurvedAnimation(parent: _productAnimationController, curve: Curves.easeIn);
    _productAnimationController.forward();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _heroAnimationController.dispose();
    _categoryAnimationController.dispose();
    _productAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final categories = _buildCategories();
    final featuredProducts = _buildFeaturedProducts();

    return Scaffold(
      appBar: const Navbar(),
      body: SingleChildScrollView(
        controller: _scrollController,
        child: Column(
          children: [
            // 🔹 Hero Section (with smooth scroll)
            FadeTransition(
              opacity: _heroAnimation,
              child: HeroSection(
                onShopNow: () {
                  _scrollToFeatured(); // 👈 scroll instead of navigating
                },
              ),
            ),

            // 🔹 Categories Section
            FadeTransition(
              opacity: _categoryAnimation,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12),
                child: Column(
                  children: [
                    _sectionHeader(context, 'Shop by Category', 'Explore our wide range of product categories'),
                    const SizedBox(height: 12),
                    GridView.builder(
                      itemCount: categories.length,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 12,
                        crossAxisSpacing: 12,
                        childAspectRatio: 1.05,
                      ),
                      itemBuilder: (context, index) {
                        final c = categories[index];
                        return GestureDetector(
                          onTap: () {
                            final categoryProducts = featuredProducts
                                .where((p) => p.category == c.title)
                                .toList();
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => CategoryScreen(
                                  categoryName: c.title,
                                  products: categoryProducts,
                                ),
                              ),
                            );
                          },
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeOut,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: const [
                                BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 4)),
                              ],
                            ),
                            child: CategoryCard(
                              icon: c.icon,
                              title: c.title,
                              itemCount: c.itemCount,
                              gradient: c.gradient,
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),

            // 🔹 Featured Products Section
            FadeTransition(
              opacity: _productAnimation,
              child: Container(
                key: _featuredKey, // 👈 scroll target
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12),
                child: Column(
                  children: [
                    _sectionHeader(context, 'Featured Products', 'Check out our best deals and popular items'),
                    const SizedBox(height: 12),
                    GridView.builder(
                      itemCount: featuredProducts.length,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 12,
                        crossAxisSpacing: 12,
                        childAspectRatio: 0.66,
                      ),
                      itemBuilder: (context, index) {
                        final p = featuredProducts[index];
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
                  ],
                ),
              ),
            ),

            const SizedBox(height: 12),
            const Footer(),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  // 🔹 Helper function to scroll smoothly to Featured Products
  void _scrollToFeatured() {
    Scrollable.ensureVisible(
      _featuredKey.currentContext!,
      duration: const Duration(milliseconds: 700),
      curve: Curves.easeInOut,
    );
  }

  Widget _sectionHeader(BuildContext context, String title, String subtitle) {
    return Column(
      children: [
        Text(
          title,
          style: Theme.of(context)
              .textTheme
              .headlineSmall
              ?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 6),
        Text(
          subtitle,
          style: Theme.of(context)
              .textTheme
              .bodyMedium
              ?.copyWith(color: Colors.grey),
        ),
      ],
    );
  }

  List<CategoryModel> _buildCategories() {
    return [
      CategoryModel(icon: Icons.smartphone, title: 'Mobile Phones', itemCount: '2,543 items', gradient: [Colors.deepPurple, Colors.purpleAccent]),
      CategoryModel(icon: Icons.laptop, title: 'Electronics', itemCount: '1,892 items', gradient: [Colors.teal, Colors.tealAccent]),
      CategoryModel(icon: Icons.checkroom, title: 'Fashion', itemCount: '5,234 items', gradient: [Colors.orange, Colors.deepOrangeAccent]),
      CategoryModel(icon: Icons.directions_car, title: 'Cars', itemCount: '432 items', gradient: [Colors.amber, Colors.deepOrange]),
      CategoryModel(icon: Icons.pedal_bike, title: 'Bikes', itemCount: '876 items', gradient: [Colors.redAccent, Colors.red]),
      CategoryModel(icon: Icons.shopping_basket, title: 'Groceries', itemCount: '3,456 items', gradient: [Colors.green, Colors.lightGreen]),
      CategoryModel(icon: Icons.home, title: 'Home & Kitchen', itemCount: '2,109 items', gradient: [Colors.blueGrey, Colors.blue]),
      CategoryModel(icon: Icons.watch, title: 'Accessories', itemCount: '1,567 items', gradient: [Colors.pinkAccent, Colors.purple]),
    ];
  }

  List<ProductModel> _buildFeaturedProducts() {
    return [
      ProductModel(image: 'assets/images/product-phone.jpg', title: 'Premium Smartphone with Advanced Camera System', price: 799, originalPrice: 999, rating: 4.5, reviews: 234, badge: 'Hot Deal', category: 'Mobile Phones'),
      ProductModel(image: 'assets/images/product-laptop.jpg', title: 'Professional Laptop - High Performance Computing', price: 1299, originalPrice: 1599, rating: 4.8, reviews: 189, badge: 'Best Seller', category: 'Electronics'),
      ProductModel(image: 'assets/images/product-fashion.jpg', title: 'Casual Fashion Collection - Complete Outfit Set', price: 89, originalPrice: 149, rating: 4.3, reviews: 456, category: 'Fashion'),
      ProductModel(image: 'assets/images/product-bike.jpg', title: 'Sports Motorcycle - Premium Edition', price: 8999, originalPrice: 10999, rating: 4.9, reviews: 67, badge: 'New', category: 'Bikes'),
      ProductModel(image: 'assets/images/product-grocery.jpg', title: 'Fresh Organic Grocery Basket - Farm Fresh', price: 45, rating: 4.7, reviews: 892, category: 'Groceries'),
      ProductModel(image: 'assets/images/product-car.jpg', title: 'Luxury Sedan Car - Latest Model', price: 45999, originalPrice: 49999, rating: 4.6, reviews: 23, badge: 'Featured', category: 'Cars'),
    ];
  }
}
