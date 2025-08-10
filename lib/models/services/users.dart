class Usuario {
  final String idUser;
  final String nome;
  final String email;
  final String cpf;
  final String contaBancaria;
  final String senha;
  final String login;
  final String cidade;
  final String estado;
  final String bairro;
  final String rua;
  final String numero;
  final String cep;

  Usuario({
    required this.idUser,
    required this.nome,
    required this.email,
    required this.cpf,
    required this.contaBancaria,
    required this.senha,
    required this.login,
    required this.cidade,
    required this.estado,
    required this.bairro,
    required this.rua,
    required this.numero,
    required this.cep,
  });

  factory Usuario.fromMap(Map<String, dynamic> map) {
    return Usuario(
      idUser: map['idUser'] ?? '',
      nome: map['nome'] ?? '',
      email: map['email'] ?? '',
      cpf: map['cpf'] ?? '',
      contaBancaria: map['contaBancaria'] ?? '',
      senha: map['senha'] ?? '',
      login: map['login'] ?? '',
      cidade: map['cidade'] ?? '',
      estado: map['estado'] ?? '',
      bairro: map['bairro'] ?? '',
      rua: map['rua'] ?? '',
      numero: map['numero'] ?? '',
      cep: map['cep'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'idUser': idUser,
      'nome': nome,
      'email': email,
      'cpf': cpf,
      'contaBancaria': contaBancaria,
      'senha': senha,
      'login': login,
      'cidade': cidade,
      'estado': estado,
      'bairro': bairro,
      'rua': rua,
      'numero': numero,
      'cep': cep,
    };
  }
}
