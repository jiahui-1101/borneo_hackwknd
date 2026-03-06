import 'dart:async';
import 'package:flutter/material.dart';
import 'news_details.dart';

class NewsCarousel extends StatefulWidget {
  const NewsCarousel({super.key});

  @override
  State<NewsCarousel> createState() => _NewsCarouselState();
}

class _NewsCarouselState extends State<NewsCarousel> {
  late final PageController _pageController;
  Timer? _timer;
  int _currentPage = 0;

  final List<Map<String, dynamic>> newsData = [
    {
      "title": "Start Your Investment Journey",
      "content":
          "Learn how to grow your savings through simple investing strategies designed for students.",
      "date": "10 Apr 2025",
      "image": "assets/image/news/news1.png",
      "details": [
        {"type": "header", "data": "Why invest early?"},
        {
          "type": "paragraph",
          "data":
              "Starting your investment journey while you're young gives you the advantage of compounding. Even small amounts can grow significantly over time.",
        },
        {
          "type": "bullet_list",
          "data": [
            "Compounding works best over long periods.",
            "You can afford to take more risk when you're young.",
            "Learn valuable financial skills.",
          ],
        },
        {"type": "header", "data": "Getting started"},
        {
          "type": "paragraph",
          "data":
              "Open a brokerage account, start with low-cost index funds or ETFs, and invest consistently.",
        },
      ],
    },
    {
      "title": "Emergency Fund Matters",
      "content":
          "Always keep 3 months of expenses saved to handle unexpected events.",
      "date": "12 Apr 2025",
      "image": "assets/image/news/news2.png",
      "details": [
        {"type": "header", "data": "Why you need an emergency fund"},
        {
          "type": "paragraph",
          "data":
              "Life is unpredictable. An emergency fund helps you cover unexpected expenses without going into debt.",
        },
        {
          "type": "numbered_list",
          "data": [
            "Aim for 3–6 months of living expenses.",
            "Keep it in a separate, easily accessible savings account.",
            "Replenish it if you ever need to use it.",
          ],
        },
        {"type": "header", "data": "Where to keep it"},
        {
          "type": "paragraph",
          "data":
              "High-yield savings accounts or money market funds are good options for easy access while earning some interest.",
        },
      ],
    },
    {
      "title": "Insurance Basics",
      "content":
          "Understand the importance of insurance and how it protects your financial future.",
      "date": "15 Apr 2025",
      "image": "assets/image/news/news3.png",
      "details": [
        {"type": "header", "data": "What is insurance?"},
        {
          "type": "paragraph",
          "data":
              "Insurance is a contract that transfers risk from you to an insurance company. You pay a premium, and in return, the company promises to pay for covered losses.",
        },
        {"type": "header", "data": "Types of insurance you should consider"},
        {
          "type": "bullet_list",
          "data": [
            "Health insurance – covers medical expenses",
            "Life insurance – provides for your dependents if you pass away",
            "Disability insurance – replaces income if you can't work",
            "Property insurance – protects your home and belongings",
          ],
        },
        {"type": "header", "data": "How much do you need?"},
        {
          "type": "paragraph",
          "data":
              "It depends on your situation, but a good rule is to have enough coverage to replace your income for several years or cover major potential losses.",
        },
      ],
    },
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController(viewportFraction: 0.9);
    _startAutoScroll();
  }

  void _startAutoScroll() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 5), (_) {
      if (_currentPage < newsData.length - 1) {
        _currentPage++;
      } else {
        _currentPage = 0;
      }

      if (_pageController.hasClients) {
        _pageController.animateToPage(
          _currentPage,
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeIn,
        );
      }
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 20, top: 20, right: 20),
          child: Text(
            "News & Updates",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF0D3A6D), // Color 100
            ),
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 260,
          child: PageView.builder(
            controller: _pageController,
            itemCount: newsData.length,
            onPageChanged: (index) {
              setState(() => _currentPage = index);
            },
            itemBuilder: (context, index) {
              final newsItem = newsData[index];

              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => NewsDetailPage(news: newsItem),
                    ),
                  );
                },
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 10),
                  clipBehavior: Clip.antiAlias,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(
                          0xFF7EBEFB,
                        ).withOpacity(0.3), // Color 40 透明度
                        blurRadius: 12,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Image.asset(
                        newsItem['image'],
                        height: 190,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            height: 190,
                            color: Colors.grey[300],
                            child: const Center(
                              child: Icon(
                                Icons.broken_image,
                                color: Colors.grey,
                              ),
                            ),
                          );
                        },
                      ),
                      Padding(
                        padding: const EdgeInsets.all(6.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 4),
                            Text(
                              newsItem['title'],
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF0D3A6D), // Color 100
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              newsItem['date'],
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(newsData.length, (index) {
            return AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              margin: const EdgeInsets.symmetric(horizontal: 4),
              width: _currentPage == index ? 24 : 8,
              height: 8,
              decoration: BoxDecoration(
                color: _currentPage == index
                    ? const Color(0xFF1080E7) // Color 60
                    : const Color(0xFFBBDBFC), // Color 30
                borderRadius: BorderRadius.circular(4),
              ),
            );
          }),
        ),
      ],
    );
  }
}
