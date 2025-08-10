import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Usuário atual
  User? get currentUser => _auth.currentUser;

  // Stream do usuário
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // Login com email e senha
  Future<UserCredential?> signInWithEmailAndPassword(
      String email, String password) async {
    try {
      return await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } catch (e) {
      throw Exception('Erro ao fazer login: ${e.toString()}');
    }
  }

  // Cadastro com email e senha
  Future<UserCredential?> createUserWithEmailAndPassword(
      String email, String password) async {
    try {
      return await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
    } catch (e) {
      throw Exception('Erro ao criar conta: ${e.toString()}');
    }
  }

  // Login anônimo (para testes)
  Future<UserCredential?> signInAnonymously() async {
    try {
      return await _auth.signInAnonymously();
    } catch (e) {
      throw Exception('Erro ao fazer login anônimo: ${e.toString()}');
    }
  }

  // Logout
  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } catch (e) {
      throw Exception('Erro ao fazer logout: ${e.toString()}');
    }
  }

  // Verificar se está logado
  bool isLoggedIn() {
    return _auth.currentUser != null;
  }
}
