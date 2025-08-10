import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../barber.dart';

class BarberService {
  final String _gistUrl =
      'https://gist.githubusercontent.com/Douglasdu3g/4e85d89516a990b6ac25578c94b059db/raw/barbeiro.json';

  // URLs de imagens reais do Unsplash (todas testadas e válidas)
  static const List<String> _realImageUrls = [
    'https://images.unsplash.com/photo-1511367461989-f85a21fda167?w=200&h=200&fit=crop&crop=faces',
    'https://images.unsplash.com/photo-1508214751196-bcfd4ca60f91?w=200&h=200&fit=crop&crop=faces',
    'https://images.unsplash.com/photo-1517841905240-472988babdf9?w=200&h=200&fit=crop&crop=faces',
    'https://images.unsplash.com/photo-1529626455594-4ff0802cfb7e?w=200&h=200&fit=crop&crop=faces',
    'https://images.unsplash.com/photo-1465101046530-73398c7f28ca?w=200&h=200&fit=crop&crop=faces',
    'https://images.unsplash.com/photo-1519340333755-c2f6c58f5c4b?w=200&h=200&fit=crop&crop=faces',
  ];

  String _getRealImageUrl(int index) {
    return _realImageUrls[index % _realImageUrls.length];
  }

  Future<List<Barbeiro>> getBarbeiros() async {
    try {
      // Gists públicos não exigem autenticação; não use tokens no cliente
      final response = await http.get(Uri.parse(_gistUrl));

      if (response.statusCode == 200) {
        final jsonMap = json.decode(response.body);
        debugPrint('Resposta do servidor: $jsonMap'); // Debug

        if (jsonMap is Map<String, dynamic> &&
            jsonMap.containsKey('barbeiros')) {
          final List<dynamic> barbeirosList = jsonMap['barbeiros'];
          List<Barbeiro> barbeiros = [];

          for (int i = 0; i < barbeirosList.length; i++) {
            final barbeiroData = barbeirosList[i];
            // Substituir URL de exemplo por URL real
            barbeiroData['fotoPerfil'] = _getRealImageUrl(i);
            final String id = (barbeiroData is Map<String, dynamic>)
                ? (barbeiroData['id']?.toString() ?? i.toString())
                : i.toString();
            barbeiros.add(Barbeiro.fromFirestore(barbeiroData, id));
          }

          return barbeiros;
        } else {
          throw Exception(
            "Formato inválido: chave 'barbeiros' não encontrada. Resposta: $jsonMap",
          );
        }
      } else {
        throw Exception(
          'Erro ao carregar barbeiros: ${response.statusCode}\nResposta: ${response.body}',
        );
      }
    } catch (e) {
      debugPrint('Erro detalhado: $e'); // Debug
      // Debug
      throw Exception('Erro ao buscar barbeiros: $e');
    }
  }
}
