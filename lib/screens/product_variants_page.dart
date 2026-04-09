import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../theme/bhejdu_colors.dart';
import '../widgets/top_app_bar.dart';
import '../models/cart_model.dart';

class ProductVariantsPage extends StatefulWidget {
  final int productId;
  final String productName;

  const ProductVariantsPage({
    super.key,
    required this.productId,
    required this.productName,
  });

  @override
  State<ProductVariantsPage> createState() => _ProductVariantsPageState();
}

class _ProductVariantsPageState extends State<ProductVariantsPage> {
  List variants = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    fetchVariants();
  }

  Future fetchVariants() async {
    final url =
        "https://darkslategrey-chicken-274271.hostingersite.com/api/get_variants.php";

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "product_id": widget.productId,
        }),
      );

      final data = jsonDecode(response.body);

      if (data["status"] == "success") {
        setState(() {
          variants = data["variants"];
          loading = false;
        });
      } else {
        setState(() => loading = false);
      }
    } catch (e) {
      setState(() => loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: BhejduColors.bgLight,
      body: Column(
        children: [
          BhejduAppBar(
            title: widget.productName,
            showBack: true,
            onBackTap: () => Navigator.pop(context),
          ),

          Expanded(
            child: loading
                ? const Center(child: CircularProgressIndicator())
                : variants.isEmpty
                ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "No variants found for this product.",
                    style: TextStyle(
                      color: BhejduColors.textGrey,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 20),
                  /// ✅ ADD TO CART BUTTON (NO VARIANTS)
                  ElevatedButton.icon(
                    onPressed: () {
                      try {
                        CartModel.addItem(
                          productId: widget.productId,
                          name: widget.productName,
                          price: 0, // No price available
                          image: "",
                        );
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text("${widget.productName} added to cart!"),
                            duration: const Duration(seconds: 1),
                          ),
                        );
                        Navigator.pushNamed(context, "/cart");
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Error: $e")),
                        );
                      }
                    },
                    icon: const Icon(Icons.add_shopping_cart),
                    label: const Text("Add to Cart"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: BhejduColors.primaryBlue,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    ),
                  ),
                ],
              ),
            )
                : ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: variants.length,
              separatorBuilder: (_, __) =>
              const SizedBox(height: 14),
              itemBuilder: (context, index) {
                final item = variants[index];

                return Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: BhejduColors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 6,
                        offset: Offset(1, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment:
                    MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment:
                        CrossAxisAlignment.start,
                        children: [
                          Text(
                            item["size"] ?? "",
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            "₹${item["price"]}",
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color:
                              BhejduColors.primaryBlue,
                            ),
                          ),
                        ],
                      ),

                      /// ✅ FINAL ADD BUTTON
                      Builder(builder: (context) {
                        final variantId = item["id"]?.toString();
                        final priceStr = item["price"]?.toString();
                        final hasValidData = variantId != null &&
                            variantId.isNotEmpty &&
                            priceStr != null &&
                            priceStr.isNotEmpty;

                        return ElevatedButton(
                          onPressed: hasValidData
                              ? () {
                                  final size = item["size"]?.toString() ?? "Regular";
                                  final image = item["image"]?.toString() ?? "";

                                  try {
                                    final cleanPrice = priceStr
                                        .replaceAll(RegExp(r'[^0-9.]'), '')
                                        .split('.')[0];

                                    CartModel.addItem(
                                      productId: widget.productId,
                                      variantId: int.parse(variantId),
                                      name: widget.productName,
                                      size: size,
                                      price: int.parse(cleanPrice),
                                      image: image,
                                    );

                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text("${widget.productName} ($size) added to cart!"),
                                        duration: const Duration(seconds: 1),
                                      ),
                                    );

                                    Navigator.pushNamed(context, "/cart");
                                  } catch (e) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text("Error: $e")),
                                    );
                                  }
                                }
                              : null, // Disabled when data is invalid
                          style: ElevatedButton.styleFrom(
                            backgroundColor: BhejduColors.primaryBlue,
                            disabledBackgroundColor: Colors.grey,
                          ),
                          child: const Text(
                            "ADD",
                            style: TextStyle(color: Colors.white),
                          ),
                        );
                      }),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
