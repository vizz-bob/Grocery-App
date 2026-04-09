import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../theme/bhejdu_colors.dart';

class BhejduAppBar extends StatelessWidget {
  final String title;
  final bool showBack;
  final VoidCallback? onBackTap;
  final VoidCallback? onMenuTap;
  final bool showAccountIcon;

  const BhejduAppBar({
    super.key,
    required this.title,
    this.showBack = false,
    this.onBackTap,
    this.onMenuTap,
    this.showAccountIcon = true,
  });

  Future<void> _handleAccountTap(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getInt("user_id");

    if (userId != null) {
      Navigator.pushNamed(context, "/profile");
    } else {
      Navigator.pushNamed(context, "/login");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 45, left: 16, right: 16, bottom: 16),
      decoration: const BoxDecoration(
        color: BhejduColors.primaryBlue,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(22),
          bottomRight: Radius.circular(22),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          /// LEFT
          GestureDetector(
            onTap: () {
              if (showBack) {
                onBackTap != null
                    ? onBackTap!()
                    : Navigator.pop(context);
              } else {
                onMenuTap != null
                    ? onMenuTap!()
                    : Scaffold.of(context).openDrawer();
              }
            },
            child: Icon(
              showBack ? Icons.arrow_back : Icons.menu,
              color: Colors.white,
              size: 26,
            ),
          ),

          /// CENTER
          Text(
            title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),

          /// RIGHT
          showAccountIcon
              ? GestureDetector(
            onTap: () => _handleAccountTap(context),
            child: const Icon(
              Icons.person,
              color: Colors.white,
              size: 26,
            ),
          )
              : const SizedBox(width: 26),
        ],
      ),
    );
  }
}
