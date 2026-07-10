// Data-access layer wrapping Firebase Authentication operations (sign up/in/out).
import 'package:firebase_auth/firebase_auth.dart';

import '../core/constants/firestore_collections.dart';
import '../models/app_user.dart';
import '../services/auth_service.dart';
import '../services/firestore_service.dart';

class AuthRepository {
  AuthRepository({AuthService? authService, FirestoreService? firestoreService})
    : _authService = authService ?? AuthService(),
      _firestoreService = firestoreService ?? FirestoreService();

  final AuthService _authService;
  final FirestoreService _firestoreService;

  User? get currentUser => _authService.currentUser;

  Stream<User?> authStateChanges() => _authService.authStateChanges();

  Future<AppUser> signUp({
    required String email,
    required String password,
    required String displayName,
    required UserRole role,
  }) async {
    final credential = await _authService.signUpWithEmail(
      email: email,
      password: password,
    );
    final uid = credential.user!.uid;
    await _authService.updateDisplayName(displayName);

    final appUser = AppUser(
      uid: uid,
      email: email,
      displayName: displayName,
      role: role,
    );
    await _firestoreService.set(
      FirestoreCollections.users,
      uid,
      appUser.toMap(),
    );
    return appUser;
  }

  Future<AppUser?> signIn({
    required String email,
    required String password,
  }) async {
    final credential = await _authService.signInWithEmail(
      email: email,
      password: password,
    );
    final uid = credential.user!.uid;
    return getAppUser(uid);
  }

  Future<void> signOut() => _authService.signOut();

  Future<void> sendPasswordResetEmail(String email) {
    return _authService.sendPasswordResetEmail(email);
  }

  Future<AppUser?> getAppUser(String uid) async {
    final doc = await _firestoreService.getDoc(FirestoreCollections.users, uid);
    if (!doc.exists) return null;
    return AppUser.fromFirestore(doc);
  }

  Future<AppUser?> getCurrentAppUser() {
    final uid = currentUser?.uid;
    if (uid == null) return Future.value(null);
    return getAppUser(uid);
  }

  Stream<AppUser?> watchAppUser(String uid) {
    return _firestoreService
        .streamDoc(FirestoreCollections.users, uid)
        .map((doc) => doc.exists ? AppUser.fromFirestore(doc) : null);
  }
}
