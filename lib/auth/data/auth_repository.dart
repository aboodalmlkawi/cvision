import 'package:firebase_auth/firebase_auth.dart';
import 'auth_service.dart';

class AuthRepository {
  final AuthService _authService;

  // The service can be passed or created automatically
  AuthRepository({AuthService? authService})
      : _authService = authService ?? AuthService();

  // Monitoring the situation
  Stream<User?> get authStateChanges => _authService.authStateChanges;

  // Current user
  User? get currentUser => _authService.currentUser;

  // Log in
  Future<User?> login(String email, String password) async {
    final credential = await _authService.signInWithEmail(email, password);
    return credential.user;
  }

  // Create an account
  Future<User?> register(String email, String password) async {
    final credential = await _authService.signUpWithEmail(email, password);
    return credential.user;
  }

  // Log out
  Future<void> logout() async {
    await _authService.signOut();
  }
}