import 'package:flutter/material.dart';
import '../theme/bhejdu_colors.dart';

class CategoryTile extends StatelessWidget {
  final String title;
  final String count;
  final IconData icon;
  final VoidCallback? onTap;

  const CategoryTile({
    super.key,
    required this.title,
    required this.count,
    required this.icon,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: BhejduColors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 6,
              offset: Offset(2, 3),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            /// ICON
            Container(
              height: 60,
              width: 60,
              decoration: BoxDecoration(
                color: BhejduColors.primaryBlueLight,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(
                icon,
                size: 32,
                color: BhejduColors.primaryBlue,
              ),
            ),

            const SizedBox(height: 12),

            /// TITLE
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: BhejduColors.textDark,
              ),
            ),

            const SizedBox(height: 4),

            /// COUNT
            Text(
              count,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: BhejduColors.textGrey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
