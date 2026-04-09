import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../theme/bhejdu_colors.dart';

class ResetPasswordPage extends StatefulWidget {
  final int userId;

  const ResetPasswordPage({super.key, required this.userId});

  @override
  State<ResetPasswordPage> createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  final TextEditingController passCtrl = TextEditingController();
  final TextEditingController confirmCtrl = TextEditingController();

  bool loading = false;

  Future<void> resetPassword() async {
    if (passCtrl.text != confirmCtrl.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Passwords do not match")),
      );
      return;
    }

    setState(() => loading = true);

    final url = Uri.parse(
        "https://darkslategrey-chicken-274271.hostingersite.com/api/reset_password.php");

    try {
      final resp = await http.post(url,
          headers: {"Content-Type": "application/json"},
          body: jsonEncode({
            "user_id": widget.userId,
            "password": passCtrl.text.trim(),
          }));

      final data = jsonDecode(resp.body);

      setState(() => loading = false);

      if (data["status"] == "success") {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Password reset successfully")),
        );

        Navigator.pushNamed(context, "/login");
      }
    } catch (e) {
      setState(() => loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: BhejduColors.bgLight,
        appBar: AppBar(
          title: const Text("Reset Password"),
          backgroundColor: Colors.white,
          foregroundColor: BhejduColors.primaryBlue,
        ),
        body: Padding(
          padding: const EdgeInsets.all(22),
          child: Column(
            children: [
              TextField(
                controller: passCtrl,
                obscureText: true,
                decoration: const InputDecoration(
                    labelText: "New Password", border: OutlineInputBorder()),
              ),
              const SizedBox(height: 15),
              TextField(
                controller: confirmCtrl,
                obscureText: true,
                decoration: const InputDecoration(
                    labelText: "Confirm Password",
                    border: OutlineInputBorder()),
              ),
              const SizedBox(height: 25),
              ElevatedButton(
                onPressed: loading ? null : resetPassword,
                child: loading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text("Update Password"),
              )
            ],
          ),
        ));
  }
}
