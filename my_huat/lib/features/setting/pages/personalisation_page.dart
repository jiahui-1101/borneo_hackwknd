import 'package:flutter/material.dart';

class PersonalisationPage extends StatefulWidget {
  const PersonalisationPage({super.key});

  @override
  State<PersonalisationPage> createState() => _PersonalisationPageState();
}

class _PersonalisationPageState extends State<PersonalisationPage> {
  final Color navyBlue = const Color(0xFF0B3A76);

  // Settings
  bool _darkMode = false;
  bool _compactView = false;
  bool _largeText = false;
  String _selectedLanguage = 'English';
  String _selectedCurrency = 'MYR';
  String _selectedTheme = 'Light';

  final List<String> _languages = ['English', 'Bahasa Malaysia', '中文', 'தமிழ்'];
  final List<String> _currencies = ['MYR', 'USD', 'SGD', 'IDR', 'THB'];
  final List<String> _themes = ['Light', 'Dark', 'System Default'];

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
          'Personalisation',
          style: TextStyle(
            color: navyBlue,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Appearance Section
            _buildSectionTitle('Appearance'),
            const SizedBox(height: 12),

            _buildDropdownTile(
              icon: Icons.palette_outlined,
              label: 'Theme',
              value: _selectedTheme,
              items: _themes,
              onChanged: (value) {
                setState(() {
                  _selectedTheme = value!;
                });
              },
            ),

            _buildSwitchTile(
              icon: Icons.dark_mode_outlined,
              label: 'Dark Mode',
              value: _darkMode,
              onChanged: (value) {
                setState(() {
                  _darkMode = value;
                });
              },
            ),

            _buildSwitchTile(
              icon: Icons.format_size,
              label: 'Large Text',
              value: _largeText,
              onChanged: (value) {
                setState(() {
                  _largeText = value;
                });
              },
            ),

            _buildSwitchTile(
              icon: Icons.view_compact_outlined,
              label: 'Compact View',
              value: _compactView,
              onChanged: (value) {
                setState(() {
                  _compactView = value;
                });
              },
            ),

            const SizedBox(height: 24),

            // Language & Region Section
            _buildSectionTitle('Language & Region'),
            const SizedBox(height: 12),

            _buildDropdownTile(
              icon: Icons.language_outlined,
              label: 'Language',
              value: _selectedLanguage,
              items: _languages,
              onChanged: (value) {
                setState(() {
                  _selectedLanguage = value!;
                });
              },
            ),

            _buildDropdownTile(
              icon: Icons.attach_money,
              label: 'Currency',
              value: _selectedCurrency,
              items: _currencies,
              onChanged: (value) {
                setState(() {
                  _selectedCurrency = value!;
                });
              },
            ),

            const SizedBox(height: 24),

            // Date & Time Section
            _buildSectionTitle('Date & Time'),
            const SizedBox(height: 12),

            _buildInfoTile(
              icon: Icons.calendar_today_outlined,
              label: 'Date Format',
              value: 'DD/MM/YYYY',
            ),

            _buildInfoTile(
              icon: Icons.access_time_outlined,
              label: 'Time Format',
              value: '24 Hour',
            ),

            const SizedBox(height: 30),

            // Save Button
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  _showSavedConfirmation(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: navyBlue,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Save Preferences',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: navyBlue,
      ),
    );
  }

  Widget _buildSwitchTile({
    required IconData icon,
    required String label,
    required bool value,
    required Function(bool) onChanged,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          Icon(icon, color: navyBlue, size: 22),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: navyBlue,
          ),
        ],
      ),
    );
  }

  Widget _buildDropdownTile({
    required IconData icon,
    required String label,
    required String value,
    required List<String> items,
    required Function(String?) onChanged,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          Icon(icon, color: navyBlue, size: 22),
          const SizedBox(width: 12),
          Expanded(
            child: DropdownButton<String>(
              value: value,
              isExpanded: true,
              underline: const SizedBox(),
              items: items.map((String item) {
                return DropdownMenuItem<String>(
                  value: item,
                  child: Text(item),
                );
              }).toList(),
              onChanged: onChanged,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoTile({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          Icon(icon, color: navyBlue, size: 22),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade700,
            ),
          ),
        ],
      ),
    );
  }

  void _showSavedConfirmation(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Preferences saved successfully'),
        backgroundColor: Colors.green,
        duration: Duration(seconds: 2),
      ),
    );
  }
}