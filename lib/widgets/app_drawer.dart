import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../theme/bhejdu_colors.dart';

class AppDrawer extends StatefulWidget {
  const AppDrawer({super.key});

  @override
  State<AppDrawer> createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  String userName = "Guest User";
  String userEmail = "guest@example.com";
  String userImage = "";

  bool isLoading = true; // ⭐ ADDED (only new variable)

  @override
  void initState() {
    super.initState();
    loadUserData();
  }

  Future<void> loadUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? userId = prefs.getInt("user_id");

    // ---- FETCH FROM DATABASE (LIVE USER DATA) ----
    if (userId != null) {
      final response = await http.get(
        Uri.parse(
          "https://darkslategrey-chicken-274271.hostingersite.com/api/get_user.php?user_id=$userId",
        ),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        // Check if data is valid and contains user info
        if (data != null && data is Map && data["status"] == "success") {
          final userData = data["user"];
          if (userData != null && userData is Map) {
            userName = userData["name"] ?? userName;
            userEmail = userData["email"] ?? userEmail;

            userImage = (userData["profile_image"] != null &&
                userData["profile_image"].toString().isNotEmpty)
                ? "https://darkslategrey-chicken-274271.hostingersite.com/uploads/${userData["profile_image"]}"
                : "";

            // Save locally
            prefs.setString("user_name", userName);
            prefs.setString("user_email", userEmail);
            prefs.setString("user_image", userImage);
          }
        }
      }
    }

    setState(() {
      isLoading = false; // ⭐ STOP LOADING
    });
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: BhejduColors.white,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          // -------------------- HEADER --------------------
          DrawerHeader(
            decoration: const BoxDecoration(
              color: BhejduColors.primaryBlue,
            ),
            child: isLoading
                ? const Center(
              child: CircularProgressIndicator(color: Colors.white),
            )
                : Row(
              children: [
                CircleAvatar(
                  radius: 28,
                  backgroundColor: Colors.white,
                  backgroundImage:
                  userImage.isNotEmpty ? NetworkImage(userImage) : null,
                  child: userImage.isEmpty
                      ? const Icon(
                    Icons.person,
                    color: BhejduColors.primaryBlue,
                    size: 34,
                  )
                      : null,
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    "$userName\n$userEmail",
                    style: const TextStyle(
                      color: Colors.white,
                      height: 1.4,
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // -------------------- MENU ITEMS --------------------
          _drawerItem(context,
              icon: Icons.home, label: "Home", route: "/home"),
          _drawerItem(context,
              icon: Icons.grid_view, label: "Categories", route: "/categories"),
          _drawerItem(context,
              icon: Icons.shopping_bag, label: "My Orders", route: "/orders"),
          _drawerItem(context,
              icon: Icons.shopping_cart, label: "My Cart", route: "/cart"),
          _drawerItem(context,
              icon: Icons.location_on,
              label: "Delivery Address",
              route: "/address"),
          _drawerItem(context,
              icon: Icons.person, label: "My Profile", route: "/profile"),
          _drawerItem(context,
              icon: Icons.notifications,
              label: "Notifications",
              route: "/notifications"),
          _drawerItem(context,
              icon: Icons.account_balance_wallet,
              label: "Wallet",
              route: "/wallet"),

          const Divider(height: 36),

          ListTile(
            leading:
            const Icon(Icons.privacy_tip, color: BhejduColors.primaryBlue),
            title: const Text("Privacy Policy"),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, "/privacy");
            },
          ),

          ListTile(
            leading:
            const Icon(Icons.description, color: BhejduColors.primaryBlue),
            title: const Text("Terms & Conditions"),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, "/terms");
            },
          ),

          const Divider(height: 36),

          ListTile(
            leading: const Icon(Icons.logout, color: Colors.red),
            title: const Text(
              "Logout",
              style: TextStyle(
                color: Colors.red,
                fontWeight: FontWeight.w500,
              ),
            ),
            onTap: () async {
              SharedPreferences prefs =
              await SharedPreferences.getInstance();
              prefs.clear();

              Navigator.pushNamedAndRemoveUntil(
                  context, "/login", (route) => false);
            },
          ),
        ],
      ),
    );
  }

  Widget _drawerItem(
      BuildContext context, {
        required IconData icon,
        required String label,
        required String route,
      }) {
    return ListTile(
      leading: Icon(icon, color: BhejduColors.primaryBlue),
      title: Text(label, style: const TextStyle(fontSize: 15)),
      onTap: () {
        Navigator.pop(context);
        Navigator.pushNamed(context, route);
      },
    );
  }
}
