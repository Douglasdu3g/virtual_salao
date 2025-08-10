import 'package:flutter/material.dart';
import '../../models/barber.dart';
import '../../models/services/firebase_service.dart';
import '../../models/services/auth_service.dart';
import '../widget/barber_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final FirebaseService _firebaseService = FirebaseService();
  final AuthService _authService = AuthService();
  late Stream<List<Barbeiro>> _barbeirosStream;

  @override
  void initState() {
    super.initState();
    _barbeirosStream = _firebaseService.getBarbeiros();
  }

  Future<void> _logout() async {
    try {
      await _authService.signOut();
      // O AuthWrapper vai detectar automaticamente e navegar para login
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro ao fazer logout: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Virtual Salão',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: const Color(0xFF2196F3),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.person_add, color: Colors.white),
            onPressed: () {
              Navigator.pushNamed(context, 'cadastro_barbeiro');
            },
            tooltip: 'Cadastrar Barbeiro',
          ),
          IconButton(
            icon: const Icon(Icons.map, color: Colors.white),
            onPressed: () {
              Navigator.pushNamed(context, 'mapa');
            },
            tooltip: 'Ver no Mapa',
          ),
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white),
            onPressed: _logout,
            tooltip: 'Sair',
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 8),
            Image.asset('assets/images/logo_vs.png', width: 100, height: 100),
            const SizedBox(height: 16),
            const Text(
              "Profissionais Próximos",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: TextField(
                decoration: InputDecoration(
                  hintText: "Digite seu endereço",
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
            Expanded(
              child: StreamBuilder<List<Barbeiro>>(
                stream: _barbeirosStream,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (snapshot.hasError) {
                    return Center(
                      child: Text(
                        'Erro ao carregar barbeiros:\n${snapshot.error}',
                      ),
                    );
                  }

                  final barbeiros = snapshot.data ?? [];

                  if (barbeiros.isEmpty) {
                    return const Center(
                      child: Text('Nenhum barbeiro encontrado.'),
                    );
                  }

                  return ListView.builder(
                    itemCount: barbeiros.length,
                    itemBuilder: (context, index) {
                      final barbeiro = barbeiros[index];
                      final temDisponibilidadeHoje =
                          barbeiro.isDisponivelHoje();

                      return BarbeiroWidget(
                        nomeCompleto: barbeiro.nome,
                        avaliacao: barbeiro.avaliacao,
                        precoCorte: 0, // ajustar se tiver valor
                        fotoPerfilUrl: barbeiro.fotoPerfil,
                        especialidades: barbeiro.especialidades,
                        disponivelHoje: temDisponibilidadeHoje,
                        barbeiro: barbeiro,
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.pushNamed(context, 'mapa');
        },
        backgroundColor: const Color(0xFF1976D2),
        foregroundColor: Colors.white,
        icon: const Icon(Icons.map),
        label: const Text('Ver no Mapa'),
      ),
    );
  }
}
