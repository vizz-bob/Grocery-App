import 'package:flutter/material.dart';
import '../theme/bhejdu_colors.dart';

class BhejduSearchBar extends StatelessWidget {
  final VoidCallback onMenuTap;

  const BhejduSearchBar({super.key, required this.onMenuTap});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Hamburger icon
        IconButton(
          icon: const Icon(Icons.menu, size: 28),
          onPressed: onMenuTap,
        ),

        // Search box
        Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: const TextField(
              decoration: InputDecoration(
                hintText: "Search for groceries...",
                border: InputBorder.none,
                icon: Icon(Icons.search),
              ),
            ),
          ),
        ),

        // Login button instead of bell
        IconButton(
          icon: const Icon(Icons.login),
          onPressed: () {
            Navigator.pushNamed(context, "/login");
          },
        ),
      ],
    );
  }
}
