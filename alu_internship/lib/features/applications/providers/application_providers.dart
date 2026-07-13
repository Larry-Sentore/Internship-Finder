// Riverpod providers exposing application (submission) state to the UI.
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../models/application.dart';
import '../../../repositories/application_repository.dart';
import '../../auth/providers/auth_providers.dart';

// Gives screens access to the application actions, like sending one, accepting, or rejecting.
final applicationRepositoryProvider = Provider<ApplicationRepository>((ref) {
  return ApplicationRepository();
});

// Gets the list of applications the signed-in student has sent, so they can check their status.
final myApplicationsProvider = StreamProvider.autoDispose<List<Application>>((
  ref,
) {
  final user = ref.watch(authStateChangesProvider).value;
  if (user == null) return Stream.value(const []);
  return ref
      .watch(applicationRepositoryProvider)
      .watchApplicationsByStudent(user.uid);
});

// Gets everyone who applied to one opportunity, so the startup owner can look through them.
final applicationsByOpportunityProvider = StreamProvider.autoDispose
    .family<List<Application>, String>((ref, opportunityId) {
      return ref
          .watch(applicationRepositoryProvider)
          .watchApplicationsByOpportunity(opportunityId);
    });

// Gets every application across every opportunity one startup has posted, so the
// owner can review all of their applicants from a single screen.
final applicationsByStartupProvider = StreamProvider.autoDispose
    .family<List<Application>, String>((ref, startupId) {
      return ref
          .watch(applicationRepositoryProvider)
          .watchApplicationsByStartup(startupId);
    });
