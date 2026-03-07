import 'package:flutter/material.dart';

enum Risk { low, moderate, high }

class Badge {
  final String text;
  final IconData icon;
  final Color color;

  const Badge({
    required this.text,
    required this.icon,
    required this.color,
  });
}

class FundInfo {
  final String title;
  final String subtitle;
  final List<String> bullets;
  final double ytd;        // Year to date return in percent
  final double oneYear;    // 1 year return in percent
  final Risk risk;
  final List<Badge> badges;
  final Color iconBg;
  final IconData icon;

  const FundInfo({
    required this.title,
    required this.subtitle,
    required this.bullets,
    required this.ytd,
    required this.oneYear,
    required this.risk,
    required this.badges,
    required this.iconBg,
    required this.icon,
  });

  /// Simulated unit price based on YTD performance.
  double get unitPrice => 1.0 + (ytd / 100);
}