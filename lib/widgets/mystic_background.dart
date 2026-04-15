import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

class MysticBackground extends StatelessWidget {
  const MysticBackground({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isDark
              ? const [Color(0xFF0A1220), Color(0xFF111E30), Color(0xFF1D2B3E)]
              : const [Color(0xFFF8F2E7), Color(0xFFF3E7D5), Color(0xFFE8D7BA)],
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            top: -60,
            right: -40,
            child: _orb(isDark ? AppTheme.softGold.withValues(alpha: 0.08) : AppTheme.bronze.withValues(alpha: 0.12)),
          ),
          Positioned(
            bottom: -70,
            left: -50,
            child: _orb(isDark ? AppTheme.bronze.withValues(alpha: 0.08) : AppTheme.softGold.withValues(alpha: 0.16)),
          ),
          child,
        ],
      ),
    );
  }

  Widget _orb(Color color) {
    return Container(
      width: 200,
      height: 200,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(120),
      ),
    );
  }
}
