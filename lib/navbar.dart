import 'package:flutter/material.dart';
import 'search_screen.dart'; // Make sure you create this file
import 'profile_screen.dart';
import 'cart_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';


class Navbar extends StatelessWidget implements PreferredSizeWidget {
  const Navbar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: const Text('Cartsy'),
      centerTitle: false,
      elevation: 0,
      surfaceTintColor: Colors.transparent,
      actions: [
        // Search Icon
        IconButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const SearchScreen()),
            );
          },
          icon: const Icon(Icons.search),
        ),

        // Cart Icon
        IconButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const CartScreen()),
            );
          },
          icon: const Icon(Icons.shopping_cart_outlined),
        ),

        IconButton(
          icon: const Icon(Icons.logout),
          onPressed: () async {
            await FirebaseAuth.instance.signOut();
          },
        ),

        // Profile Icon
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ProfileScreen()),
              );
            },
            icon: const Icon(Icons.person_outline),
          ),

        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
