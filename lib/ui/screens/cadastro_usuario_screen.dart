import 'package:flutter/material.dart';
import '../../models/services/users.dart';

class CadastroUsuarioScreen extends StatefulWidget {
  const CadastroUsuarioScreen({super.key});

  @override
  State<CadastroUsuarioScreen> createState() => _CadastroUsuarioScreenState();
}

class _CadastroUsuarioScreenState extends State<CadastroUsuarioScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nomeController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _cpfController = TextEditingController();
  final TextEditingController _contaBancariaController =
      TextEditingController();
  final TextEditingController _senhaController = TextEditingController();
  final TextEditingController _loginController = TextEditingController();
  final TextEditingController _cidadeController = TextEditingController();
  final TextEditingController _estadoController = TextEditingController();
  final TextEditingController _bairroController = TextEditingController();
  final TextEditingController _ruaController = TextEditingController();
  final TextEditingController _numeroController = TextEditingController();
  final TextEditingController _cepController = TextEditingController();

  @override
  void dispose() {
    _nomeController.dispose();
    _emailController.dispose();
    _cpfController.dispose();
    _contaBancariaController.dispose();
    _senhaController.dispose();
    _loginController.dispose();
    _cidadeController.dispose();
    _estadoController.dispose();
    _bairroController.dispose();
    _ruaController.dispose();
    _numeroController.dispose();
    _cepController.dispose();
    super.dispose();
  }

  void _salvarUsuario() {
    if (_formKey.currentState!.validate()) {
      final usuario = Usuario(
        idUser: '', // O id pode ser gerado pelo backend ou Firebase
        nome: _nomeController.text,
        email: _emailController.text,
        cpf: _cpfController.text,
        contaBancaria: _contaBancariaController.text,
        senha: _senhaController.text,
        login: _loginController.text,
        cidade: _cidadeController.text,
        estado: _estadoController.text,
        bairro: _bairroController.text,
        rua: _ruaController.text,
        numero: _numeroController.text,
        cep: _cepController.text,
      );

      // Usar a variável usuario (exemplo: salvar no Firebase)
      debugPrint('Usuário criado: ${usuario.nome}');

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Usuário cadastrado com sucesso!')),
      );
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cadastro de Usuário'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _nomeController,
                decoration: const InputDecoration(labelText: 'Nome'),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Informe o nome' : null,
              ),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'Email'),
                keyboardType: TextInputType.emailAddress,
                validator: (value) =>
                    value == null || value.isEmpty ? 'Informe o email' : null,
              ),
              TextFormField(
                controller: _cpfController,
                decoration: const InputDecoration(labelText: 'CPF'),
                keyboardType: TextInputType.number,
                validator: (value) =>
                    value == null || value.isEmpty ? 'Informe o CPF' : null,
              ),
              TextFormField(
                controller: _contaBancariaController,
                decoration: const InputDecoration(labelText: 'Conta Bancária'),
                validator: (value) => value == null || value.isEmpty
                    ? 'Informe a conta bancária'
                    : null,
              ),
              TextFormField(
                controller: _senhaController,
                decoration: const InputDecoration(labelText: 'Senha'),
                obscureText: true,
                validator: (value) =>
                    value == null || value.isEmpty ? 'Informe a senha' : null,
              ),
              TextFormField(
                controller: _loginController,
                decoration: const InputDecoration(labelText: 'Login'),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Informe o login' : null,
              ),
              TextFormField(
                controller: _cidadeController,
                decoration: const InputDecoration(labelText: 'Cidade'),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Informe a cidade' : null,
              ),
              TextFormField(
                controller: _estadoController,
                decoration: const InputDecoration(labelText: 'Estado'),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Informe o estado' : null,
              ),
              TextFormField(
                controller: _bairroController,
                decoration: const InputDecoration(labelText: 'Bairro'),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Informe o bairro' : null,
              ),
              TextFormField(
                controller: _ruaController,
                decoration: const InputDecoration(labelText: 'Rua'),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Informe a rua' : null,
              ),
              TextFormField(
                controller: _numeroController,
                decoration: const InputDecoration(labelText: 'Número'),
                keyboardType: TextInputType.number,
                validator: (value) =>
                    value == null || value.isEmpty ? 'Informe o número' : null,
              ),
              TextFormField(
                controller: _cepController,
                decoration: const InputDecoration(labelText: 'CEP'),
                keyboardType: TextInputType.number,
                validator: (value) =>
                    value == null || value.isEmpty ? 'Informe o CEP' : null,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _salvarUsuario,
                child: const Text('Cadastrar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
