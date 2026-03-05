import 'dart:async';
import 'package:flutter/material.dart';

class ForYouCarousel extends StatefulWidget {
  const ForYouCarousel({super.key});

  @override
  State<ForYouCarousel> createState() => _ForYouCarouselState();
}

class _ForYouCarouselState extends State<ForYouCarousel> {
  late final PageController _controller;
  Timer? _timer;
  int _page = 0;

  final List<Map<String, String>> items = [
    {
      "title": "We cover your one month's bill up to RM5,000!",
      "image": "assets/image/news/foryou1.png"
    },
    {
      "title": "Start investing with only RM10",
      "image": "assets/image/news/foryou2.png"
    },
    {
      "title": "Build your emergency fund faster",
      "image": "assets/image/news/foryou3.png"
    },
  ];

  @override
  void initState() {
    super.initState();
    _controller = PageController(viewportFraction: 0.9);
    _startAutoScroll();
  }

  void _startAutoScroll() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 5), (_) {
      if (_page < items.length - 1) {
        _page++;
      } else {
        _page = 0;
      }

      if (_controller.hasClients) {
        _controller.animateToPage(
          _page,
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeIn,
        );
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            "For you",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF0D3A6D), // Color 100
            ),
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 150,
          child: PageView.builder(
            controller: _controller,
            itemCount: items.length,
            onPageChanged: (index) {
              setState(() => _page = index);
            },
            itemBuilder: (context, index) {
              final item = items[index];

              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF7EBEFB).withOpacity(0.3), // Color 40 with opacity
                      blurRadius: 12,
                      offset: const Offset(0, 6),
                    ),
                  ],
                  image: DecorationImage(
                    image: AssetImage(item["image"]!),
                    fit: BoxFit.cover,
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 12),
        // Page indicator dots
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            items.length,
            (i) => AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              margin: const EdgeInsets.symmetric(horizontal: 4),
              width: _page == i ? 24 : 8,
              height: 8,
              decoration: BoxDecoration(
                color: _page == i
                    ? const Color(0xFF1080E7) // Color 60
                    : const Color(0xFFBBDBFC), // Color 30
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
        ),
      ],
    );
  }
}