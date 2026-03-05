import 'package:flutter/material.dart';

class TotalAssetsCard extends StatelessWidget {
  const TotalAssetsCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: const Color(0xFFE0EDFE), // Color 20
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF7EBEFB).withOpacity(0.3), // Color 40
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with icon and title
          Row(
            children: [
              Icon(
                Icons.account_balance_wallet,
                color: const Color(0xFF0D3A6D), // Color 100
                size: 20,
              ),
              const SizedBox(width: 8),
              const Text(
                "TOTAL ASSETS",
                style: TextStyle(
                  color: Color(0xFF084584), // Color 90
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Amount
          const Text(
            "RM 0.00",
            style: TextStyle(
              fontSize: 36,
              fontWeight: FontWeight.bold,
              color: Color(0xFF0D3A6D), // Color 100
              height: 1.2,
            ),
          ),
          const SizedBox(height: 8),
          // Incoming info with icon
          Row(
            children: [
              Icon(
                Icons.arrow_upward,
                size: 16,
                color: const Color(0xFF0462C2), // Color 70
              ),
              const SizedBox(width: 4),
              const Text(
                "RM 100.00 coming in",
                style: TextStyle(
                  color: Color(0xFF05509F), // Color 80
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          // CASH IN button
          Align(
            alignment: Alignment.centerRight,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1080E7), // Color 60
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 14,
                ),
                shape: const StadiumBorder(),
                elevation: 0,
              ),
              onPressed: () {},
              child: const Text(
                "CASH IN",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}