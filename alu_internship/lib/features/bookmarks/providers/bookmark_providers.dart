// Riverpod providers exposing bookmark state to the UI.
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../models/bookmark.dart';
import '../../../repositories/bookmark_repository.dart';
import '../../auth/providers/auth_providers.dart';

// Gives screens access to saving, removing, and checking bookmarks.
final bookmarkRepositoryProvider = Provider<BookmarkRepository>((ref) {
  return BookmarkRepository();
});

/// The signed-in student's saved opportunities.
// Gets the list of opportunities the signed-in student has saved.
final myBookmarksProvider = StreamProvider.autoDispose<List<Bookmark>>((ref) {
  final user = ref.watch(authStateChangesProvider).value;
  if (user == null) return Stream.value(const []);
  return ref.watch(bookmarkRepositoryProvider).watchBookmarksByStudent(user.uid);
});

// Checks whether one specific opportunity has already been saved by the signed-in student.
final isBookmarkedProvider = StreamProvider.autoDispose.family<bool, String>((
  ref,
  opportunityId,
) {
  final user = ref.watch(authStateChangesProvider).value;
  if (user == null) return Stream.value(false);
  return ref
      .watch(bookmarkRepositoryProvider)
      .watchIsBookmarked(user.uid, opportunityId);
});
