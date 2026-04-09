import 'package:flutter/material.dart';
import '../theme/bhejdu_colors.dart';

class ReviewCard extends StatelessWidget {
  final String name;
  final String review;

  const ReviewCard({
    super.key,
    required this.name,
    required this.review,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 22,
            backgroundColor: BhejduColors.primaryBlueLight,
            child: Text(
              name[0],
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: BhejduColors.primaryBlue,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              review,
              style: const TextStyle(
                fontSize: 14,
                color: BhejduColors.textDark,
              ),
            ),
          )
        ],
      ),
    );
  }
}
