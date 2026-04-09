import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../theme/bhejdu_colors.dart';

class BannerSlider extends StatefulWidget {
  const BannerSlider({super.key});

  @override
  State<BannerSlider> createState() => _BannerSliderState();
}

class _BannerSliderState extends State<BannerSlider> {
  final PageController _pageController = PageController();
  int currentIndex = 0;

  /// STATIC FALLBACK BANNERS
  List<String> banners = [
    "assets/images/banner1.png",
    "assets/images/banner2.png",
    "assets/images/banner3.png",
  ];

  bool loading = true;
  Timer? autoPlayTimer;

  @override
  void initState() {
    super.initState();
    fetchBanners();
  }

  /// FETCH BANNERS FROM BACKEND
  Future fetchBanners() async {
    const url =
        "https://darkslategrey-chicken-274271.hostingersite.com/api/get_banners.php";

    try {
      final res = await http.get(Uri.parse(url));
      final data = jsonDecode(res.body);

      if (data["status"] == "success") {
        List<dynamic> list = data["banners"];

        if (list.isNotEmpty) {
          banners = list.map((b) => b["image"].toString()).toList();
	  // <<< ADD THIS LINE TO DEBUG
          print("Banners fetched from backend: $banners");
        }
      }
    } catch (e) {
      print("Banner Load Error: $e");
    }

    /// Now start autoplay safely
    setState(() => loading = false);
    startAutoPlay();
  }

  void startAutoPlay() {
    autoPlayTimer = Timer.periodic(const Duration(seconds: 4), (_) {
      if (_pageController.hasClients && banners.isNotEmpty) {
        currentIndex = (currentIndex + 1) % banners.length;
        _pageController.animateToPage(
          currentIndex,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    autoPlayTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const SizedBox(
        height: 160,
        child: Center(child: CircularProgressIndicator()),
      );
    }

    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        /// MAIN BANNER SLIDER
        SizedBox(
          height: 160,
          width: double.infinity,
          child: PageView.builder(
            controller: _pageController,
            itemCount: banners.length,
            onPageChanged: (index) {
              setState(() => currentIndex = index);
            },
            itemBuilder: (context, index) {
              print("Displaying banner: ${banners[index]}");
              return AnimatedContainer(
                duration: const Duration(milliseconds: 500),
                curve: Curves.easeInOut,
                margin: const EdgeInsets.symmetric(horizontal: 4),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(18),
                  image: DecorationImage(
                    image: banners[index].startsWith("http")
                        ? NetworkImage(banners[index])
                        : AssetImage(banners[index]) as ImageProvider,
                    fit: BoxFit.cover,
                  ),
                ),
              );
            },
          ),
        ),

        /// DOT INDICATORS
        Positioned(
          bottom: 12,
          child: Row(
            children: List.generate(banners.length, (index) {
              return AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                margin: const EdgeInsets.symmetric(horizontal: 4),
                height: 8,
                width: currentIndex == index ? 20 : 8,
                decoration: BoxDecoration(
                  color: currentIndex == index
                      ? BhejduColors.primaryBlue
                      : Colors.white.withOpacity(0.7),
                  borderRadius: BorderRadius.circular(12),
                ),
              );
            }),
          ),
        )
      ],
    );
  }
}
