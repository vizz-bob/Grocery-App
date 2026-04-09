import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../theme/bhejdu_colors.dart';
import '../widgets/category_tile.dart';
import '../widgets/top_app_bar.dart';

class CategoriesPage extends StatefulWidget {
  const CategoriesPage({super.key});

  @override
  State<CategoriesPage> createState() => _CategoriesPageState();
}

class _CategoriesPageState extends State<CategoriesPage> {
  List categories = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    fetchCategories();
  }

  Future<void> fetchCategories() async {
    try {
      final response = await http.get(
        Uri.parse(
          "https://darkslategrey-chicken-274271.hostingersite.com/api/get_categories.php",
        ),
      );

      final data = jsonDecode(response.body);

      if (!mounted) return;

      if (data["status"] == "success") {
        setState(() {
          categories = data["categories"] ?? [];
          loading = false;
        });
      } else {
        setState(() => loading = false);
      }
    } catch (e) {
      debugPrint("❌ Category fetch error: $e");
      if (mounted) setState(() => loading = false);
    }
  }

  IconData getIcon(String name) {
    switch (name) {
      case "eco":
        return Icons.eco;
      case "apple":
        return Icons.apple;
      case "fastfood":
        return Icons.fastfood;
      case "local_mall":
        return Icons.local_mall;
      case "local_drink":
        return Icons.local_drink;
      case "local_cafe":
        return Icons.local_cafe;
      default:
        return Icons.category;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: BhejduColors.bgLight,
      body: Column(
        children: [
          BhejduAppBar(
            title: "Categories",
            showBack: true,
            onBackTap: () => Navigator.pop(context),
          ),

          Expanded(
            child: loading
                ? const Center(child: CircularProgressIndicator())
                : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  /// SEARCH BAR
                  Container(
                    height: 48,
                    padding:
                    const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 5,
                          offset: Offset(2, 3),
                        ),
                      ],
                    ),
                    child: const TextField(
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        icon: Icon(
                          Icons.search,
                          color: BhejduColors.primaryBlue,
                        ),
                        hintText: "Search categories",
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  /// CATEGORY GRID
                  GridView.builder(
                    shrinkWrap: true,
                    physics:
                    const NeverScrollableScrollPhysics(),
                    gridDelegate:
                    const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      childAspectRatio: 1.1,
                    ),
                    itemCount: categories.length,
                    itemBuilder: (context, index) {
                      final item = categories[index];

                      return CategoryTile(
                        title: item["name"],
                        count: "${item["total_items"]} Items",
                        icon: getIcon(item["icon"]),
                        onTap: () {
                          Navigator.pushNamed(
                            context,
                            "/product-list",
                            arguments: {
                              "id": item["id"],
                              "name": item["name"],
                            },
                          );
                        },
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
