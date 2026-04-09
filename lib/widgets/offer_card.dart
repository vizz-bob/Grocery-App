import 'package:flutter/material.dart';
import '../theme/bhejdu_colors.dart';

class OfferCard extends StatelessWidget {
  final String title;
  final Color bgColor;
  final VoidCallback? onTap; // ✅ MADE OPTIONAL

  const OfferCard({
    super.key,
    required this.title,
    required this.bgColor,
    this.onTap, // ✅ NOT REQUIRED NOW
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap ?? () {}, // ✅ SAFE DEFAULT
      borderRadius: BorderRadius.circular(14),
      child: Container(
        width: 110,
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Center(
          child: Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
              fontSize: 12,
              height: 1.3,
            ),
          ),
        ),
      ),
    );
  }
}
