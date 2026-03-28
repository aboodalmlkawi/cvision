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

  /// Re-authenticates with the current password, then sets a new password.
  /// Only for accounts that use the email/password provider.
  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    final user = _firebaseAuth.currentUser;
    final email = user?.email;
    if (user == null || email == null) {
      throw "No signed-in user";
    }
    final credential = EmailAuthProvider.credential(
      email: email,
      password: currentPassword,
    );
    try {
      await user.reauthenticateWithCredential(credential);
      await user.updatePassword(newPassword);
    } on FirebaseAuthException catch (e) {
      throw _handleAuthError(e);
    } catch (e) {
      throw "An unexpected error occurred: $e";
    }
  }

  // Handling error messages to make them understandable in Arabic
  String _handleAuthError(FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found':
        return "There is no account with this email address";
      case 'wrong-password':
        return "The password is incorrect";
      case 'invalid-credential':
      case 'invalid-login-credentials':
        return "The current password is incorrect";
      case 'email-already-in-use':
        return "The email address is already registered";
      case 'invalid-email':
        return "The email format is incorrect";
      case 'weak-password':
        return "The password is very weak";
      case 'requires-recent-login':
        return "Please sign out and sign in again, then try changing your password";
      case 'too-many-requests':
        return "Attempts have been temporarily blocked, please try again later";
      default:
        return "An error occurred: ${e.message}";
    }
  }
}