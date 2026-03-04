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
      "image": "assets/news/foryou1.png"
    },
    {
      "title": "Start investing with only RM10",
      "image": "assets/news/foryou2.png"
    },
    {
      "title": "Build your emergency fund faster",
      "image": "assets/news/foryou3.png"
    },
  ];

  @override
  void initState() {
    super.initState();
    _controller = PageController(viewportFraction: 0.9);
    _start();
  }

  void _start() {
    _timer = Timer.periodic(const Duration(seconds: 6), (_) {
      if (_page < items.length - 1) {
        _page++;
      } else {
        _page = 0;
      }

      _controller.animateToPage(
        _page,
        duration: const Duration(milliseconds: 400),
        curve: Curves.ease,
      );
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

        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            "For you",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),

        const SizedBox(height: 12),

        SizedBox(
          height: 150,
          child: PageView.builder(
            controller: _controller,
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index];

              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  image: DecorationImage(
                    image: AssetImage(item["image"]!),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    gradient: LinearGradient(
                      colors: [
                        Colors.black.withOpacity(0.5),
                        Colors.transparent
                      ],
                      begin: Alignment.bottomLeft,
                      end: Alignment.topRight,
                    ),
                  ),
                  alignment: Alignment.bottomLeft,
                  child: Text(
                    item["title"]!,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              );
            },
          ),
        ),

        const SizedBox(height: 8),

        /// indicator dots
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            items.length,
            (i) => Container(
              margin: const EdgeInsets.symmetric(horizontal: 3),
              width: _page == i ? 14 : 6,
              height: 6,
              decoration: BoxDecoration(
                color: _page == i ? Colors.teal : Colors.grey[400],
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        ),
      ],
    );
  }
}