import 'package:flutter/material.dart';
import '../theme/bhejdu_colors.dart';
import '../widgets/top_app_bar.dart';

class OrdersPage extends StatelessWidget {
  const OrdersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: BhejduColors.bgLight,

      body: Column(
        children: [
          /// 🔵 Custom Blue App Bar
          BhejduAppBar(
            title: "My Orders",
            showBack: true,
            onBackTap: () => Navigator.pop(context),
          ),

          /// PAGE CONTENT
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                _orderTile(
                  orderId: "#ORD1023",
                  date: "3 Dec 2025",
                  status: "Delivered",
                  color: BhejduColors.successGreen,
                  onTrack: () =>
                      Navigator.pushNamed(context, "/orderTracking"),
                ),

                _orderTile(
                  orderId: "#ORD1022",
                  date: "1 Dec 2025",
                  status: "Out for Delivery",
                  color: BhejduColors.offerBlue,
                  onTrack: () =>
                      Navigator.pushNamed(context, "/orderTracking"),
                ),

                _orderTile(
                  orderId: "#ORD1021",
                  date: "29 Nov 2025",
                  status: "Packed",
                  color: BhejduColors.offerOrange,
                  onTrack: () =>
                      Navigator.pushNamed(context, "/orderTracking"),
                ),

                _orderTile(
                  orderId: "#ORD1019",
                  date: "27 Nov 2025",
                  status: "Pending",
                  color: BhejduColors.textGrey,
                  onTrack: () =>
                      Navigator.pushNamed(context, "/orderTracking"),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// ---------------- ORDER TILE WIDGET ----------------
  Widget _orderTile({
    required String orderId,
    required String date,
    required String status,
    required Color color,
    required VoidCallback onTrack,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(bottom: 14),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Order ID + Date
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                orderId,
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                  color: BhejduColors.textDark,
                ),
              ),
              Text(
                date,
                style: const TextStyle(
                  color: BhejduColors.textGrey,
                  fontSize: 14,
                ),
              ),
            ],
          ),

          const SizedBox(height: 8),

          /// Status Badge
          Container(
            padding:
            const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: color.withOpacity(0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              status,
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),

          const SizedBox(height: 12),

          /// Track Order Button
          Align(
            alignment: Alignment.centerRight,
            child: GestureDetector(
              onTap: onTrack,
              child: Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 14, vertical: 10),
                decoration: BoxDecoration(
                  color: BhejduColors.primaryBlue,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  "Track Order",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
