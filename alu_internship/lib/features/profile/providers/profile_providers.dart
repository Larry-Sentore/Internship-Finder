// Riverpod providers exposing the signed-in student's extended profile.
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../models/student_profile.dart';
import '../../../repositories/student_profile_repository.dart';
import '../../auth/providers/auth_providers.dart';

// Gives screens access to reading and saving a student's skills, interests, and resume link.
final studentProfileRepositoryProvider = Provider<StudentProfileRepository>((
  ref,
) {
  return StudentProfileRepository();
});

/// The signed-in student's extended profile (skills, interests, resume).
// Gets the signed-in student's saved skills, interests, and resume link.
final myStudentProfileProvider = StreamProvider.autoDispose<StudentProfile?>((
  ref,
) {
  final user = ref.watch(authStateChangesProvider).value;
  if (user == null) return Stream.value(null);
  return ref.watch(studentProfileRepositoryProvider).watchProfile(user.uid);
});
