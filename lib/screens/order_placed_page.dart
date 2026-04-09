import 'package:flutter/material.dart';
import '../theme/bhejdu_colors.dart';

class OrderPlacedPage extends StatelessWidget {
  const OrderPlacedPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: BhejduColors.bgLight,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.check_circle,
                size: 100, color: BhejduColors.successGreen),
            const SizedBox(height: 16),
            const Text(
              "Order Placed Successfully!",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: BhejduColors.textDark,
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => Navigator.pushNamedAndRemoveUntil(
                  context, "/home", (route) => false),
              style: ElevatedButton.styleFrom(
                backgroundColor: BhejduColors.primaryBlue,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14)),
              ),
              child: const Text("Back to Home"),
            )
          ],
        ),
      ),
    );
  }
}
