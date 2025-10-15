import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gestao_estoque_flutter/provider/auth_provider.dart';
import 'package:gestao_estoque_flutter/views/app/category/category_page.dart';
import 'package:gestao_estoque_flutter/views/app/dashboard/dashboard_page.dart';
import 'package:gestao_estoque_flutter/views/app/products/products_page.dart';
import 'package:gestao_estoque_flutter/views/app/user/user_page.dart';
import 'package:gestao_estoque_flutter/views/app/warehouse/warehouses_page.dart';

class DrawerItem {
  final Widget page;
  final String title;

  const DrawerItem({required this.page, required this.title});
}

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  int _selectedIndex = 0;

  static const TextStyle optionStyle = TextStyle(
    fontSize: 30,
    fontWeight: FontWeight.bold,
  );

  static const List<DrawerItem> _drawerItems = <DrawerItem>[
    DrawerItem(page: DashboardPage(), title: 'Painel'),
    DrawerItem(page: WarehousePage(), title: 'Depósitos'),
    DrawerItem(page: ProductPage(), title: 'Produtos'),
    DrawerItem(page: CategoryPage(), title: 'Categorias'),
    DrawerItem(
      page: Text('Movimentações', style: optionStyle),
      title: 'Movimentações',
    ),
    DrawerItem(
      page: UserPage(
        name: 'leonardo',
        cpf: '000.000.000-00',
        role: 'ADMIN',
        password: 'password',
      ),
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
        backgroundColor: Colors.blueAccent,
        title: Text(
          _drawerItems[_selectedIndex].title,
          style: TextStyle(color: Colors.white),
        ),
        leading: Builder(
          builder: (context) => IconButton(
            onPressed: () => Scaffold.of(context).openDrawer(),
            icon: const Icon(Icons.menu, color: Colors.white),
          ),
        ),
      ),
      body: SafeArea(child: _drawerItems[_selectedIndex].page),
      drawer: Drawer(
        child: Column(
          children: [
            const SizedBox(
              height: 100,
              child: DrawerHeader(
                decoration: BoxDecoration(color: Colors.blueAccent),
                child: Center(
                  child: Text(
                    'Moreno Festas - Estoque',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: ListView(
                children: _drawerItems.asMap().entries.map((entry) {
                  final index = entry.key;
                  final item = entry.value;
                  return ListTile(
                    selected: _selectedIndex == index,
                    title: Text(
                      item.title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    onTap: () {
                      _onItemTapped(index);
                      Navigator.pop(context);
                    },
                  );
                }).toList(),
              ),
            ),
            const Divider(),
            ListTile(
              title: const Text(
                "Sair",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              leading: const Icon(Icons.logout),
              onTap: () async {
                final authNotifier = ref.read(authStateProvider.notifier);
                await authNotifier.logout();
                /*Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => LoginPage()),
                  (Route<dynamic> route) => false,
                );*/
              },
            ),
          ],
        ),
      ),
    );
  }
}
