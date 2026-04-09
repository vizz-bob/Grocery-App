import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../theme/bhejdu_colors.dart';

class ResetOtpPage extends StatefulWidget {
  final int userId;
  final String email;

  const ResetOtpPage({
    super.key,
    required this.userId,
    required this.email,
  });

  @override
  State<ResetOtpPage> createState() => _ResetOtpPageState();
}

class _ResetOtpPageState extends State<ResetOtpPage> {
  final TextEditingController otpCtrl = TextEditingController();

  int secondsLeft = 600;
  Timer? timer;

  bool isVerifying = false;
  bool isResending = false;

  @override
  void initState() {
    super.initState();
    startTimer();
    sendOtp(); // auto-send OTP when opening page
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  void startTimer() {
    timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (secondsLeft > 0) {
        setState(() => secondsLeft--);
      } else {
        t.cancel();
      }
    });
  }

  String format(int sec) {
    int m = sec ~/ 60;
    int s = sec % 60;
    return "$m:${s.toString().padLeft(2, '0')}";
  }

  Future<void> sendOtp() async {
    setState(() => isResending = true);

    final url = Uri.parse(
        "https://darkslategrey-chicken-274271.hostingersite.com/api/send_reset_otp.php");

    try {
      final resp = await http.post(url,
          headers: {"Content-Type": "application/json"},
          body: jsonEncode({"user_id": widget.userId}));

      print("RESET OTP SEND RAW: ${resp.body}");

      setState(() {
        isResending = false;
        secondsLeft = 600;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("OTP sent to your email")),
      );
    } catch (e) {
      setState(() => isResending = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    }
  }

  Future<void> verifyOtp() async {
    setState(() => isVerifying = true);

    final url = Uri.parse(
        "https://darkslategrey-chicken-274271.hostingersite.com/api/verify_reset_otp.php");

    try {
      final resp = await http.post(url,
          headers: {"Content-Type": "application/json"},
          body: jsonEncode({
            "user_id": widget.userId,
            "otp": otpCtrl.text.trim(),
          }));

      final data = jsonDecode(resp.body);

      setState(() => isVerifying = false);

      if (data["status"] == "verified") {
        Navigator.pushNamed(
          context,
          "/reset-password",
          arguments: {
            "user_id": widget.userId,
          },
        );
      } else if (data["status"] == "expired") {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("OTP expired")),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Incorrect OTP")),
        );
      }
    } catch (e) {
      setState(() => isVerifying = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: BhejduColors.bgLight,
      appBar: AppBar(
        title: const Text("Verify OTP"),
        backgroundColor: Colors.white,
        foregroundColor: BhejduColors.primaryBlue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(22),
        child: Column(
          children: [
            Text("OTP sent to: ${widget.email}"),

            const SizedBox(height: 10),
            Text("Expires in: ${format(secondsLeft)}",
                style: const TextStyle(color: Colors.red)),

            const SizedBox(height: 20),

            TextField(
              controller: otpCtrl,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: "Enter OTP",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 25),

            ElevatedButton(
              onPressed: isVerifying ? null : verifyOtp,
              child: isVerifying
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text("Verify OTP"),
            ),

            TextButton(
              onPressed:
              (secondsLeft == 0 && !isResending) ? sendOtp : null,
              child: isResending
                  ? const CircularProgressIndicator()
                  : const Text("Resend OTP"),
            )
          ],
        ),
      ),
    );
  }
}
