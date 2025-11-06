import 'package:flutter/material.dart';

class PaginationWidget extends StatelessWidget {
  final int currentPage;
  final int totalPages;
  final void Function(int) onPageChanged;

  const PaginationWidget({
    super.key,
    required this.currentPage,
    required this.totalPages,
    required this.onPageChanged,
  });

  List<int> _visiblePages() {
    if (totalPages <= 3) {
      return List.generate(totalPages, (i) => i + 1);
    }

    if (currentPage <= 2) {
      return [1, 2, 3];
    }

    if (currentPage >= totalPages - 1) {
      return [totalPages - 2, totalPages - 1, totalPages];
    }

    return [currentPage - 1, currentPage, currentPage + 1];
  }

  @override
  Widget build(BuildContext context) {
    final pages = _visiblePages();

    return Wrap(
      alignment: WrapAlignment.center,
      spacing: 12,
      children: [
        _arrowButton(
          context,
          icon: Icons.chevron_left,
          enabled: currentPage > 1,
          onTap: () => onPageChanged(currentPage - 1),
        ),

        // Reticências antes
        if (pages.first > 1)
          _ellipsis(context),

        // Páginas visíveis (no máximo 3)
        ...pages.map((page) {
          final isActive = page == currentPage;

          return GestureDetector(
            onTap: () => onPageChanged(page),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
              decoration: BoxDecoration(
                color: isActive
                    ? Theme.of(context).colorScheme.primary
                    : Theme.of(context).colorScheme.surfaceVariant,
                borderRadius: BorderRadius.circular(12),
                boxShadow: isActive
                    ? [
                        BoxShadow(
                          blurRadius: 6,
                          offset: const Offset(0, 3),
                          color: Theme.of(context)
                              .colorScheme
                              .primary
                              .withOpacity(.4),
                        )
                      ]
                    : null,
              ),
              child: Text(
                page.toString(),
                style: TextStyle(
                  color: isActive
                      ? Theme.of(context).colorScheme.onPrimary
                      : Theme.of(context).colorScheme.onSurfaceVariant,
                  fontSize: 14,
                  fontWeight: isActive ? FontWeight.bold : FontWeight.w500,
                ),
              ),
            ),
          );
        }),

        // Reticências depois
        if (pages.last < totalPages)
          _ellipsis(context),

        _arrowButton(
          context,
          icon: Icons.chevron_right,
          enabled: currentPage < totalPages,
          onTap: () => onPageChanged(currentPage + 1),
        ),
      ],
    );
  }

  Widget _arrowButton(BuildContext context,
      {required IconData icon,
      required bool enabled,
      required VoidCallback onTap}) {
    return InkWell(
      borderRadius: BorderRadius.circular(10),
      onTap: enabled ? onTap : null,
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: enabled
              ? Theme.of(context).colorScheme.surfaceVariant
              : Colors.grey.withOpacity(.1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(
          icon,
          size: 20,
          color: enabled
              ? Theme.of(context).colorScheme.onSurfaceVariant
              : Colors.grey,
        ),
      ),
    );
  }

  Widget _ellipsis(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6),
      child: Text(
        "...",
        style: TextStyle(
          fontSize: 16,
          color: Theme.of(context).colorScheme.onSurfaceVariant,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
