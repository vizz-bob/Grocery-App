import 'package:flutter/material.dart';
import '../theme/bhejdu_colors.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: BhejduColors.primaryBlue, // Blue theme background

      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            /// ------------ APP LOGO ------------
            Center(
              child: Container(
                height: 140,
                width: 140,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.white.withOpacity(0.2),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Image.asset(
                    "assets/images/logo.png", // your delivered logo
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 35),

            /// ------------ TITLE ------------
            const Text(
              "Welcome to Bhejdu",
              style: TextStyle(
                color: Colors.white,
                fontSize: 26,
                fontWeight: FontWeight.w700,
              ),
            ),

            const SizedBox(height: 12),

            /// ------------ SUBTITLE ------------
            const Text(
              "Fast delivery of fresh groceries\nright at your doorstep!",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white70,
                fontSize: 16,
              ),
            ),

            const SizedBox(height: 50),

            /// ------------ GET STARTED BUTTON ------------
            ElevatedButton(
              onPressed: () {
                Navigator.pushReplacementNamed(context, "/login");
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: BhejduColors.primaryBlue,
                padding: const EdgeInsets.symmetric(
                    horizontal: 32, vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              child: const Text(
                "Get Started",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
