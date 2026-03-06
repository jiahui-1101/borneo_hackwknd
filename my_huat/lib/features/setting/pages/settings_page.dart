import 'package:flutter/material.dart';
import 'package:my_huat/features/setting/pages/account_details_page.dart';
import 'package:my_huat/features/setting/pages/personalisation_page.dart';
import 'package:my_huat/features/setting/pages/security_page.dart';
import 'package:my_huat/features/setting/pages/help_page.dart';
import 'package:my_huat/features/setting/pages/portfolio_results_page.dart';
import 'package:my_huat/features/setting/pages/favorites_page.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {

  File? _profileImage;

  void _openImagePicker() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text("Take Photo"),
                onTap: () async {
                  Navigator.pop(context);

                  final picker = ImagePicker();
                  final XFile? photo =
                  await picker.pickImage(source: ImageSource.camera);

                  if (photo != null) {
                    setState(() {
                      _profileImage = File(photo.path);
                    });
                  }
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text("Choose from Gallery"),
                onTap: () async {
                  Navigator.pop(context);

                  final picker = ImagePicker();
                  final XFile? photo =
                  await picker.pickImage(source: ImageSource.gallery);

                  if (photo != null) {
                    setState(() {
                      _profileImage = File(photo.path);
                    });
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // Original pinkish background color from Insurance page
    final Color backgroundColor = const Color(0xFFFEF7FF);

    return Scaffold(
      backgroundColor: backgroundColor, // Pinkish original background
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Profile section
              const SizedBox(height: 12),

              // Profile header (avatar + camera button)
              Stack(
                alignment: Alignment.center,
                children: [
                  CircleAvatar(
                    radius: 52,
                    backgroundColor: Colors.grey.shade200,
                    backgroundImage: _profileImage != null
                        ? FileImage(_profileImage!)
                        : const AssetImage('assets/images/profile_avatar.png')
                    as ImageProvider,
                  ),
                  Positioned(
                    right: 0,
                    bottom: 0,
                    child: _CircleIconButton(
                      icon: Icons.camera_alt,
                      onTap: _openImagePicker,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 14),

              const Text(
                "Jia Hui",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),

              const SizedBox(height: 4),

              // Account number with copy
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Account No. | 25417056",
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Account number copied"),
                          duration: Duration(seconds: 1),
                        ),
                      );
                    },
                    child: Icon(
                      Icons.copy,
                      size: 16,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 30),

              // Account Section
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Account",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF0B3A76),
                  ),
                ),
              ),
              const SizedBox(height: 8),


              // Account Details - White box
              _buildMenuItem(
                icon: Icons.description_outlined,
                title: "Account Details",
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const AccountDetailsPage(),
                    ),
                  );
                },
              ),

              // Personalisation - White box
              _buildMenuItem(
                icon: Icons.tune_rounded,
                title: "Personalisation",
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const PersonalisationPage(),
                    ),
                  );
                },
              ),

              // Security - White box
              _buildMenuItem(
                icon: Icons.lock_outline_rounded,
                title: "Security",
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SecurityPage(),
                    ),
                  );
                },
              ),

              const SizedBox(height: 16),

              // Portfolio Section
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Portfolio",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF0B3A76),
                  ),
                ),
              ),
              const SizedBox(height: 8),

              // Portfolio Results - White box (NEW)
              _buildMenuItem(
                icon: Icons.pie_chart_outline,
                title: "Portfolio Results",
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const PortfolioResultsPage(),
                    ),
                  );
                },
              ),

              const SizedBox(height: 16),

              // Favorites Section
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Favorites",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF0B3A76),
                  ),
                ),
              ),
              const SizedBox(height: 8),

              // Favorites - White box (NEW)
              _buildMenuItem(
                icon: Icons.favorite_outline,
                title: "Favorites",
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const FavoritesPage(),
                    ),
                  );
                },
              ),

              const SizedBox(height: 16),

              // Support Section
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Support",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF0B3A76),
                  ),
                ),
              ),
              const SizedBox(height: 8),

              // Help - White box
              _buildMenuItem(
                icon: Icons.help_outline_rounded,
                title: "Help",
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const HelpPage(),
                    ),
                  );
                },
              ),

              const Divider(
                thickness: 1,
                height: 30,
              ),

              // Log out - White box
              _buildMenuItem(
                icon: Icons.logout_rounded,
                title: "Log out",
                isDestructive: true,
                onTap: () {
                  _showLogoutDialog(context);
                },
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    bool isDestructive = false,
  }) {
    final color = isDestructive ? Colors.red : Colors.black87;

    // White background container for each menu item
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: Colors.white, // White background for the box
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        leading: Icon(icon, color: color),
        title: Text(
          title,
          style: TextStyle(
            fontSize: 16,
            color: color,
          ),
        ),
        trailing: Icon(
          Icons.chevron_right,
          color: Colors.grey.shade400,
        ),
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Log Out"),
          content: const Text("Are you sure you want to log out?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close dialog
                // Add logout logic here
              },
              style: TextButton.styleFrom(
                foregroundColor: Colors.red,
              ),
              child: const Text("Log Out"),
            ),
          ],
        );
      },
    );
  }
}

  class _CircleIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _CircleIconButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
        color: const Color(0xFF2F6BFF),
      shape: const CircleBorder(),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: const Padding(
          padding: EdgeInsets.all(10),
          child: Icon(Icons.camera_alt, color: Colors.white, size: 18),
        ),
      ),
    );
  }
  }

