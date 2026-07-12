// Riverpod providers exposing the signed-in startup owner's startup and posting flow.
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../models/startup.dart';
import '../../../repositories/startup_repository.dart';
import '../../auth/providers/auth_providers.dart';

// Gives screens access to reading and writing startup profiles.
final startupRepositoryProvider = Provider<StartupRepository>((ref) {
  return StartupRepository();
});

// Gets one startup's details by its id, e.g. to show its name on an opportunity card.
final startupByIdProvider = StreamProvider.autoDispose.family<Startup?, String>((
  ref,
  startupId,
) {
  return ref.watch(startupRepositoryProvider).watchStartup(startupId);
});

/// The signed-in startup owner's own startup (a signup creates exactly one).
// Finds the startup that belongs to the signed-in owner, so they can post under it.
final myStartupProvider = StreamProvider.autoDispose<Startup?>((ref) {
  final user = ref.watch(authStateChangesProvider).value;
  if (user == null) return Stream.value(null);
  return ref
      .watch(startupRepositoryProvider)
      .watchStartupsByOwner(user.uid)
      .map((startups) => startups.isEmpty ? null : startups.first);
});
