import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:virtual_salao/ui/screens/home_screen.dart';
import 'package:virtual_salao/ui/screens/login_screen.dart';
import 'package:virtual_salao/ui/screens/mapa_screen.dart';
import 'package:virtual_salao/ui/screens/cadastro_barbeiro_screen.dart';
import 'models/barber.dart';
import 'ui/screens/barbeiro_detalhes_screen.dart';
import 'models/services/auth_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const VirtualSalaoApp());
}

class VirtualSalaoApp extends StatelessWidget {
  const VirtualSalaoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const AuthWrapper(),
      routes: {
        'login': (_) => const LoginScreen(),
        'home': (_) => const HomeScreen(),
        'mapa': (_) => const MapaScreen(),
        'cadastro_barbeiro': (_) => const CadastroBarbeiroScreen(),
      },
      onGenerateRoute: (settings) {
        if (settings.name == 'detalhes') {
          final Barbeiro barbeiro = settings.arguments as Barbeiro;
          return MaterialPageRoute(
            builder: (context) => BarbeiroDetalhesScreen(barbeiro: barbeiro),
          );
        }
        return null;
      },
    );
  }
}

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final authService = AuthService();

    return StreamBuilder(
      stream: authService.authStateChanges,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        if (snapshot.hasData) {
          // Usuário está logado
          return const HomeScreen();
        } else {
          // Usuário não está logado
          return const LoginScreen();
        }
      },
    );
  }
}
