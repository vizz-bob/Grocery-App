import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../theme/bhejdu_colors.dart';
import '../widgets/top_app_bar.dart';
import 'edit_profile_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  Map<String, dynamic>? user;
  bool loading = true;
  int? userId;

  @override
  void initState() {
    super.initState();
    loadUserId();
  }

  Future<void> loadUserId() async {
    final prefs = await SharedPreferences.getInstance();
    userId = prefs.getInt("user_id");
    fetchUser();
  }

  Future<void> fetchUser() async {
    if (userId == null) {
      setState(() => loading = false);
      return;
    }

    // DEV MODE: Handle mock user (user_id = 999)
    if (userId == 999) {
      final prefs = await SharedPreferences.getInstance();
      setState(() {
        user = {
          "id": 999,
          "name": prefs.getString("user_name") ?? "Test User",
          "email": prefs.getString("user_email") ?? "test@bhejdu.com",
          "mobile": "9876543210",
          "profile_image": "",
        };
        loading = false;
      });
      return;
    }

    try {
      final res = await http.post(
        Uri.parse(
          "https://darkslategrey-chicken-274271.hostingersite.com/api/get_profile.php",
        ),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"id": userId}),
      );

      final data = jsonDecode(res.body);

      setState(() {
        user = data["status"] == "success" ? data["user"] : null;
        loading = false;
      });
    } catch (e) {
      setState(() {
        user = null;
        loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: BhejduColors.bgLight,
      body: Column(
        children: [
          BhejduAppBar(
            title: "My Profile",
            showBack: true,
            onBackTap: () => Navigator.pop(context),
          ),

          Expanded(
            child: loading
                ? const Center(child: CircularProgressIndicator())
                : user == null
                ? const Center(child: Text("Failed to load profile"))
                : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  /// PROFILE CARD
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(18),
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
                        CircleAvatar(
                          radius: 35,
                          backgroundColor:
                          BhejduColors.primaryBlueLight,
                          backgroundImage:
                          user!["profile_image"] != null &&
                              user!["profile_image"] != ""
                              ? NetworkImage(
                            "https://darkslategrey-chicken-274271.hostingersite.com/uploads/${user!["profile_image"]}",
                          )
                              : null,
                          child: (user!["profile_image"] == null ||
                              user!["profile_image"] == "")
                              ? const Icon(
                            Icons.person,
                            size: 40,
                            color:
                            BhejduColors.primaryBlue,
                          )
                              : null,
                        ),
                        const SizedBox(width: 16),
                        Column(
                          crossAxisAlignment:
                          CrossAxisAlignment.start,
                          children: [
                            Text(
                              user!["name"] ?? "",
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              user!["email"] ?? "",
                              style: const TextStyle(
                                color:
                                BhejduColors.textGrey,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 25),

                  _tile(
                    Icons.edit,
                    "Edit Profile",
                        () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              EditProfilePage(userData: user!),
                        ),
                      );
                      fetchUser();
                    },
                  ),

                  _tile(
                    Icons.location_on,
                    "My Addresses",
                        () => Navigator.pushNamed(context, "/address"),
                  ),

                  _tile(
                    Icons.shopping_bag,
                    "My Orders",
                        () => Navigator.pushNamed(context, "/orders"),
                  ),

                  _tile(
                    Icons.logout,
                    "Logout",
                        () async {
                      final prefs =
                      await SharedPreferences.getInstance();
                      await prefs.clear();
                      Navigator.pushNamedAndRemoveUntil(
                        context,
                        "/login",
                            (_) => false,
                      );
                    },
                    isLogout: true,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _tile(IconData icon, String title, VoidCallback onTap,
      {bool isLogout = false}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 6),
        ],
      ),
      child: ListTile(
        leading: Icon(icon,
            color: isLogout ? Colors.red : BhejduColors.primaryBlue),
        title: Text(
          title,
          style: TextStyle(
            color: isLogout ? Colors.red : BhejduColors.textDark,
            fontWeight: FontWeight.w600,
          ),
        ),
        trailing: const Icon(Icons.arrow_forward_ios, size: 18),
        onTap: onTap,
      ),
    );
  }
}
