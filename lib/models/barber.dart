import 'localizacao.dart';

class Barbeiro {
  final String id;
  final String nome;
  final Map<String, double> servicos;
  final double avaliacao;
  final Localizacao localizacao;
  final bool disponivelAgora;
  final String contato;
  final String fotoPerfil;

  Barbeiro({
    required this.id,
    required this.nome,
    required this.servicos,
    required this.avaliacao,
    required this.localizacao,
    required this.disponivelAgora,
    required this.contato,
    required this.fotoPerfil,
  });

  factory Barbeiro.fromFirestore(Map<String, dynamic> data, String id) {
    return Barbeiro(
      id: id,
      nome: data['nome'] ?? '',
      servicos: (data['servicos'] as Map<String, dynamic>?)?.map(
            (key, value) => MapEntry(
                key,
                (value is num)
                    ? value.toDouble()
                    : double.tryParse(value.toString()) ?? 0.0),
          ) ??
          {},
      avaliacao: (data['avaliacao'] ?? 0.0).toDouble(),
      localizacao: Localizacao(
        latitude: (data['localizacao']?['latitude'] ?? 0.0).toDouble(),
        longitude: (data['localizacao']?['longitude'] ?? 0.0).toDouble(),
      ),
      disponivelAgora: data['disponivelAgora'] ?? false,
      contato: data['contato']?['whatsapp'] ?? '',
      fotoPerfil: data['fotoPerfil'] ?? '',
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'nome': nome,
      'servicos': servicos,
      'avaliacao': avaliacao,
      'localizacao': localizacao.toJson(),
      'disponivelAgora': disponivelAgora,
      'contato': {'whatsapp': contato},
      'fotoPerfil': fotoPerfil,
    };
  }

  bool isDisponivelHoje() {
    return disponivelAgora;
  }
}
