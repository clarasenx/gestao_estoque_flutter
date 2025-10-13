import 'package:flutter/material.dart';

class CategoryCard extends StatelessWidget {
  final int id;
  final String name;
  final String createdAt;
  final String updatedAt;
  final String deletedAt;

  const CategoryCard({
    super.key, 
    required this.id, 
    required this.name,
    required this.createdAt,
    required this.updatedAt,
    required this.deletedAt,
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
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: Row(
              children: [
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: TextStyle(
                          fontSize: isTablet ? 34 : 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 16,),
                      Row(
                        children: [
                          const Icon(Icons.calendar_today, size: 16, color: Colors.grey),
                          const SizedBox(width: 4),
                          Text(
                            'Criado em: ',
                            style: TextStyle(
                              fontSize: isTablet ? 20 : 12,
                              color: Colors.grey,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            createdAt,
                            style: TextStyle(
                              fontSize: isTablet ? 20 : 12,
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(width: 16),
                          const Icon(Icons.update, size: 16, color: Colors.grey),
                          const SizedBox(width: 4),
                          Text(
                            'Última Atualização: ',
                            style: TextStyle(
                              fontSize: isTablet ? 20 : 12,
                              color: Colors.grey,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            updatedAt,
                            style: TextStyle(
                              fontSize: isTablet ? 20 : 12,
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ), 
                        ],
                      ),
                      Row()
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
