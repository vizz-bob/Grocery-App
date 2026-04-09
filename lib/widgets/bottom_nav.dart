import 'package:flutter/material.dart';
import '../theme/bhejdu_colors.dart';

class BottomNav extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const BottomNav({super.key, required this.currentIndex, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: onTap,
      backgroundColor: BhejduColors.white,
      elevation: 10,
      selectedItemColor: BhejduColors.primaryBlue,
      unselectedItemColor: BhejduColors.textGrey,
      type: BottomNavigationBarType.fixed,
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
        BottomNavigationBarItem(icon: Icon(Icons.grid_view), label: "Categories"),
        BottomNavigationBarItem(icon: Icon(Icons.shopping_bag), label: "Orders"),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
      ],
    );
  }
}
