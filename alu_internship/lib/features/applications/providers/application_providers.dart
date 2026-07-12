// Riverpod providers exposing application (submission) state to the UI.
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../models/application.dart';
import '../../../repositories/application_repository.dart';
import '../../auth/providers/auth_providers.dart';

final applicationRepositoryProvider = Provider<ApplicationRepository>((ref) {
  return ApplicationRepository();
});

/// The signed-in student's own applications.
final myApplicationsProvider = StreamProvider.autoDispose<List<Application>>((
  ref,
) {
  final user = ref.watch(authStateChangesProvider).value;
  if (user == null) return Stream.value(const []);
  return ref
      .watch(applicationRepositoryProvider)
      .watchApplicationsByStudent(user.uid);
});

/// Applicants to a single opportunity, for the startup owner reviewing them.
final applicationsByOpportunityProvider = StreamProvider.autoDispose
    .family<List<Application>, String>((ref, opportunityId) {
      return ref
          .watch(applicationRepositoryProvider)
          .watchApplicationsByOpportunity(opportunityId);
    });
