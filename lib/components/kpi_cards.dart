import 'package:flutter/material.dart';

class KpiCard extends StatelessWidget {
  final String title;
  final String value;
  final Color iconColor;
  final IconData icon;

  const KpiCard({
    super.key,
    required this.title,
    required this.value,
    required this.iconColor,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isTablet = constraints.maxWidth > 600;

        return Card(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: Row(
              children: [
                Icon(icon, color: iconColor, size: isTablet ? 60 : 30),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        value,
                        style: TextStyle(
                          fontSize: isTablet ? 34 : 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        title,
                        softWrap: true,
                        style: TextStyle(
                          fontSize: isTablet ? 26 : 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
