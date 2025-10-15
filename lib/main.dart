import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gestao_estoque_flutter/provider/auth_provider.dart';
import 'package:gestao_estoque_flutter/views/app/home_page.dart';
import 'package:gestao_estoque_flutter/views/login/login_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load();

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authStatus = ref.watch(authStateProvider);
    final errorStatus = ref.watch(loginErrorProvider);

    return MaterialApp(
      theme: ThemeData(colorSchemeSeed: Colors.blue),
      debugShowCheckedModeBanner: false,
      title: 'Gestão de Estoque',
      home: switch (authStatus) {
        AuthStatus.loading => const Scaffold(
          body: Center(child: CircularProgressIndicator()),
        ),
        AuthStatus.loggedOut => LoginPage(errorMessage: errorStatus,),
        AuthStatus.loggedIn => const HomePage(),
      },
    );
  }
}
