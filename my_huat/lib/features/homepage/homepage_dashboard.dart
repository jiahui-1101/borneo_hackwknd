import 'package:flutter/material.dart';
import 'news/news_carousel.dart';
import 'widgets/total_assets.dart';
import 'for_you/for_you_carousel.dart';

class HomeDashboard extends StatelessWidget {
  const HomeDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: const [
          TotalAssetsCard(),

          SizedBox(height: 24),

          ForYouCarousel(),

          SizedBox(height: 24),

          NewsCarousel(),
        ],
      ),
    );
  }
}
