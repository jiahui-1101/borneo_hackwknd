import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class TutorialPage extends StatefulWidget {
  const TutorialPage({Key? key}) : super(key: key);

  @override
  State<TutorialPage> createState() => _TutorialPageState();
}

class _TutorialPageState extends State<TutorialPage> {
  String? selectedCategory;

  // Your complete video data with all categories
  final Map<String, List<Map<String, String>>> categoryVideos = {
    'Insurance Basics': [
      {
        'title': 'Total Summary of Insurance',
        'videoUrl': 'https://www.youtube.com/watch?v=Ty-IdP0uhM8',
        'description': 'A complete summary of key insurance concepts.',
      },
      {
        'title': 'Insurance Companies in Malaysia',
        'videoUrl': 'https://www.youtube.com/watch?v=qHNTlqDuDa4',
        'description': 'An overview of the insurance landscape and companies in Malaysia.',
      },
      {
        'title': 'What is Insurance?',
        'videoUrl': 'https://www.youtube.com/watch?v=qjXgpJpSlCc',
        'description': 'Learn the fundamental concepts of insurance.',
      },
    ],
    'Types of Insurance': [
      {
        'title': 'Life Insurance vs General Insurance',
        'videoUrl': 'https://www.youtube.com/watch?v=heHmtqhWL2w',
        'description': 'Key differences between life and general insurance.',
      },
      {
        'title': 'Life Insurance',
        'videoUrl': 'https://www.youtube.com/watch?v=YPpdpjZ5yEw',
        'description': 'Detailed explanation of life insurance policies.',
      },
      {
        'title': 'Critical Illness Insurance',
        'videoUrl': 'https://www.youtube.com/watch?v=6vbzRQReris',
        'description': 'Understanding coverage for critical illnesses.',
      },
      {
        'title': 'Medical Insurance',
        'videoUrl': 'https://www.youtube.com/watch?v=e0ATim4SE1g',
        'description': 'Learn about medical insurance coverage.',
      },
      {
        'title': 'Personal Accident Insurance',
        'videoUrl': 'https://www.youtube.com/watch?v=34st7mRV-ic',
        'description': 'Understanding personal accident insurance.',
      },
    ],
    'Insurance Policies': [
      {
        'title': 'Traditional Policy',
        'videoUrl': 'https://www.youtube.com/watch?v=Y6hyaL2EZR8',
        'description': 'Explanation of traditional insurance policies.',
      },
      {
        'title': 'Investment Policy - Part 1',
        'videoUrl': 'https://www.youtube.com/watch?v=-7sH61ydDR0',
        'description': 'Introduction to investment-linked policies.',
      },
      {
        'title': 'Investment Policy - Part 2',
        'videoUrl': 'https://www.youtube.com/watch?v=0aujvCXCt_U',
        'description': 'Advanced concepts in investment-linked policies.',
      },
      {
        'title': 'MRTA (Mortgage Loan Insurance)',
        'videoUrl': 'https://www.youtube.com/watch?v=kC1ZVfGYoYs',
        'description': 'Understanding Mortgage Reducing Term Assurance.',
      },
    ],
    'Asset Insurance': [
      {
        'title': 'Car Insurance',
        'videoUrl': 'https://www.youtube.com/watch?v=CBmtFPMUcr0',
        'description': 'Complete guide to car insurance coverage.',
      },
      {
        'title': 'House Insurance',
        'videoUrl': 'https://www.youtube.com/watch?v=u4mp79V2kRc',
        'description': 'Learn about protecting your home with insurance.',
      },
    ],
    'Financial Planning': [
      {
        'title': 'Commitment (Related to Insurance Planning)',
        'videoUrl': 'https://www.youtube.com/watch?v=e0ATim4SE1g',
        'description': 'Understanding financial commitment in insurance planning.',
      },
    ],
  };

  List<String> get categories => categoryVideos.keys.toList();

  String _getThumbnailUrl(String videoUrl) {
    try {
      final uri = Uri.parse(videoUrl);
      String videoId = uri.queryParameters['v'] ?? '';
      return 'https://img.youtube.com/vi/$videoId/0.jpg';
    } catch (e) {
      return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Insurance Tutorials',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.blue),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          // Category Dropdown
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey[300]!),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: selectedCategory,
                  hint: const Text(
                    'Select a Category',
                    style: TextStyle(color: Colors.grey, fontSize: 16),
                  ),
                  icon: const Icon(Icons.arrow_drop_down, color: Colors.blue),
                  isExpanded: true,
                  items: categories.map((category) {
                    return DropdownMenuItem(
                      value: category,
                      child: Text(
                        category,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedCategory = value;
                    });
                  },
                ),
              ),
            ),
          ),

          // Video List or Placeholder
          Expanded(
            child: selectedCategory == null
                ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.play_circle_outline,
                    size: 80,
                    color: Colors.grey[400],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Select a category to watch tutorials',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            )
                : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: categoryVideos[selectedCategory]!.length,
              itemBuilder: (context, index) {
                final video = categoryVideos[selectedCategory]![index];
                return _buildVideoCard(context, video);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVideoCard(BuildContext context, Map<String, String> video) {
    return GestureDetector(
      onTap: () => _showVideoPlayer(context, video),
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              blurRadius: 8,
              spreadRadius: 2,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Thumbnail with play button
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(16),
                  ),
                  child: Image.network(
                    _getThumbnailUrl(video['videoUrl']!),
                    height: 180,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        height: 180,
                        color: Colors.grey[300],
                        child: const Center(
                          child: Icon(
                            Icons.broken_image,
                            size: 50,
                            color: Colors.grey,
                          ),
                        ),
                      );
                    },
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Container(
                        height: 180,
                        color: Colors.grey[200],
                        child: const Center(
                          child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                // Dark overlay
                Container(
                  height: 180,
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.2),
                  ),
                ),
                // Play button
                const Center(
                  child: Icon(
                    Icons.play_circle_fill,
                    color: Colors.white,
                    size: 60,
                  ),
                ),
              ],
            ),

            // Video info
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    video['title']!,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(
                        Icons.play_circle_outline,
                        size: 16,
                        color: Colors.blue,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'Watch Video',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.blue[600],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showVideoPlayer(BuildContext context, Map<String, String> video) {
    final controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            // You can add a loading indicator here
          },
          onPageStarted: (String url) {
            // Page started loading
          },
          onPageFinished: (String url) {
            // Page finished loading
          },
          onWebResourceError: (WebResourceError error) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Error loading video: ${error.description}'),
                backgroundColor: Colors.red,
              ),
            );
          },
        ),
      )
      ..loadRequest(Uri.parse(video['videoUrl']!));

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.9,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          children: [
            // Handle bar for dragging
            Container(
              margin: const EdgeInsets.only(top: 8),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),

            // Video title
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                video['title']!,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
                textAlign: TextAlign.center,
              ),
            ),

            // Divider
            const Divider(height: 1),

            // WebView for YouTube
            Expanded(
              child: WebViewWidget(controller: controller),
            ),

            // Video description
            if (video['description'] != null)
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  border: Border(
                    top: BorderSide(color: Colors.grey[200]!),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Description:',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      video['description']!,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[700],
                      ),
                    ),
                  ],
                ),
              ),

            // Close button
            Padding(
              padding: const EdgeInsets.all(16),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 2,
                  ),
                  child: const Text(
                    'Close',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}