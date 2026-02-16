import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// Definition of authentication status
enum AuthStateStatus { initial, loading, success, error }

class AuthState {
  final AuthStateStatus status;
  final String? errorMessage;

  const AuthState({this.status = AuthStateStatus.initial, this.errorMessage});
}

// The controller (Logic)
class AuthController extends StateNotifier<AuthState> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  AuthController() : super(const AuthState());

  // Important new function: to reset the state (used when the screen is turned on or after exiting)
  void reset() {
    state = const AuthState(status: AuthStateStatus.initial);
  }

  // Login function
  Future<void> login({required String email, required String password}) async {
    state = const AuthState(status: AuthStateStatus.loading);
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      state = const AuthState(status: AuthStateStatus.success);
    } on FirebaseAuthException catch (e) {
      state = AuthState(status: AuthStateStatus.error, errorMessage: e.message);
      rethrow;
    } catch (e) {
      state = AuthState(status: AuthStateStatus.error, errorMessage: e.toString());
      rethrow;
    }
  }

  // Account creation function
  Future<void> register({required String email, required String password, required String fullName}) async {
    state = const AuthState(status: AuthStateStatus.loading);
    try {
      // User creation
      UserCredential cred = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Save data in Firestore
      if (cred.user != null) {
        await _firestore.collection('users').doc(cred.user!.uid).set({
          'uid': cred.user!.uid,
          'email': email,
          'fullName': fullName,
          'createdAt': FieldValue.serverTimestamp(),
        });
      }

      state = const AuthState(status: AuthStateStatus.success);
    } on FirebaseAuthException catch (e) {
      state = AuthState(status: AuthStateStatus.error, errorMessage: e.message);
      rethrow;
    } catch (e) {
      state = AuthState(status: AuthStateStatus.error, errorMessage: e.toString());
      rethrow;
    }
  }

  // Logout function
  Future<void> signOut() async {
    await _auth.signOut();
    //  Reset the status immediately so the screen can receive a new login.
    state = const AuthState(status: AuthStateStatus.initial);
  }
}

//  Provider definition
final authControllerProvider = StateNotifierProvider<AuthController, AuthState>((ref) {
  return AuthController();
});