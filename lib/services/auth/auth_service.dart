import 'package:firebase_core/firebase_core.dart';
import 'package:imager/services/auth/auth_provider.dart';
import 'package:imager/services/auth/auth_user.dart';
import 'package:imager/services/auth/firebase_auth_provider.dart';

class AuthService implements AuthProvider {
  final AuthProvider provider;

  const AuthService(this.provider);

  factory AuthService.firebase() => AuthService(FirebaseAuthProvider());

  @override
  AuthUser? get currentUser => provider.currentUser;

  @override
  Future<AuthUser> logIn({required String email, required String password}) =>
      provider.logIn(email: email, password: password);

  @override
  Future<void> logOut() => provider.logOut();

  @override
  Future<AuthUser> signUp({required String email, required String password}) =>
      provider.signUp(email: email, password: password);

  @override
  Future<void> initialize() => provider.initialize();
}
