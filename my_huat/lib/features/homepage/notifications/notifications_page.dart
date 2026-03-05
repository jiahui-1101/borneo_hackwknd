import 'package:flutter/material.dart';

class NotificationsPage extends StatelessWidget {
  const NotificationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_rounded),
            onPressed: () => Navigator.pop(context),
          ),
          title: const Text(
            "Notifications",
            style: TextStyle(fontWeight: FontWeight.w800),
          ),
          bottom: const TabBar(
            labelStyle: TextStyle(fontWeight: FontWeight.w800),
            indicatorWeight: 3,
            tabs: [
              Tab(text: "Services"),
              Tab(text: "Alerts"),
              Tab(text: "To-Dos"),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            _ServicesTab(),
            _AlertsTab(),
            _TodosTab(),
          ],
        ),
      ),
    );
  }
}

/// ------------------------
/// Services Tab (list style)
/// ------------------------
class _ServicesTab extends StatelessWidget {
  const _ServicesTab();

  @override
  Widget build(BuildContext context) {
    final items = [
      {
        "title": "Featured News",
        "preview": "[21 messages] Crypto Stocks Today: ...",
        "time": "23:56",
        "icon": Icons.local_fire_department_rounded,
        "color": const Color(0xFFE74C3C),
        "unread": true,
      },
      {
        "title": "Community Highlights",
        "preview": "[4 messages] Live Now: US–Iran ...",
        "time": "20:19",
        "icon": Icons.emoji_events_rounded,
        "color": const Color(0xFFF1C40F),
        "unread": true,
      },
      {
        "title": "Rewards Reminders",
        "preview": "Rewards Delivery: Congratulations! ...",
        "time": "19:11",
        "icon": Icons.card_giftcard_rounded,
        "color": const Color(0xFFF39C12),
        "unread": false,
      },
      {
        "title": "Event Push",
        "preview": "[4 messages] You have rewards to claim ...",
        "time": "19:11",
        "icon": Icons.send_rounded,
        "color": const Color(0xFF8E44AD),
        "unread": false,
      },
      {
        "title": "Account Security",
        "preview": "New Device Login: Time: Mar 4, 2026 ...",
        "time": "17:18",
        "icon": Icons.shield_rounded,
        "color": const Color(0xFF2E86DE),
        "unread": false,
      },
    ];

    return ListView.separated(
      padding: const EdgeInsets.symmetric(vertical: 12),
      itemCount: items.length + 1,
      separatorBuilder: (_, _) => Divider(height: 1, color: Colors.grey[200]),
      itemBuilder: (context, index) {
        if (index == 0) {
          return ListTile(
            leading: const Icon(Icons.done_all_rounded),
            title: const Text(
              "Read All",
              style: TextStyle(fontWeight: FontWeight.w700),
            ),
            onTap: () {},
          );
        }

        final item = items[index - 1];
        return _ServiceRow(
          title: item["title"] as String,
          preview: item["preview"] as String,
          time: item["time"] as String,
          icon: item["icon"] as IconData,
          color: item["color"] as Color,
          unread: item["unread"] as bool,
          onTap: () {},
        );
      },
    );
  }
}

class _ServiceRow extends StatelessWidget {
  final String title;
  final String preview;
  final String time;
  final IconData icon;
  final Color color;
  final bool unread;
  final VoidCallback onTap;

  const _ServiceRow({
    required this.title,
    required this.preview,
    required this.time,
    required this.icon,
    required this.color,
    required this.unread,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      leading: Stack(
        clipBehavior: Clip.none,
        children: [
          CircleAvatar(
            radius: 22,
            backgroundColor: color.withOpacity(0.12),
            child: Icon(icon, color: color),
          ),
          if (unread)
            Positioned(
              right: -2,
              top: -2,
              child: Container(
                width: 10,
                height: 10,
                decoration: const BoxDecoration(
                  color: Colors.red,
                  shape: BoxShape.circle,
                ),
              ),
            ),
        ],
      ),
      title: Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.w800),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Text(
            time,
            style: TextStyle(fontSize: 12, color: Colors.grey[600]),
          ),
        ],
      ),
      subtitle: Text(
        preview,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(color: Colors.grey[700]),
      ),
    );
  }
}

/// ----------------------
/// Alerts Tab (card style)
/// ----------------------
class _AlertsTab extends StatelessWidget {
  const _AlertsTab();

  @override
  Widget build(BuildContext context) {
    final alerts = [
      {
        "title": "Account Opening Reminder",
        "content":
            "Application Received: Thank you for applying for an account with us. "
                "The process will be completed within 1–2 business days.",
        "time": "Mar 3 19:29",
      },
      {
        "title": "Account Opening Reminder",
        "content":
            "Action Required: To proceed with your account application, we need more "
                "information about you. Please submit the required details.",
        "time": "16:46",
      },
    ];

    return ListView.builder(
      padding: const EdgeInsets.all(14),
      itemCount: alerts.length,
      itemBuilder: (context, i) {
        final a = alerts[i];
        return Container(
          margin: const EdgeInsets.only(bottom: 14),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.grey.shade200),
            boxShadow: [
              BoxShadow(
                blurRadius: 12,
                offset: const Offset(0, 4),
                color: Colors.black.withOpacity(0.05),
              )
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                a["title"]!,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                a["content"]!,
                style: const TextStyle(height: 1.35),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Icon(Icons.access_time_rounded,
                      size: 16, color: Colors.grey[600]),
                  const SizedBox(width: 6),
                  Text(
                    a["time"]!,
                    style: TextStyle(color: Colors.grey[600], fontSize: 12),
                  ),
                ],
              )
            ],
          ),
        );
      },
    );
  }
}

/// ---------------------
/// To-Dos Tab (empty UI)
/// ---------------------
class _TodosTab extends StatelessWidget {
  const _TodosTab();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.chat_bubble_outline_rounded,
              size: 60, color: Colors.grey[400]),
          const SizedBox(height: 10),
          Text(
            "No To-Dos",
            style: TextStyle(
              color: Colors.grey[600],
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}