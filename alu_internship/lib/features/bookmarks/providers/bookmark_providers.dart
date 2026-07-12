// Riverpod providers exposing bookmark state to the UI.
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../models/bookmark.dart';
import '../../../repositories/bookmark_repository.dart';
import '../../auth/providers/auth_providers.dart';

final bookmarkRepositoryProvider = Provider<BookmarkRepository>((ref) {
  return BookmarkRepository();
});

/// The signed-in student's saved opportunities.
final myBookmarksProvider = StreamProvider.autoDispose<List<Bookmark>>((ref) {
  final user = ref.watch(authStateChangesProvider).value;
  if (user == null) return Stream.value(const []);
  return ref.watch(bookmarkRepositoryProvider).watchBookmarksByStudent(user.uid);
});

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
