import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../theme/bhejdu_colors.dart';
import '../widgets/top_app_bar.dart';
import '../utils/preference_manager.dart';

class CheckoutPage extends StatefulWidget {
  const CheckoutPage({super.key});

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  Map? selectedAddress;
  int? selectedAddressId;
  bool loadingAddress = true;

  final String baseUrl =
      "https://darkslategrey-chicken-274271.hostingersite.com/api";

  @override
  void initState() {
    super.initState();
    fetchDefaultAddress();
  }

  /// 🔹 FETCH FIRST SAVED ADDRESS (only first time)
  Future fetchDefaultAddress() async {
    final userId = await PreferenceManager.getUserId();

    final response = await http.post(
      Uri.parse("$baseUrl/get_addresses.php"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"user_id": userId}),
    );

    final data = jsonDecode(response.body);

    if (data["status"] == "success" && data["addresses"].isNotEmpty) {
      setState(() {
        selectedAddress = data["addresses"][0];
        selectedAddressId = selectedAddress!["id"];
        loadingAddress = false;
      });
    } else {
      setState(() => loadingAddress = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    /// ⭐ SAFE TOTAL RECEIVE
    final args =
    ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;

    final int total = args?["total"] ?? 0;

    return Scaffold(
      backgroundColor: BhejduColors.bgLight,
      body: Column(
        children: [
          BhejduAppBar(
            title: "Checkout",
            showBack: true,
            onBackTap: () => Navigator.pop(context),
          ),

          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  // ---------------------- ADDRESS SECTION ----------------------
                  const Text(
                    "Delivery Address",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: BhejduColors.textDark,
                    ),
                  ),
                  const SizedBox(height: 12),

                  /// ⭐ UPDATED — RECEIVE SELECTED ADDRESS
                  GestureDetector(
                    onTap: () async {
                      final result =
                      await Navigator.pushNamed(context, "/address");

                      if (result != null && result is Map) {
                        setState(() {
                          selectedAddress = result;
                          selectedAddressId = result["id"];
                        });
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(14),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 8,
                            offset: Offset(2, 3),
                          ),
                        ],
                      ),
                      child: loadingAddress
                          ? const Center(child: CircularProgressIndicator())
                          : Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(Icons.location_on,
                              color: BhejduColors.primaryBlue, size: 28),
                          const SizedBox(width: 12),

                          Expanded(
                            child: Column(
                              crossAxisAlignment:
                              CrossAxisAlignment.start,
                              children: [
                                Text(
                                  selectedAddress?["title"] ??
                                      "Add Address",
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                    color: BhejduColors.textDark,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  selectedAddress?["address"] ??
                                      "Tap to add delivery address",
                                  style: const TextStyle(
                                    color: BhejduColors.textGrey,
                                    height: 1.4,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          const Icon(Icons.edit,
                              color: BhejduColors.primaryBlue),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 25),

                  // ---------------------- ORDER SUMMARY ----------------------
                  const Text(
                    "Order Summary",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: BhejduColors.textDark,
                    ),
                  ),
                  const SizedBox(height: 12),

                  summaryRow("Grand Total", "₹$total", isBold: true),

                  const SizedBox(height: 40),

                  // ---------------------- PLACE ORDER BUTTON ----------------------
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: selectedAddressId == null
                          ? null
                          : () {
                        Navigator.pushNamed(
                          context,
                          "/orderConfirmation",
                          arguments: {
                            "address_id": selectedAddressId,
                            "total": total,
                          },
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: BhejduColors.primaryBlue,
                        padding:
                        const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      child: const Text(
                        "Place Order",
                        style: TextStyle(
                          fontSize: 17,
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
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

  /// SUMMARY ROW
  Widget summaryRow(String label, String value, {bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: isBold ? 17 : 15,
              fontWeight:
              isBold ? FontWeight.w700 : FontWeight.w500,
              color: BhejduColors.textDark,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: isBold ? 17 : 15,
              fontWeight:
              isBold ? FontWeight.w700 : FontWeight.w600,
              color: BhejduColors.primaryBlue,
            ),
          ),
        ],
      ),
    );
  }
}
