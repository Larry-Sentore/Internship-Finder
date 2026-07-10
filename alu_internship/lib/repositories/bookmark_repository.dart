// Firestore data-access layer for reading/writing bookmarks.
import '../core/constants/firestore_collections.dart';
import '../models/bookmark.dart';
import '../services/firestore_service.dart';

class BookmarkRepository {
  BookmarkRepository({FirestoreService? firestoreService})
    : _firestoreService = firestoreService ?? FirestoreService();

  final FirestoreService _firestoreService;

  Future<void> addBookmark(String studentId, String opportunityId) {
    final bookmark = Bookmark(
      id: Bookmark.idFor(studentId, opportunityId),
      studentId: studentId,
      opportunityId: opportunityId,
    );
    return _firestoreService.set(
      FirestoreCollections.bookmarks,
      bookmark.id,
      bookmark.toMap(),
    );
  }

  Future<void> removeBookmark(String studentId, String opportunityId) {
    return _firestoreService.delete(
      FirestoreCollections.bookmarks,
      Bookmark.idFor(studentId, opportunityId),
    );
  }

  Stream<bool> watchIsBookmarked(String studentId, String opportunityId) {
    return _firestoreService
        .streamDoc(
          FirestoreCollections.bookmarks,
          Bookmark.idFor(studentId, opportunityId),
        )
        .map((doc) => doc.exists);
  }

  Stream<List<Bookmark>> watchBookmarksByStudent(String studentId) {
    return _firestoreService
        .streamCollection(
          FirestoreCollections.bookmarks,
          queryBuilder: (q) => q
              .where('studentId', isEqualTo: studentId)
              .orderBy('createdAt', descending: true),
        )
        .map((snapshot) => snapshot.docs.map(Bookmark.fromFirestore).toList());
  }
}
