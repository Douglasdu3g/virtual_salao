import 'package:flutter/material.dart';
import '../screens/barbeiro_detalhes_screen.dart';
import '../../models/barber.dart';
import '../styles/colors.dart';

class BarbeiroWidget extends StatelessWidget {
  final String nomeCompleto;
  final double avaliacao;
  final double precoCorte; // Opcional no momento
  final String fotoPerfilUrl;
  final List<String> especialidades;
  final bool disponivelHoje;
  final Barbeiro? barbeiro;

  const BarbeiroWidget({
    super.key,
    required this.nomeCompleto,
    required this.avaliacao,
    required this.precoCorte,
    required this.fotoPerfilUrl,
    required this.especialidades,
    required this.disponivelHoje,
    this.barbeiro,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap:
          barbeiro != null
              ? () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => BarbeiroDetalhesScreen(barbeiro: barbeiro!),
                  ),
                );
              }
              : null,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: disponivelHoje ? AppColors.blue : AppColors.blue, 
          borderRadius: BorderRadius.circular(12),          
          border: Border.all(color: AppColors.darkBlue, width: 3.0),
        ),
        child: Row(
          
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(50),
              child: Image.network(
                fotoPerfilUrl,
                width: 60,
                height: 60,
                fit: BoxFit.cover,
                errorBuilder:
                    (_, __, ___) => const Icon(Icons.person, size: 60, color: AppColors.darkBlue),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                
                children: [                
                  Text(
                    nomeCompleto.toUpperCase(),
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: AppColors.white,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    "Especialidades: ${especialidades.join(', ')}",
                    style: const TextStyle(fontSize: 12),
                    overflow: TextOverflow.ellipsis,
                  ),
                  Row(
                    children: List.generate(
                      5,
                      (index) => Icon(
                        Icons.star,
                        color:
                            index < avaliacao.round()
                                ? Colors.amber
                                : Colors.grey.shade400,
                        size: 18,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              disponivelHoje ? Icons.check_circle : Icons.schedule,
              color: disponivelHoje ? Colors.green : Colors.grey,
            ),
          ],
        ),
      ),
    );
  }
}
