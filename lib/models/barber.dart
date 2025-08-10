import 'localizacao.dart';

class Barbeiro {
  final String id;
  final String nome;
  final List<String> especialidades;
  final double avaliacao;
  final Localizacao localizacao;
  final bool disponivelAgora;
  final String contato;
  final String fotoPerfil;

  Barbeiro({
    required this.id,
    required this.nome,
    required this.especialidades,
    required this.avaliacao,
    required this.localizacao,
    required this.disponivelAgora,
    required this.contato,
    required this.fotoPerfil,
  });

  factory Barbeiro.fromJson(Map<String, dynamic> json) {
    return Barbeiro(
      id: json['id'],
      nome: json['nome'],
      especialidades: List<String>.from(json['especialidades']),
      avaliacao: (json['avaliacao'] as num).toDouble(),
      localizacao: Localizacao(
        latitude: (json['localizacao']['latitude'] as num).toDouble(),
        longitude: (json['localizacao']['longitude'] as num).toDouble(),
      ),
      disponivelAgora: json['disponivelAgora'] as bool,
      contato: json['contato']['whatsapp'] as String,
      fotoPerfil: json['fotoPerfil'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nome': nome,
      'especialidades': especialidades,
      'avaliacao': avaliacao,
      'localizacao': localizacao.toJson(),
      'disponivelAgora': disponivelAgora,
      'contato': contato,
      'fotoPerfil': fotoPerfil,
    };
  }

  bool isDisponivelHoje() {
    return disponivelAgora;
  }
}
