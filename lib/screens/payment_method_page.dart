import 'package:flutter/material.dart';
import '../theme/bhejdu_colors.dart';
import '../widgets/top_app_bar.dart';

class PaymentMethodPage extends StatefulWidget {
  const PaymentMethodPage({super.key});

  @override
  State<PaymentMethodPage> createState() => _PaymentMethodPageState();
}

class _PaymentMethodPageState extends State<PaymentMethodPage> {
  String selectedMethod = "UPI";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: BhejduColors.bgLight,

      body: Column(
        children: [
          /// REUSABLE APP BAR
          BhejduAppBar(
            title: "Payment Method",
            showBack: true,
            onBackTap: () => Navigator.pop(context),
          ),

          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// ---- Payment Options Title ----
                  const Text(
                    "Select a Payment Option",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: BhejduColors.textDark,
                    ),
                  ),
                  const SizedBox(height: 20),

                  /// ------- Payment Options Cards -------
                  paymentTile(
                    title: "UPI / GPay / PhonePe",
                    value: "UPI",
                    icon: Icons.account_balance_wallet_outlined,
                  ),
                  const SizedBox(height: 12),

                  paymentTile(
                    title: "Credit / Debit Card",
                    value: "Card",
                    icon: Icons.credit_card,
                  ),
                  const SizedBox(height: 12),

                  paymentTile(
                    title: "Cash on Delivery",
                    value: "COD",
                    icon: Icons.money,
                  ),
                  const SizedBox(height: 12),

                  paymentTile(
                    title: "Net Banking",
                    value: "NetBanking",
                    icon: Icons.language,
                  ),

                  const SizedBox(height: 30),

                  /// ---- Continue Button ----
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pushNamed(context, "/orderConfirm");
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: BhejduColors.primaryBlue,
                        padding: const EdgeInsets.symmetric(
                            vertical: 14, horizontal: 0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        "Continue",
                        style: TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// --------------- PAYMENT OPTION TILE ----------------
  Widget paymentTile({
    required String title,
    required String value,
    required IconData icon,
  }) {
    return InkWell(
      onTap: () {
        setState(() {
          selectedMethod = value;
        });
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: selectedMethod == value
                ? BhejduColors.primaryBlue
                : BhejduColors.borderLight,
            width: 1.4,
          ),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 5,
              offset: Offset(2, 3),
            )
          ],
        ),
        child: Row(
          children: [
            Icon(icon,
                size: 28,
                color: selectedMethod == value
                    ? BhejduColors.primaryBlue
                    : BhejduColors.textGrey),

            const SizedBox(width: 16),

            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  color: BhejduColors.textDark,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),

            /// Radio selection indicator
            Icon(
              selectedMethod == value
                  ? Icons.radio_button_checked
                  : Icons.radio_button_off,
              color: BhejduColors.primaryBlue,
            ),
          ],
        ),
      ),
    );
  }
}
