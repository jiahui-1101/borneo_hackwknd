import 'package:flutter/material.dart';

class HelpPage extends StatefulWidget {
  const HelpPage({super.key});

  @override
  State<HelpPage> createState() => _HelpPageState();
}

class _HelpPageState extends State<HelpPage> {
  final Color navyBlue = const Color(0xFF0B3A76);
  final TextEditingController _searchController = TextEditingController();

  final List<Map<String, dynamic>> _faqItems = [
    {
      'question': 'How do I reset my password?',
      'answer': 'Go to Settings > Security > Change Password. You can also use "Forgot Password" on the login screen.',
      'category': 'Account',
    },
    {
      'question': 'How do I update my personal information?',
      'answer': 'Navigate to Settings > Account Details and tap "Edit Profile" to update your information.',
      'category': 'Account',
    },
    {
      'question': 'What is the minimum investment amount?',
      'answer': 'The minimum investment amount is RM 100 for most funds. Some funds may have different requirements.',
      'category': 'Investing',
    },
    {
      'question': 'How do I withdraw my money?',
      'answer': 'Go to the portfolio page, select the investment you want to withdraw, and tap "Withdraw".',
      'category': 'Investing',
    },
    {
      'question': 'Is my money safe with MHuat?',
      'answer': 'Yes, MHuat uses bank-grade encryption and security measures. Your funds are held in trusted financial institutions.',
      'category': 'Security',
    },
    {
      'question': 'How do I enable biometric login?',
      'answer': 'Go to Settings > Security and toggle on "Biometric Login". Make sure your device has biometric features enabled.',
      'category': 'Security',
    },
    {
      'question': 'What are the fees?',
      'answer': 'MHuat charges a low management fee of 0.5% per annum. There are no hidden fees.',
      'category': 'Billing',
    },
    {
      'question': 'How do I contact customer support?',
      'answer': 'You can reach us via email at support@mhuat.com or call +603-1234 5678 during business hours.',
      'category': 'Support',
    },
  ];

  List<Map<String, dynamic>> _filteredFaqs = [];
  String _selectedCategory = 'All';

  @override
  void initState() {
    super.initState();
    _filteredFaqs = _faqItems;
  }

  void _filterFaqs(String query) {
    setState(() {
      _filteredFaqs = _faqItems.where((faq) {
        final matchesQuery = query.isEmpty ||
            faq['question'].toLowerCase().contains(query.toLowerCase()) ||
            faq['answer'].toLowerCase().contains(query.toLowerCase());
        final matchesCategory = _selectedCategory == 'All' ||
            faq['category'] == _selectedCategory;
        return matchesQuery && matchesCategory;
      }).toList();
    });
  }

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
          'Help & Support',
          style: TextStyle(
            color: navyBlue,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Search Bar
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withValues(alpha: 0.1),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              children: [
                TextField(
                  controller: _searchController,
                  onChanged: _filterFaqs,
                  decoration: InputDecoration(
                    hintText: 'Search for help...',
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.grey.shade300),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: navyBlue, width: 2),
                    ),
                  ),
                ),
                const SizedBox(height: 12),

                // Category Chips
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _buildCategoryChip('All'),
                      _buildCategoryChip('Account'),
                      _buildCategoryChip('Investing'),
                      _buildCategoryChip('Security'),
                      _buildCategoryChip('Billing'),
                      _buildCategoryChip('Support'),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // FAQ List
          Expanded(
            child: _filteredFaqs.isEmpty
                ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.search_off,
                    size: 64,
                    color: Colors.grey.shade400,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No results found',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            )
                : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _filteredFaqs.length,
              itemBuilder: (context, index) {
                return _buildFaqTile(_filteredFaqs[index]);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryChip(String category) {
    final isSelected = _selectedCategory == category;
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: FilterChip(
        label: Text(category),
        selected: isSelected,
        onSelected: (selected) {
          setState(() {
            _selectedCategory = category;
            _filterFaqs(_searchController.text);
          });
        },
        selectedColor: navyBlue.withValues(alpha: 0.2),
        checkmarkColor: navyBlue,
        labelStyle: TextStyle(
          color: isSelected ? navyBlue : Colors.black87,
          fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
        ),
      ),
    );
  }

  Widget _buildFaqTile(Map<String, dynamic> faq) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: ExpansionTile(
        title: Text(
          faq['question'],
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 15,
          ),
        ),
        subtitle: Container(
          margin: const EdgeInsets.only(top: 4),
          child: Text(
            faq['category'],
            style: TextStyle(
              fontSize: 12,
              color: navyBlue,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              faq['answer'],
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade700,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}