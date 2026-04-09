import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../theme/bhejdu_colors.dart';
import '../widgets/top_app_bar.dart';
import '../widgets/product_horizontal_card.dart';
import 'product_variants_page.dart';
import '../models/cart_model.dart';

class ProductListingPage extends StatefulWidget {
  final int categoryId;
  final String categoryName;

  const ProductListingPage({
    super.key,
    required this.categoryId,
    required this.categoryName,
  });

  @override
  State<ProductListingPage> createState() => _ProductListingPageState();
}

class _ProductListingPageState extends State<ProductListingPage> {
  List products = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    fetchProducts();
  }

  Future fetchProducts() async {
    const String url =
        "https://darkslategrey-chicken-274271.hostingersite.com/api/get_products.php";

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "category_id": widget.categoryId,
        }),
      );

      final data = jsonDecode(response.body);

      if (data["status"] == "success") {
        setState(() {
          products = data["products"];
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
            title: widget.categoryName,
            showBack: true,
            onBackTap: () => Navigator.pop(context),
          ),

          Expanded(
            child: loading
                ? const Center(child: CircularProgressIndicator())
                : products.isEmpty
                ? const Center(
              child: Text(
                "No products found in this category.",
                style: TextStyle(
                  color: BhejduColors.textGrey,
                  fontSize: 16,
                ),
              ),
            )
                : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: products.length,
              itemBuilder: (context, index) {
                final item = products[index];

                return Padding(
                  padding:
                  const EdgeInsets.only(bottom: 14),
                  child: ProductHorizontalCard(
                    title: item["name"],
                    price: "₹${item["price"]}",
                    image: item["image"],

                    onTapProduct: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              ProductVariantsPage(
                                productId: int.parse(
                                    item["id"].toString()),
                                productName: item["name"],
                              ),
                        ),
                      );
                    },

                    // ✅ UPDATED ADD BUTTON
                    onAdd: () {
                      // Debug: print all item data
                      debugPrint("🛒 ADD TO CART - Item data: $item");

                      // Validate data before parsing
                      final productId = item["id"]?.toString();
                      final productName = item["name"]?.toString() ?? "Unknown";
                      final priceStr = item["price"]?.toString();
                      final image = item["image"]?.toString() ?? "";

                      debugPrint("🛒 Product ID: $productId");
                      debugPrint("🛒 Product Name: $productName");
                      debugPrint("🛒 Price String: $priceStr");
                      debugPrint("🛒 Image: $image");

                      if (productId == null || productId.isEmpty) {
                        debugPrint("❌ ERROR: Invalid product ID");
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Invalid product ID")),
                        );
                        return;
                      }

                      if (priceStr == null || priceStr.isEmpty) {
                        debugPrint("❌ ERROR: Invalid product price");
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Invalid product price")),
                        );
                        return;
                      }

                      try {
                        final parsedProductId = int.parse(productId);

                        // Clean price string - remove currency symbols and decimals
                        final cleanPrice = priceStr
                            .replaceAll(RegExp(r'[^0-9.]'), '') // Remove non-numeric except dot
                            .split('.')[0]; // Take only integer part
                        final parsedPrice = int.parse(cleanPrice);

                        debugPrint("🛒 Parsed Product ID: $parsedProductId");
                        debugPrint("🛒 Cleaned Price String: $cleanPrice");
                        debugPrint("🛒 Parsed Price: $parsedPrice");

                        CartModel.addItem(
                          productId: parsedProductId,
                          name: productName,
                          price: parsedPrice,
                          image: image,
                        );

                        debugPrint("🛒 CartModel.addItem called successfully");
                        debugPrint("🛒 Current cart items: ${CartModel.items}");

                        // ✅ SHOW CONFIRMATION
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text("$productName added to cart!"),
                            duration: const Duration(seconds: 1),
                          ),
                        );

                        // ✅ NAVIGATE TO CART
                        Navigator.pushNamed(context, "/cart");
                      } catch (e, stackTrace) {
                        debugPrint("❌ ERROR adding to cart: $e");
                        debugPrint("❌ Stack trace: $stackTrace");
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Error: $e")),
                        );
                      }
                    },
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
