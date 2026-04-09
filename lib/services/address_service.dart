import 'dart:convert';
import 'package:http/http.dart' as http;
import '../utils/preference_manager.dart';

class AddressService {
  static const String baseUrl =
      "https://darkslategrey-chicken-274271.hostingersite.com/api";

  static Future<List> getAddresses() async {
    final userId = await PreferenceManager.getUserId();

    final res = await http.post(
      Uri.parse("$baseUrl/get_addresses.php"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"user_id": userId}),
    );

    final data = jsonDecode(res.body);
    return data["addresses"] ?? [];
  }
}
