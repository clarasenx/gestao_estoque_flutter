import 'package:flutter/material.dart';
import 'package:gestao_estoque_flutter/views/app/dashboard/dashboard_page.dart';
import 'package:gestao_estoque_flutter/views/app/products/products_page.dart';
import 'package:gestao_estoque_flutter/views/app/user/user_page.dart';

class DrawerItem {
  final Widget page;
  final String title;

  const DrawerItem({required this.page, required this.title});
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<StatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  static const TextStyle optionStyle = TextStyle(
    fontSize: 30,
    fontWeight: FontWeight.bold,
  );

  static const List<DrawerItem> _drawerItems = <DrawerItem>[
    DrawerItem(page: DashboardPage(), title: 'Painel'),
    DrawerItem(page: ProductPage(), title: 'Produtos'),
    DrawerItem(
      page: Text('Movimentações', style: optionStyle),
      title: 'Movimentações',
    ),
    DrawerItem(
      page: UserPage(name: 'leonardo', cpf: '000.000.000-00', role: 'ADMIN', password: 'password'),
      title: 'Meu Perfil',
    ),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_drawerItems[_selectedIndex].title),
        leading: Builder(
          builder: (context) => IconButton(
            onPressed: () => Scaffold.of(context).openDrawer(),
            icon: const Icon(Icons.menu),
          ),
        ),
      ),
      body: _drawerItems[_selectedIndex].page,
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const SizedBox(
              height: 100,
              child: DrawerHeader(
                decoration: BoxDecoration(color: Colors.blue),
                child: Center(
                  child: Text(
                    'Moreno Festas - Estoque',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.white),
                  ),
                ),
              ),
            ),
            ..._drawerItems.asMap().entries.map((entry) {
              final index = entry.key;
              final item = entry.value;
              return ListTile(
                selected: _selectedIndex == index,
                title: Text(item.title),
                onTap: () {
                  _onItemTapped(index);
                  Navigator.pop(context);
                },
              );
            }),
          ],
        ),
      ),
    );
  }
}
