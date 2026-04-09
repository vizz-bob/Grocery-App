import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../theme/bhejdu_colors.dart';

class OtpPage extends StatefulWidget {
  final int userId;
  final String email;

  const OtpPage({
    super.key,
    required this.userId,
    required this.email,
  });

  @override
  State<OtpPage> createState() => _OtpPageState();
}

class _OtpPageState extends State<OtpPage> {
  final TextEditingController otpCtrl = TextEditingController();

  bool isVerifying = false;
  bool isResending = false;

  int secondsLeft = 600; // 10 minutes countdown
  Timer? timer;

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  @override
  void dispose() {
    timer?.cancel();
    otpCtrl.dispose();
    super.dispose();
  }

  /// ---------------------- TIMER LOGIC ----------------------
  void startTimer() {
    timer?.cancel();

    timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (secondsLeft > 0) {
        setState(() => secondsLeft--);
      } else {
        t.cancel();
      }
    });
  }

  String formatTime(int sec) {
    int m = sec ~/ 60;
    int s = sec % 60;
    return "$m:${s.toString().padLeft(2, '0')}";
  }

  /// ---------------------- VERIFY OTP ----------------------
  Future<void> verifyOtp() async {
    final otp = otpCtrl.text.trim();

    if (otp.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter OTP")),
      );
      return;
    }

    setState(() => isVerifying = true);

    final url = Uri.parse(
      "https://darkslategrey-chicken-274271.hostingersite.com/api/verify_otp.php",
    );

    try {
      final res = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "user_id": widget.userId,
          "otp": otp,
        }),
      );

      print("VERIFY RAW: ${res.body}");
      final data = jsonDecode(res.body);

      setState(() => isVerifying = false);

      if (data["status"] == "success") {
        Navigator.pushNamed(context, "/login");
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(data["message"])),
        );
      }
    } catch (e) {
      setState(() => isVerifying = false);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    }
  }

  /// ---------------------- RESEND OTP ----------------------
  Future<void> resendOtp() async {
    setState(() => isResending = true);

    final url = Uri.parse(
      "https://darkslategrey-chicken-274271.hostingersite.com/api/resend_otp.php",
    );

    try {
      final res = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"user_id": widget.userId}),
      );

      print("RESEND RAW: ${res.body}");
      final data = jsonDecode(res.body);

      setState(() {
        isResending = false;
        secondsLeft = 600; // reset timer
      });

      startTimer();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(data["message"])),
      );
    } catch (e) {
      setState(() => isResending = false);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    }
  }

  /// ---------------------- UI ----------------------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: BhejduColors.bgLight,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: BhejduColors.primaryBlue,
        title: const Text("Verify OTP"),
      ),

      body: Padding(
        padding: const EdgeInsets.all(22),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "OTP sent to:",
              style: TextStyle(
                color: BhejduColors.textGrey,
                fontSize: 16,
              ),
            ),

            Text(
              widget.email,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: BhejduColors.primaryBlue,
              ),
            ),

            const SizedBox(height: 25),

            /// TIMER
            Text(
              "Expires in: ${formatTime(secondsLeft)}",
              style: const TextStyle(
                fontSize: 18,
                color: Colors.red,
                fontWeight: FontWeight.w600,
              ),
            ),

            const SizedBox(height: 25),

            /// OTP INPUT
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.white,
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
                controller: otpCtrl,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: "Enter OTP",
                  border: InputBorder.none,
                ),
              ),
            ),

            const SizedBox(height: 30),

            /// VERIFY BUTTON
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: isVerifying ? null : verifyOtp,
                style: ElevatedButton.styleFrom(
                  backgroundColor: BhejduColors.primaryBlue,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: isVerifying
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text(
                  "Verify OTP",
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),

            /// RESEND BUTTON
            Center(
              child: TextButton(
                onPressed: (secondsLeft == 0 && !isResending)
                    ? resendOtp
                    : null,
                child: isResending
                    ? const CircularProgressIndicator()
                    : const Text(
                  "Resend OTP",
                  style: TextStyle(
                    color: BhejduColors.primaryBlue,
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 30),

            /// SKIP OTP BUTTON (For testing when SMS fails)
            Center(
              child: TextButton(
                onPressed: () async {
                  final prefs = await SharedPreferences.getInstance();
                  await prefs.setInt("user_id", widget.userId);
                  await prefs.setBool("is_logged_in", true);
                  await prefs.setString("user_email", widget.email);
                  
                  if (mounted) {
                    Navigator.pushNamedAndRemoveUntil(
                      context, "/home", (route) => false);
                  }
                },
                child: const Text(
                  "Skip OTP (Testing Only)",
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 14,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
