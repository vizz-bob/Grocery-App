import 'package:flutter/material.dart';
import '../theme/bhejdu_colors.dart';
import '../widgets/top_app_bar.dart';

class NotificationsPage extends StatelessWidget {
  const NotificationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: BhejduColors.bgLight,

      body: Column(
        children: [
          /// 🔵 CUSTOM APP BAR
          BhejduAppBar(
            title: "Notifications",
            showBack: true,
            onBackTap: () => Navigator.pop(context),

          ),

          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                /// 🔔 Order Status Notification
                NotificationTile(
                  icon: Icons.local_shipping,
                  title: "Order Out for Delivery",
                  message: "Your order #1245 is on the way.",
                  time: "10 min ago",
                  bgColor: BhejduColors.primaryBlueLight,
                ),

                NotificationTile(
                  icon: Icons.check_circle,
                  title: "Order Delivered",
                  message: "Your order #1234 has been successfully delivered.",
                  time: "1 hour ago",
                  bgColor: BhejduColors.successGreenLight,
                ),

                NotificationTile(
                  icon: Icons.local_offer,
                  title: "Special Offer",
                  message: "Flat 20% OFF on all grocery items today!",
                  time: "3 hours ago",
                  bgColor: BhejduColors.offerYellow.withOpacity(0.2),
                ),

                NotificationTile(
                  icon: Icons.discount,
                  title: "New Cashback Reward",
                  message: "You earned ₹50 cashback on your last order.",
                  time: "Yesterday",
                  bgColor: BhejduColors.offerBlue.withOpacity(0.18),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// ------------------------------------------------------
/// 🔔 REUSABLE NOTIFICATION TILE WIDGET
/// ------------------------------------------------------

class NotificationTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String message;
  final String time;
  final Color bgColor;

  const NotificationTile({
    super.key,
    required this.icon,
    required this.title,
    required this.message,
    required this.time,
    required this.bgColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
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
          /// ICON BOX
          Container(
            height: 55,
            width: 55,
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, color: BhejduColors.primaryBlue, size: 30),
          ),

          const SizedBox(width: 16),

          /// TEXT CONTENT
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: BhejduColors.textDark,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  message,
                  style: const TextStyle(
                    fontSize: 13,
                    color: BhejduColors.textGrey,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  time,
                  style: const TextStyle(
                    fontSize: 12,
                    color: BhejduColors.textGrey,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
