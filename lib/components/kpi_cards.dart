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
          color: Colors.white,
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child:
          Padding(
            padding: EdgeInsets.all(isTablet ? 18 : 12),
            child: Row(
              children: [
                Icon(icon, color: iconColor, size: isTablet ? 60 : 36),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Flexible(
                        child: Text(
                          value,
                          style: TextStyle(
                            fontSize: isTablet ? 34 : 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Flexible(
                        child: Text(
                          title,
                          softWrap: true,
                          style: TextStyle(
                            fontSize: isTablet ? 26 : 16,
                            fontWeight: FontWeight.w500,
                          ),
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
