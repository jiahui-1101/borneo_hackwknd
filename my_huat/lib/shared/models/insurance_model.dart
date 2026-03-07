import 'package:flutter/material.dart';

class InsuranceBadge {
  final String text;
  final IconData icon;
  final Color color;

  const InsuranceBadge({
    required this.text,
    required this.icon,
    required this.color,
  });
}

class InsuranceInfo {
  final String title;
  final String subtitle;
  final List<String> bullets;
  final double premium;      // annual premium in RM
  final double coverage;     // sum assured in RM
  final String term;         // e.g., 'Lifetime', '20 years'
  final List<InsuranceBadge> badges;
  final Color iconBg;
  final IconData icon;

  const InsuranceInfo({
    required this.title,
    required this.subtitle,
    required this.bullets,
    required this.premium,
    required this.coverage,
    required this.term,
    required this.badges,
    required this.iconBg,
    required this.icon,
  });
}