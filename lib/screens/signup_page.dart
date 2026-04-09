import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../theme/bhejdu_colors.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final TextEditingController nameCtrl = TextEditingController();
  final TextEditingController emailCtrl = TextEditingController();
  final TextEditingController mobileCtrl = TextEditingController();
  final TextEditingController passwordCtrl = TextEditingController();

  bool isLoading = false;
  bool passwordVisible = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: BhejduColors.bgLight,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(22),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: const Icon(
                  Icons.arrow_back,
                  size: 26,
                  color: BhejduColors.primaryBlue,
                ),
              ),

              const SizedBox(height: 25),

              Image.asset("assets/images/logo.png", height: 42),

              const SizedBox(height: 25),

              const Text(
                "Create Account",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                  color: BhejduColors.textDark,
                ),
              ),

              const SizedBox(height: 8),

              const Text(
                "Signup to get started with our grocery app",
                style: TextStyle(fontSize: 15, color: BhejduColors.textGrey),
              ),

              const SizedBox(height: 35),

              _inputField(
                controller: nameCtrl,
                label: "Full Name",
                icon: Icons.person,
              ),

              const SizedBox(height: 20),

              _inputField(
                controller: emailCtrl,
                label: "Email",
                icon: Icons.email,
              ),

              const SizedBox(height: 20),

              _inputField(
                controller: mobileCtrl,
                label: "Mobile Number",
                icon: Icons.phone,
                keyboard: TextInputType.phone,
              ),

              const SizedBox(height: 20),

              _passwordField(),

              const SizedBox(height: 35),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: isLoading ? null : signupUser,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: BhejduColors.primaryBlue,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text(
                    "Create Account",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Already have an account? ",
                    style: TextStyle(color: BhejduColors.textGrey),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.pushNamed(context, "/login"),
                    child: const Text(
                      "Login",
                      style: TextStyle(
                        color: BhejduColors.primaryBlue,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _inputField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool obscure = false,
    TextInputType keyboard = TextInputType.text,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: BhejduColors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 6,
            offset: Offset(2, 3),
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        obscureText: obscure,
        keyboardType: keyboard,
        decoration: InputDecoration(
          labelText: label,
          border: InputBorder.none,
          icon: Icon(icon, color: BhejduColors.primaryBlue),
        ),
      ),
    );
  }

  Widget _passwordField() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: BhejduColors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 6,
            offset: Offset(2, 3),
          ),
        ],
      ),
      child: TextField(
        controller: passwordCtrl,
        obscureText: !passwordVisible,
        decoration: InputDecoration(
          labelText: "Password",
          border: InputBorder.none,
          icon: const Icon(Icons.lock, color: BhejduColors.primaryBlue),
          suffixIcon: IconButton(
            icon: Icon(
              passwordVisible ? Icons.visibility : Icons.visibility_off,
              color: BhejduColors.primaryBlue,
            ),
            onPressed: () {
              setState(() => passwordVisible = !passwordVisible);
            },
          ),
        ),
      ),
    );
  }

  // ⭐⭐⭐ FINAL WORKING SIGNUP FUNCTION ⭐⭐⭐
  void signupUser() async {
    setState(() => isLoading = true);

    final url = Uri.parse(
      "https://darkslategrey-chicken-274271.hostingersite.com/api/signup.php",
    );

    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "name": nameCtrl.text.trim(),
          "email": emailCtrl.text.trim(),
          "mobile": mobileCtrl.text.trim(),
          "password": passwordCtrl.text.trim(),
        }),
      );

      print("STATUS CODE: ${response.statusCode}");
      print("RAW RESPONSE: ${response.body}");

      dynamic data;

      try {
        data = jsonDecode(response.body);
      } catch (jsonError) {
        print("JSON ERROR: $jsonError");

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Invalid response from server.")),
        );

        setState(() => isLoading = false);
        return;
      }

      setState(() => isLoading = false);

      if (data["status"] == "success") {
        Navigator.pushNamed(
          context,
          "/otp",
          arguments: {
            "user_id": data["user_id"],
            "email": emailCtrl.text.trim(),
          },
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(data["message"])),
        );
      }
    } catch (e) {
      print("EXCEPTION: $e");

      setState(() => isLoading = false);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    }
  }
}
