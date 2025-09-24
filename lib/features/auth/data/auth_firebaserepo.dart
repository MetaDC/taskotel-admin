import 'package:taskoteladmin/core/services/firebase.dart';
import 'package:taskoteladmin/features/auth/domain/auth_repo.dart';

class AuthFirebaseRepo extends AuthRepo {
  final firebaseAuth = FBAuth.auth;
  @override
  Future<void> login(String email, String password) async {
    final user = await firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    print('User logged in : ${user}');
  }

  @override
  Future<void> logout() async {
    await firebaseAuth.signOut();
  }

  @override
  Stream<bool> authStateChanges() {
    return firebaseAuth.authStateChanges().map((user) => user != null);
  }

  @override
  Future<void> forgetPassword(String email) async {
    await firebaseAuth.sendPasswordResetEmail(email: email);
  }
}
