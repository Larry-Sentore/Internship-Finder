// Riverpod providers exposing Firebase Auth state (current user, sign-in status) to the UI.
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../models/app_user.dart';
import '../../../repositories/auth_repository.dart';

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepository();
});

final authStateChangesProvider = StreamProvider<User?>((ref) {
  return ref.watch(authRepositoryProvider).authStateChanges();
});

/// The signed-in [AppUser] document (includes role), or null when signed out.
final currentAppUserProvider = StreamProvider<AppUser?>((ref) {
  final authState = ref.watch(authStateChangesProvider);
  return authState.when(
    data: (user) {
      if (user == null) return Stream.value(null);
      return ref.watch(authRepositoryProvider).watchAppUser(user.uid);
    },
    loading: () => Stream.value(null),
    error: (_, _) => Stream.value(null),
  );
});

/// Looks up any user's profile by uid (e.g. a chat participant).
final appUserByIdProvider = StreamProvider.autoDispose.family<AppUser?, String>((
  ref,
  uid,
) {
  return ref.watch(authRepositoryProvider).watchAppUser(uid);
});
