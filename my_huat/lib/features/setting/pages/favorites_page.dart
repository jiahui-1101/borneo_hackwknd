import 'package:flutter/material.dart';

class FavoritesPage extends StatefulWidget {
  const FavoritesPage({super.key});

  @override
  State<FavoritesPage> createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  final Color navyBlue = const Color(0xFF0B3A76);
  String _selectedTab = 'Investments';

  // Sample favorites data
  final List<Map<String, dynamic>> _favoriteInvestments = [
    {
      'name': 'Versa Gold',
      'type': 'Gold ETF',
      'returns': '+12.5%',
      'risk': 'High',
      'favorite': true,
    },
    {
      'name': 'Versa Growth',
      'type': 'Equity Fund',
      'returns': '+18.2%',
      'risk': 'High',
      'favorite': true,
    },
    {
      'name': 'Versa Bond',
      'type': 'Bond Fund',
      'returns': '+5.8%',
      'risk': 'Low',
      'favorite': true,
    },
    {
      'name': 'Versa Money Market',
      'type': 'Money Market',
      'returns': '+3.2%',
      'risk': 'Low',
      'favorite': true,
    },
  ];

  final List<Map<String, dynamic>> _favoriteTools = [
    {
      'name': 'BNPL Calculator',
      'icon': Icons.calculate,
      'route': 'bnpl',
      'favorite': true,
    },
    {
      'name': 'Retirement Planner',
      'icon': Icons.timeline,
      'route': 'retirement',
      'favorite': true,
    },
    {
      'name': 'Risk Assessment',
      'icon': Icons.assessment,
      'route': 'risk',
      'favorite': true,
    },
  ];

  final List<Map<String, dynamic>> _favoriteArticles = [
    {
      'title': '10 Investment Tips for Beginners',
      'date': '2 days ago',
      'readTime': '5 min read',
      'author': 'MHuat Team',
    },
    {
      'title': 'Understanding Market Volatility',
      'date': '1 week ago',
      'readTime': '8 min read',
      'author': 'John Tan',
    },
    {
      'title': 'Retirement Planning Guide 2026',
      'date': '2 weeks ago',
      'readTime': '10 min read',
      'author': 'Sarah Chen',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: navyBlue),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Favorites',
          style: TextStyle(
            color: navyBlue,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.edit, color: navyBlue),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Edit mode enabled'),
                  duration: Duration(seconds: 1),
                ),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Tab selector
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(
                bottom: BorderSide(color: Colors.grey.shade200),
              ),
            ),
            child: Row(
              children: [
                _buildTab('Investments', _selectedTab == 'Investments'),
                _buildTab('Tools', _selectedTab == 'Tools'),
                _buildTab('Articles', _selectedTab == 'Articles'),
              ],
            ),
          ),

          // Content
          Expanded(
            child: _selectedTab == 'Investments'
                ? _buildInvestmentsTab()
                : _selectedTab == 'Tools'
                ? _buildToolsTab()
                : _buildArticlesTab(),
          ),
        ],
      ),
    );
  }

  Widget _buildTab(String title, bool isSelected) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selectedTab = title;
          });
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: isSelected ? navyBlue : Colors.transparent,
                width: 2,
              ),
            ),
          ),
          child: Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: isSelected ? navyBlue : Colors.grey.shade600,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInvestmentsTab() {
    return _favoriteInvestments.isEmpty
        ? _buildEmptyState(
      icon: Icons.favorite_border,
      message: 'No favorite investments yet',
      buttonText: 'Explore Investments',
    )
        : ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _favoriteInvestments.length,
      itemBuilder: (context, index) {
        return _buildInvestmentCard(_favoriteInvestments[index]);
      },
    );
  }

  Widget _buildToolsTab() {
    return _favoriteTools.isEmpty
        ? _buildEmptyState(
      icon: Icons.build_outlined,
      message: 'No favorite tools yet',
      buttonText: 'Explore Tools',
    )
        : ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _favoriteTools.length,
      itemBuilder: (context, index) {
        return _buildToolCard(_favoriteTools[index]);
      },
    );
  }

  Widget _buildArticlesTab() {
    return _favoriteArticles.isEmpty
        ? _buildEmptyState(
      icon: Icons.article_outlined,
      message: 'No favorite articles yet',
      buttonText: 'Explore Articles',
    )
        : ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _favoriteArticles.length,
      itemBuilder: (context, index) {
        return _buildArticleCard(_favoriteArticles[index]);
      },
    );
  }

  Widget _buildInvestmentCard(Map<String, dynamic> investment) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: navyBlue.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.show_chart,
              color: Color(0xFF0B3A76),
              size: 28,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  investment['name'],
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Text(
                      investment['type'],
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: investment['risk'] == 'High'
                            ? Colors.red.shade50
                            : Colors.green.shade50,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        investment['risk'],
                        style: TextStyle(
                          fontSize: 10,
                          color: investment['risk'] == 'High'
                              ? Colors.red
                              : Colors.green,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                investment['returns'],
                style: const TextStyle(
                  color: Colors.green,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 4),
              IconButton(
                icon: Icon(
                  Icons.favorite,
                  color: Colors.red.shade400,
                  size: 20,
                ),
                onPressed: () {
                  setState(() {
                    _favoriteInvestments.remove(investment);
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('${investment['name']} removed from favorites'),
                      duration: const Duration(seconds: 1),
                    ),
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildToolCard(Map<String, dynamic> tool) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: navyBlue.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              tool['icon'],
              color: navyBlue,
              size: 28,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              tool['name'],
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          IconButton(
            icon: Icon(
              Icons.favorite,
              color: Colors.red.shade400,
              size: 20,
            ),
            onPressed: () {
              setState(() {
                _favoriteTools.remove(tool);
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildArticleCard(Map<String, dynamic> article) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: navyBlue.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.article,
              color: Color(0xFF0B3A76),
              size: 30,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  article['title'],
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Text(
                      article['author'],
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    Text(
                      ' • ',
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.grey.shade400,
                      ),
                    ),
                    Text(
                      article['date'],
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  article['readTime'],
                  style: TextStyle(
                    fontSize: 11,
                    color: navyBlue,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: Icon(
              Icons.favorite,
              color: Colors.red.shade400,
              size: 20,
            ),
            onPressed: () {
              setState(() {
                _favoriteArticles.remove(article);
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState({
    required IconData icon,
    required String message,
    required String buttonText,
  }) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 80,
            color: Colors.grey.shade400,
          ),
          const SizedBox(height: 16),
          Text(
            message,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              // Navigate to explore page
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: navyBlue,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(buttonText),
          ),
        ],
      ),
    );
  }
}