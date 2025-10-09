import 'package:firebase_auth/firebase_auth.dart';

abstract class AuthenticationRepository {
  /// A stream that notifies about changes to the user's sign-in state.
  /// Emits the current [User] or null if the user is signed out.
  Stream<User?> get user;

  /// Signs in a user with the given [email] and [password].
  ///
  /// Throws an exception if the login fails.
  Future<void> signInWithEmailAndPassword(String email, String password);
  Future<void> signUpWithEmailAndPassword(String email, String password);

  /// Signs out the current user.
  Future<void> signOut();
}

/// A concrete implementation of [AuthenticationRepository] using Firebase.
class FirebaseAuthenticationRepository implements AuthenticationRepository {
  final FirebaseAuth _firebaseAuth;

  /// Creates a repository, optionally accepting a [FirebaseAuth] instance
  /// for testing purposes. If none is provided, it uses the default instance.
  FirebaseAuthenticationRepository({FirebaseAuth? firebaseAuth})
      : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance;

  @override
  Stream<User?> get user => _firebaseAuth.authStateChanges();

  @override
  Future<void> signInWithEmailAndPassword(String email, String password) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException {
      // The BLoC layer will handle this exception.
      rethrow;
    }
  }

  @override
  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }

  @override
  Future<void> signUpWithEmailAndPassword(String email, String password) async{
    try{
      await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

    } on FirebaseAuthException{
      rethrow;
    }
  }
}


