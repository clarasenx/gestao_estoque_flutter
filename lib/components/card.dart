import 'package:flutter/material.dart';
import 'package:gestao_estoque_flutter/utils/getBreakpoints.dart';

class MyCard extends StatelessWidget {
  final int id;
  final String name;
  final String? description;
  final String? createdAt;
  final String? updatedAt;
  final String? deletedAt;
  final void Function()? onTap;

  /// ✅ Lista opcional de itens do menu
  final List<PopupMenuEntry>? menuItems;

  const MyCard({
    super.key,
    required this.id,
    required this.name,
    this.description,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.onTap,
    this.menuItems,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final breakpoint = getBreakpoints(constraints.maxWidth);

        return Card(
          color: Colors.white,
          clipBehavior: Clip.hardEdge,
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: InkWell(
            splashColor: Colors.blue.withAlpha(30),
            onTap: onTap,
            child: Stack(
              children: [
                Padding(
                  padding: EdgeInsets.only(
                    left: breakpoint == Breakpoint.mobile ? 18 : 34,
                    bottom: 18,
                    right: 18,
                    top: 18,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Flexible(
                        child: Text(
                          name,
                          style: TextStyle(
                            fontSize: breakpoint != Breakpoint.mobile ? 34 : 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),

                      if (description?.isNotEmpty == true) ...[
                        SizedBox(height: 8),
                        Flexible(
                          child: Text(
                            description!,
                            style: TextStyle(
                              fontSize:
                                  breakpoint != Breakpoint.mobile ? 20 : 12,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                        ),
                      ],

                      if (createdAt?.isNotEmpty == true ||
                          updatedAt?.isNotEmpty == true) ...[
                        SizedBox(height: 16),
                        Flexible(
                          child: Row(
                            children: [
                              if (createdAt?.isNotEmpty == true) ...[
                                const Icon(
                                  Icons.calendar_today,
                                  size: 16,
                                  color: Colors.grey,
                                ),
                                const SizedBox(width: 4),
                                Flexible(
                                  child: Text(
                                    'Criado em: ',
                                    softWrap: false,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontSize: breakpoint !=
                                              Breakpoint.mobile
                                          ? 20
                                          : 12,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  createdAt!,
                                  style: TextStyle(
                                    fontSize: breakpoint != Breakpoint.mobile
                                        ? 20
                                        : 12,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(width: 16),
                              ],

                              if (updatedAt?.isNotEmpty == true) ...[
                                const Icon(
                                  Icons.update,
                                  size: 16,
                                  color: Colors.grey,
                                ),
                                const SizedBox(width: 4),
                                Flexible(
                                  child: Text(
                                    'Última Atualização: ',
                                    softWrap: false,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontSize: breakpoint !=
                                              Breakpoint.mobile
                                          ? 20
                                          : 12,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  updatedAt!,
                                  style: TextStyle(
                                    fontSize: breakpoint != Breakpoint.mobile
                                        ? 20
                                        : 12,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                      ],
                    ],
                  ),
                ),

                /// ✅ Só renderiza o botão se menuItems não for vazio
                if (menuItems != null && menuItems!.isNotEmpty)
                  Positioned(
                    top: 4,
                    right: 4,
                    child: PopupMenuButton(
                      tooltip: "Menu",
                      icon: const Icon(Icons.more_vert, size: 35,),
                      itemBuilder: (_) => menuItems!,
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
