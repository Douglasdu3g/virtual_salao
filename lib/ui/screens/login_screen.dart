import 'package:flutter/material.dart';
import 'package:virtual_salao/ui/styles/colors.dart';
import '../../models/services/auth_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _authService = AuthService();
  bool _isLoading = false;

  Future<void> _login() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        await _authService.signInWithEmailAndPassword(
          _emailController.text.trim(),
          _passwordController.text,
        );

        if (mounted) {
          Navigator.pushNamedAndRemoveUntil(
            context,
            'home',
            (route) => false,
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Erro ao fazer login: $e'),
              backgroundColor: Colors.red,
            ),
          );
        }
      } finally {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      }
    }
  }

  Future<void> _loginAnonimo() async {
    setState(() {
      _isLoading = true;
    });

    try {
      await _authService.signInAnonymously();

      if (mounted) {
        Navigator.pushNamedAndRemoveUntil(
          context,
          'home',
          (route) => false,
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro ao fazer login: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(32.0),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Image.asset('assets/images/logo_vs.png',
                        width: 232, height: 232),
                    const SizedBox(height: 32),
                    TextFormField(
                      controller: _emailController,
                      textAlign: TextAlign.center,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        labelText: 'Email',
                        labelStyle: const TextStyle(
                          fontWeight: FontWeight.normal,
                          fontSize: 16,
                          color: Colors.black,
                        ),
                        border: OutlineInputBorder(
                          borderSide: const BorderSide(
                            color: Colors.black87,
                            width: 3.0,
                            style: BorderStyle.solid,
                          ),
                          borderRadius: BorderRadius.circular(100),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor, insira seu email';
                        }
                        if (!value.contains('@')) {
                          return 'Por favor, insira um email válido';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 24),
                    TextFormField(
                      controller: _passwordController,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        color: Colors.black87,
                      ),
                      obscureText: true,
                      decoration: InputDecoration(
                        label: const Text(
                          'Senha',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                            color: Colors.black87,
                          ),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(100),
                          borderSide: const BorderSide(
                            color: Colors.black87,
                            width: 3.0,
                            style: BorderStyle.solid,
                          ),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor, insira sua senha';
                        }
                        if (value.length < 6) {
                          return 'A senha deve ter pelo menos 6 caracteres';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 32),
                    //Texto de continuar com ...
                    const Text(
                      'Continuar com ...',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 16),
                    //Imagem dos icones.
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          onPressed: () {},
                          icon: Image.asset(
                            'assets/images/google_icon.png',
                            width: 75,
                            height: 75,
                          ),
                        ),
                        const SizedBox(width: 4),
                        IconButton(
                          onPressed: () {},
                          icon: Icon(Icons.facebook,
                              size: 55, color: AppColors.facebookBlue),
                        ),
                        const SizedBox(width: 4),
                        IconButton(
                          onPressed: () {},
                          icon: const Icon(Icons.apple,
                              size: 65, color: Colors.black),
                        ),
                      ],
                    ),
                    //fim da row com as imagens dos icones
                    const SizedBox(height: 32),
                    // Row criada para alinhar o texto de cadastre-se para a direita
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextButton(
                          onPressed: _loginAnonimo,
                          child: const Text(
                            'Login Anônimo',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color: Colors.blue,
                            ),
                          ),
                        ),
                        const Text(
                          'Esqueceu a senha?',
                          textAlign: TextAlign.end,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                    //fim da row com o texto de esqueci minha senha
                    //_____________________________________________________________________________
                    const SizedBox(height: 32),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: Colors.black,
                            minimumSize: const Size(144, 60),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                              side: const BorderSide(
                                color: Colors.black87,
                                width: 1.8,
                                style: BorderStyle.solid,
                              ),
                            ),
                          ),
                          onPressed: () {
                            Navigator.pushNamed(
                              context,
                              'cadastro_usuario',
                            );
                          },
                          child: const Text(
                            'Cadastrar',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        //_____________________________________________________________________________
                        const SizedBox(width: 32),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.black,
                            foregroundColor: Colors.white,
                            minimumSize: const Size(
                              144,
                              60,
                            ), // Definindo tamanho mínimo igual para ambos os botões
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          onPressed: _login,
                          child: const Text(
                            'Confirmar',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
