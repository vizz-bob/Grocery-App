class CartModel {
  static List<Map<String, dynamic>> items = [];

  static void addItem({
    required int productId,
    int? variantId,
    required String name,
    required int price,
    String? size,
    String? image,
  }) {
    final index = items.indexWhere((e) =>
    e["product_id"] == productId &&
        (e["variant_id"] ?? 0) == (variantId ?? 0));

    if (index >= 0) {
      items[index]["qty"] = (items[index]["qty"] ?? 1) + 1;
    } else {
      items.add({
        "product_id": productId,
        "variant_id": variantId ?? 0,
        "name": name,
        "price": price,
        "size": size ?? "",
        "image": image ?? "",
        "qty": 1,
      });
    }
  }
}
