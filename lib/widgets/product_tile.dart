import 'package:flutter/material.dart';
import '../theme/bhejdu_colors.dart';

class ProductTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final String price;
  final IconData icon;
  final VoidCallback onTap;

  const ProductTile({
    super.key,
    required this.title,
    required this.subtitle,
    required this.price,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: BhejduColors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 6,
            offset: Offset(2, 3),
          ),
        ],
      ),

      child: Row(
        children: [
          Container(
            height: 55,
            width: 55,
            decoration: BoxDecoration(
              color: BhejduColors.primaryBlueLight,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, size: 28, color: BhejduColors.primaryBlue),
          ),

          const SizedBox(width: 14),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                      color: BhejduColors.textDark,
                    )),
                const SizedBox(height: 4),
                Text(subtitle,
                    style: const TextStyle(
                      color: BhejduColors.textGrey,
                      fontSize: 14,
                    )),
              ],
            ),
          ),

          Text(
            price,
            style: const TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w700,
              color: BhejduColors.primaryBlue,
            ),
          )
        ],
      ),
    );
  }
}
