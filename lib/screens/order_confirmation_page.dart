import 'package:flutter/material.dart';
import '../theme/bhejdu_colors.dart';

class OrderConfirmationPage extends StatelessWidget {
  const OrderConfirmationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      // ⭐ UPDATED — disable back navigation
      onWillPop: () async => false,
      child: Scaffold(
        backgroundColor: BhejduColors.bgLight,

        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [

                /// SUCCESS ICON
                Container(
                  height: 110,
                  width: 110,
                  decoration: BoxDecoration(
                    color: BhejduColors.successGreenLight,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.check_circle,
                    size: 70,
                    color: BhejduColors.successGreen,
                  ),
                ),

                const SizedBox(height: 26),

                /// TITLE
                const Text(
                  "Order Placed Successfully!",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: BhejduColors.textDark,
                  ),
                ),

                const SizedBox(height: 12),

                /// SUBTEXT
                const Text(
                  "Your groceries will be delivered soon.\nTrack your order in the Orders section.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 15,
                    color: BhejduColors.textGrey,
                  ),
                ),

                const SizedBox(height: 35),

                /// VIEW ORDER BUTTON
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, "/orders");
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: BhejduColors.primaryBlue,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: const Text(
                      "View My Order",
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 14),

                /// BACK TO HOME
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.pushNamedAndRemoveUntil(
                        context,
                        "/home",
                            (route) => false,
                      );
                    },
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(
                        color: BhejduColors.primaryBlue,
                        width: 1.4,
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: const Text(
                      "Back to Home",
                      style: TextStyle(
                        fontSize: 16,
                        color: BhejduColors.primaryBlue,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),

              ],
            ),
          ),
        ),
      ),
    );
  }
}
