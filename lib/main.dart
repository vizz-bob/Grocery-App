import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

// SCREENS
import 'screens/splash_screen.dart';
import 'screens/login_page.dart';
import 'screens/signup_page.dart';
import 'screens/home_page.dart';
import 'screens/categories_page.dart';
import 'screens/product_listing_page.dart';
import 'screens/cart_page.dart';
import 'screens/checkout_page.dart';
import 'screens/address_page.dart';
import 'screens/orders_page.dart';
import 'screens/profile_page.dart';
import 'screens/order_placed_page.dart';
import 'screens/order_confirmation_page.dart';
import 'screens/order_tracking_page.dart';
import 'screens/edit_profile_page.dart';
import 'screens/otp_page.dart';
import 'screens/forgot_password_page.dart';
import 'screens/reset_otp_page.dart';
import 'screens/reset_password_page.dart';
import 'theme/app_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SharedPreferences.getInstance();
  runApp(const BhejduApp());
}

class BhejduApp extends StatelessWidget {
  const BhejduApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Bhejdu Grocery",
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      initialRoute: "/",
      routes: {
        "/": (context) => const SplashScreen(),
        "/login": (context) => const LoginPage(),
        "/signup": (context) => const SignupPage(),
        "/home": (context) => const HomePage(),
        "/categories": (context) => const CategoriesPage(),
        "/cart": (context) => const CartPage(),
        "/checkout": (context) => const CheckoutPage(),
        "/address": (context) => const AddressManagementPage(),
        "/orders": (context) => const OrdersPage(),
        "/orderTracking": (context) => const OrderTrackingPage(),
        "/profile": (context) => const ProfilePage(),

        // ⭐ ORDER SUCCESS ROUTES
        "/orderConfirmation": (context) =>
        const OrderConfirmationPage(),
        "/order-placed": (context) =>
        const OrderPlacedPage(),

        // ⭐ SIGNUP OTP PAGE
        "/otp": (context) {
          final args =
          ModalRoute.of(context)!.settings.arguments as Map;
          return OtpPage(
            userId: args["user_id"],
            email: args["email"],
          );
        },

        // ⭐ FORGOT PASSWORD
        "/forgot-password": (context) =>
        const ForgotPasswordPage(),

        // ⭐ RESET OTP
        "/reset-otp": (context) {
          final args =
          ModalRoute.of(context)!.settings.arguments as Map;
          return ResetOtpPage(
            userId: args["user_id"],
            email: args["email"],
          );
        },

        // ⭐ RESET PASSWORD
        "/reset-password": (context) {
          final args =
          ModalRoute.of(context)!.settings.arguments as Map;
          return ResetPasswordPage(
            userId: args["user_id"],
          );
        },

        // ⭐ EDIT PROFILE
        "/edit-profile": (context) {
          final Map userData =
          ModalRoute.of(context)!.settings.arguments as Map;
          return EditProfilePage(userData: userData);
        },

        // ⭐ PRODUCT LIST
        "/product-list": (context) {
          final Map args =
          ModalRoute.of(context)!.settings.arguments as Map;
          return ProductListingPage(
            categoryId: int.parse(args["id"].toString()),
            categoryName: args["name"],
          );
        },
      },
    );
  }
}
