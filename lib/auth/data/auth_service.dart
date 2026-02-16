import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  // Monitoring user status (for use in StreamBuilder)
  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  // Get the current user
  User? get currentUser => _firebaseAuth.currentUser;

  // Log in
  Future<UserCredential> signInWithEmail(String email, String password) async {
    try {
      return await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      throw _handleAuthError(e);
    } catch (e) {
      throw "An unexpected error occurred: $e";
    }
  }

  // Create a new account
  Future<UserCredential> signUpWithEmail(String email, String password) async {
    try {
      return await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      throw _handleAuthError(e);
    } catch (e) {
      throw "An unexpected error occurred: $e";
    }
  }

  // Log out
  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }

  // Handling error messages to make them understandable in Arabic
  String _handleAuthError(FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found':
        return "There is no account with this email address";
      case 'wrong-password':
        return "The password is incorrect";
      case 'email-already-in-use':
        return "The email address is already registered";
      case 'invalid-email':
        return "The email format is incorrect";
      case 'weak-password':
        return "The password is very weak";
      case 'too-many-requests':
        return "Attempts have been temporarily blocked, please try again later";
      default:
        return "An error occurred: ${e.message}";
    }
  }
}