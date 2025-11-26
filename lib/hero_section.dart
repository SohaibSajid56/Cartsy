import 'package:flutter/material.dart';

class HeroSection extends StatefulWidget {
  final VoidCallback onShopNow;

  const HeroSection({super.key, required this.onShopNow});

  @override
  State<HeroSection> createState() => _HeroSectionState();
}

class _HeroSectionState extends State<HeroSection> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;

  final List<String> _images = [
    'assets/images/hero-bg.jpg',
    'assets/images/hero-bg2.jpg',
    'assets/images/hero-bg3.jpg',
    'assets/images/hero-bg4.jpg',
  ];

  @override
  void initState() {
    super.initState();

    // Auto-scroll every 4 seconds like Nike app
    Future.doWhile(() async {
      await Future.delayed(const Duration(seconds: 4));

      if (!mounted) return false;

      int nextPage = _currentIndex + 1;
      if (nextPage >= _images.length) nextPage = 0;

      _pageController.animateToPage(
        nextPage,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );

      return true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Column(
      children: [
        SizedBox(
          height: 230,
          child: PageView.builder(
            controller: _pageController,
            itemCount: _images.length,
            onPageChanged: (index) {
              setState(() => _currentIndex = index);
            },
            itemBuilder: (context, index) {
              return Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(18),
                  child: Image.asset(
                    _images[index],
                    width: width * 0.88,   // ✅ Not full screen (Like Nike)
                    height: 230,
                    fit: BoxFit.cover,
                  ),
                ),
              );
            },
          ),
        ),

        const SizedBox(height: 12),

        // Dot indicators
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            _images.length,
                (index) => AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              margin: const EdgeInsets.symmetric(horizontal: 4),
              width: _currentIndex == index ? 14 : 8,
              height: 8,
              decoration: BoxDecoration(
                color: _currentIndex == index ? Colors.black : Colors.grey.shade400,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        ),

        const SizedBox(height: 15),

        ElevatedButton(
          onPressed: widget.onShopNow,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white30,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 14),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
          child: const Text(
            "Shop Now",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }
}
