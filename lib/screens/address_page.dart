import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../theme/bhejdu_colors.dart';
import '../widgets/top_app_bar.dart';
import '../utils/preference_manager.dart';

class AddressManagementPage extends StatefulWidget {
  const AddressManagementPage({super.key});

  @override
  State<AddressManagementPage> createState() =>
      _AddressManagementPageState();
}

class _AddressManagementPageState
    extends State<AddressManagementPage> {
  List addresses = [];
  bool isLoading = true;

  final String baseUrl =
      "https://darkslategrey-chicken-274271.hostingersite.com/api";

  @override
  void initState() {
    super.initState();
    fetchAddresses();
  }

  Future fetchAddresses() async {
    final userId = await PreferenceManager.getUserId();

    try {
      final response = await http.post(
        Uri.parse("$baseUrl/get_addresses.php"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"user_id": userId}),
      );

      final data = jsonDecode(response.body);

      setState(() {
        addresses = data["addresses"] ?? [];
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        addresses = [];
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error loading addresses: $e")),
      );
    }
  }

  Future addAddress({
    required String type,
    required String name,
    required String phone,
    required String house,
    required String building,
    required String street,
    required String landmark,
    required String city,
    required String pincode,
    required String fullAddress,
  }) async {
    final userId = await PreferenceManager.getUserId();

    debugPrint("📍 ADD ADDRESS - userId: $userId");
    debugPrint("📍 Address type: $type");
    debugPrint("📍 Name: $name");
    debugPrint("📍 Phone: $phone");

    if (userId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please login first")),
      );
      return;
    }

    // DEV MODE: Store locally
    if (userId == 999) {
      final prefs = await SharedPreferences.getInstance();
      final savedAddresses = prefs.getStringList('dev_addresses') ?? [];

      final newAddress = {
        "id": DateTime.now().millisecondsSinceEpoch,
        "title": type,
        "address": fullAddress,
      };

      savedAddresses.add(jsonEncode(newAddress));
      await prefs.setStringList('dev_addresses', savedAddresses);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Address saved successfully")),
      );

      fetchAddresses();
      return;
    }

    try {
      debugPrint("📍 Sending to API...");
      
      final response = await http.post(
        Uri.parse("$baseUrl/add_address.php"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "user_id": userId,
          "title": type,
          "name": name,
          "phone": phone,
          "address_line1": "$house, $building".trim(),
          "address_line2": street,
          "landmark": landmark,
          "city": city,
          "pincode": pincode,
          "address": fullAddress,
        }),
      );

      debugPrint("📍 Response status: ${response.statusCode}");
      debugPrint("📍 Response body: ${response.body}");

      final data = jsonDecode(response.body);

      if (data["status"] == "success") {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Address saved successfully")),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(data["message"] ?? "Failed to save address")),
        );
      }

      fetchAddresses();
    } catch (e) {
      debugPrint("📍 Error: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error saving address: $e")),
      );
    }
  }

  Future updateAddress(int id, String type, String address) async {
    await http.post(
      Uri.parse("$baseUrl/update_address.php"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "id": id,
        "title": type,
        "address": address,
      }),
    );

    fetchAddresses();
  }

  Future deleteAddress(int id) async {
    final userId = await PreferenceManager.getUserId();

    // DEV MODE: Delete locally
    if (userId == 999) {
      final prefs = await SharedPreferences.getInstance();
      final savedAddresses = prefs.getStringList('dev_addresses') ?? [];

      savedAddresses.removeWhere((str) {
        final addr = jsonDecode(str);
        return addr["id"] == id;
      });

      await prefs.setStringList('dev_addresses', savedAddresses);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Address deleted")),
      );

      fetchAddresses();
      return;
    }

    try {
      final response = await http.post(
        Uri.parse("$baseUrl/delete_address.php"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "id": id,
          "user_id": userId,
        }),
      );

      final data = jsonDecode(response.body);

      if (data["status"] == "success") {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Address deleted")),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(data["message"] ?? "Failed to delete address")),
        );
      }

      fetchAddresses();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error deleting address: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: BhejduColors.bgLight,
      body: Column(
        children: [
          BhejduAppBar(
            title: "My Addresses",
            showBack: true,
            onBackTap: () => Navigator.pop(context),
          ),

          Padding(
            padding: const EdgeInsets.all(16),
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: BhejduColors.primaryBlue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                padding:
                const EdgeInsets.symmetric(vertical: 14),
              ),
              icon: const Icon(Icons.add_location_alt,
                  color: Colors.white),
              label: const Text(
                "Add New Address",
                style:
                TextStyle(color: Colors.white, fontSize: 16),
              ),
              onPressed: () => _addressBottomSheet(),
            ),
          ),

          Expanded(
            child: isLoading
                ? const Center(
                child: CircularProgressIndicator())
                : ListView.builder(
              padding: const EdgeInsets.symmetric(
                  horizontal: 16),
              itemCount: addresses.length,
              itemBuilder: (context, index) {
                final item = addresses[index];

                /// ✅ TAP TO SELECT ADDRESS
                return GestureDetector(
                  onTap: () {
                    Navigator.pop(context, item);
                  },
                  child: Container(
                    margin:
                    const EdgeInsets.only(bottom: 14),
                    padding:
                    const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius:
                      BorderRadius.circular(16),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 6,
                          offset: Offset(2, 3),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment:
                      CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment:
                          MainAxisAlignment
                              .spaceBetween,
                          children: [
                            Chip(
                              label: Text(
                                item["title"],
                                style: const TextStyle(
                                    color: Colors.white),
                              ),
                              backgroundColor:
                              BhejduColors.primaryBlue,
                            ),
                            Row(
                              children: [
                                IconButton(
                                  icon: const Icon(
                                      Icons.edit,
                                      color:
                                      BhejduColors
                                          .primaryBlue),
                                  onPressed: () =>
                                      _addressBottomSheet(
                                          item: item),
                                ),
                                IconButton(
                                  icon: const Icon(
                                      Icons.delete,
                                      color: Colors.red),
                                  onPressed: () =>
                                      deleteAddress(
                                          item["id"]),
                                ),
                              ],
                            )
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          item["address"],
                          style: const TextStyle(
                            color:
                            BhejduColors.textGrey,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // ---------------- ADDRESS ADD / EDIT ----------------

  void _addressBottomSheet({dynamic item}) {
    String selectedType = item?["title"] ?? "Home";

    final nameCtrl = TextEditingController();
    final houseCtrl = TextEditingController();
    final buildingCtrl = TextEditingController();
    final streetCtrl = TextEditingController();
    final landmarkCtrl = TextEditingController();
    final cityCtrl = TextEditingController();
    final pincodeCtrl = TextEditingController();
    final phoneCtrl = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius:
        BorderRadius.vertical(top: Radius.circular(22)),
      ),
      builder: (_) {
        return Padding(
          padding: EdgeInsets.only(
            left: 16,
            right: 16,
            top: 20,
            bottom:
            MediaQuery.of(context).viewInsets.bottom + 20,
          ),
          child: SingleChildScrollView(
            child: Column(
              children: [
                _input("Full Name *", nameCtrl),
                _input("Phone Number *", phoneCtrl,
                    keyboard: TextInputType.phone),
                _input("Flat / House No. *", houseCtrl),
                _input("Building / Apartment", buildingCtrl),
                _input("Street / Locality", streetCtrl),
                _input("Landmark (Optional)", landmarkCtrl),
                _input("City *", cityCtrl),
                _input("Pincode *", pincodeCtrl,
                    keyboard: TextInputType.number),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    // Validation
                    if (nameCtrl.text.trim().isEmpty ||
                        phoneCtrl.text.trim().isEmpty ||
                        houseCtrl.text.trim().isEmpty ||
                        cityCtrl.text.trim().isEmpty ||
                        pincodeCtrl.text.trim().isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Please fill all required fields")),
                      );
                      return;
                    }

                    final name = nameCtrl.text.trim();
                    final phone = phoneCtrl.text.trim();
                    final house = houseCtrl.text.trim();
                    final building = buildingCtrl.text.trim();
                    final street = streetCtrl.text.trim();
                    final landmark = landmarkCtrl.text.trim();
                    final city = cityCtrl.text.trim();
                    final pincode = pincodeCtrl.text.trim();

                    final fullAddress = """
$name
$house, $building
$street
${landmark.isNotEmpty ? "Landmark: $landmark" : ""}
$city - $pincode
Phone: $phone
""";

                    if (item == null) {
                      addAddress(
                        type: selectedType,
                        name: name,
                        phone: phone,
                        house: house,
                        building: building,
                        street: street,
                        landmark: landmark,
                        city: city,
                        pincode: pincode,
                        fullAddress: fullAddress.trim(),
                      );
                    } else {
                      updateAddress(item["id"],
                          selectedType, fullAddress.trim());
                    }

                    Navigator.pop(context);
                  },
                  child: const Text("Save Address"),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _input(String label, TextEditingController controller,
      {TextInputType keyboard = TextInputType.text}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextField(
        controller: controller,
        keyboardType: keyboard,
        decoration: InputDecoration(
          labelText: label,
          filled: true,
          fillColor: BhejduColors.bgLight,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }
}
