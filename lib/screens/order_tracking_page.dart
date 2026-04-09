import 'package:flutter/material.dart';
import '../theme/bhejdu_colors.dart';
import '../widgets/top_app_bar.dart';

class OrderTrackingPage extends StatelessWidget {
  const OrderTrackingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: BhejduColors.bgLight,

      body: Column(
        children: [
          /// 🔵 Blue AppBar
          BhejduAppBar(
            title: "Track Order",
            showBack: true,
            onBackTap: () => Navigator.pop(context),
          ),

          const SizedBox(height: 20),

          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Order Status",
                    style: TextStyle(
                      color: BhejduColors.textDark,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 20),

                  /// 🔵 Order Status Steps
                  _statusStep(
                    isActive: true,
                    title: "Order Placed",
                    subtitle: "We have received your order",
                  ),

                  _dividerLine(),

                  _statusStep(
                    isActive: true,
                    title: "Packed",
                    subtitle: "Your items are packed securely",
                  ),

                  _dividerLine(),

                  _statusStep(
                    isActive: false,
                    title: "Out for Delivery",
                    subtitle: "Delivery partner will pick soon",
                  ),

                  _dividerLine(),

                  _statusStep(
                    isActive: false,
                    title: "Delivered",
                    subtitle: "Pending…",
                  ),

                  const Spacer(),

                  Center(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: BhejduColors.primaryBlue,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 40, vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        "Back to Orders",
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// 🔵 STATUS STEP ITEM
  Widget _statusStep({
    required bool isActive,
    required String title,
    required String subtitle,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// Left-side circle icon
        Container(
          height: 26,
          width: 26,
          decoration: BoxDecoration(
            color: isActive
                ? BhejduColors.primaryBlue
                : BhejduColors.borderLight,
            shape: BoxShape.circle,
          ),
          child: Icon(
            isActive ? Icons.check : Icons.circle_outlined,
            color: Colors.white,
            size: isActive ? 18 : 14,
          ),
        ),

        const SizedBox(width: 14),

        /// Text content
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                color: isActive
                    ? BhejduColors.primaryBlue
                    : BhejduColors.textGrey,
                fontSize: 17,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: const TextStyle(
                color: BhejduColors.textGrey,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ],
    );
  }

  /// Divider Line between steps
  Widget _dividerLine() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 14),
      height: 30,
      width: 2,
      color: BhejduColors.borderLight,
    );
  }
}
