class Agendamento {
  final String id;
  final String barbeiroid;
  final DateTime data;
  final String servico;
  final double preco;
  final String status; // 'pendente', 'confirmado', 'cancelado', 'concluido'

  Agendamento({
    required this.id,
    required this.barbeiroid,
    required this.data,
    required this.servico,
    required this.preco,
    required this.status,
  });

  factory Agendamento.fromJson(Map<String, dynamic> json) {
    return Agendamento(
      id: json['id'],
      barbeiroid: json['barbeiroid'],
      data: DateTime.parse(json['data']),
      servico: json['servico'],
      preco: (json['preco'] as num).toDouble(),
      status: json['status'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'barbeiroid': barbeiroid,
      'data': data.toIso8601String(),
      'servico': servico,
      'preco': preco,
      'status': status,
    };
  }
}
