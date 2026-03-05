import 'package:flutter/material.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(18, 16, 18, 24),
        child: Column(
          children: [
            const SizedBox(height: 12),

            // Profile header (avatar + camera button)
            Stack(
              alignment: Alignment.center,
              children: [
                CircleAvatar(
                  radius: 52,
                  backgroundColor: Colors.grey.shade200,
                  backgroundImage:
                      const AssetImage('assets/images/profile_avatar.png'),
                ),
                Positioned(
                  right: 0,
                  bottom: 0,
                  child: _CircleIconButton(
                    icon: Icons.camera_alt,
                    onTap: () {
                      // TODO: open image picker later
                    },
                  ),
                ),
              ],
            ),

            const SizedBox(height: 14),

            const Text(
              "Jia Hui",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w800,
              ),
            ),

            const SizedBox(height: 6),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Account No. | 25417056",
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey.shade700,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(width: 8),
                InkWell(
                  borderRadius: BorderRadius.circular(8),
                  onTap: () {
                    // TODO: copy to clipboard
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Copied Account No.")),
                    );
                  },
                  child: const Padding(
                    padding: EdgeInsets.all(6.0),
                    child: Icon(Icons.copy, size: 18),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 22),

            // Menu list
            _SettingsTile(
              icon: Icons.description_outlined,
              title: "Account Details",
              onTap: () {},
            ),
            _SettingsTile(
              icon: Icons.tune_rounded,
              title: "Personalisation",
              onTap: () {},
            ),
            _SettingsTile(
              icon: Icons.lock_outline_rounded,
              title: "Security",
              onTap: () {},
            ),
            _SettingsTile(
              icon: Icons.help_outline_rounded,
              title: "Help",
              onTap: () {},
            ),
            _SettingsTile(
              icon: Icons.logout_rounded,
              title: "Log out",
              isDestructive: true,
              onTap: () {
                // TODO: sign out logic
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;
  final bool isDestructive;

  const _SettingsTile({
    required this.icon,
    required this.title,
    required this.onTap,
    this.isDestructive = false,
  });

  @override
  Widget build(BuildContext context) {
    final color = isDestructive ? Colors.red : Colors.black87;

    return Material(
      color: Colors.white,
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(color: Colors.grey.shade200),
            ),
          ),
          child: Row(
            children: [
              Icon(icon, color: color),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: color,
                  ),
                ),
              ),
              Icon(
                Icons.chevron_right_rounded,
                color: Colors.blue.shade600,
                size: 26,
              ),
            ],
          ),
        ),
      ),
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