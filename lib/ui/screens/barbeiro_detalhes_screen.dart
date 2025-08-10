import 'package:flutter/material.dart';
import '../../models/barber.dart';
import 'agendamento_screen.dart';

class BarbeiroDetalhesScreen extends StatelessWidget {
  final Barbeiro barbeiro;

  const BarbeiroDetalhesScreen({super.key, required this.barbeiro});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(barbeiro.nome)),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: CircleAvatar(
                backgroundImage: NetworkImage(barbeiro.fotoPerfil),
                radius: 50,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              "Especialidades:",
              style: Theme.of(context).textTheme.titleMedium,
            ),
            Text(barbeiro.especialidades.join(', ')),
            const SizedBox(height: 16),
            Text(
              "Disponibilidade:",
              style: Theme.of(context).textTheme.titleMedium,
            ),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              decoration: BoxDecoration(
                color: barbeiro.disponivelAgora
                    ? Colors.green.shade100
                    : Colors.red.shade100,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                barbeiro.disponivelAgora
                    ? "Disponível agora"
                    : "Indisponível no momento",
                style: TextStyle(
                  color: barbeiro.disponivelAgora
                      ? Colors.green.shade800
                      : Colors.red.shade800,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton.icon(
                  icon: const Icon(Icons.schedule),
                  onPressed: barbeiro.disponivelAgora
                      ? () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  AgendamentoScreen(barbeiro: barbeiro),
                            ),
                          );
                        }
                      : null,
                  label: const Text("Agendar"),
                ),
                ElevatedButton.icon(
                  icon: const Icon(Icons.message),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green.shade600,
                    foregroundColor: Colors.white,
                  ),
                  onPressed: () {
                    final numero = barbeiro.contato;
                    final url =
                        "https://wa.me/${numero.replaceAll(RegExp(r'[^0-9]'), '')}";
                    // abrir whatsapp
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Abrir WhatsApp: $url')),
                    );
                  },
                  label: const Text("WhatsApp"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
