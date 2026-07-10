// Firestore data-access layer for reading/writing notifications.
import '../core/constants/firestore_collections.dart';
import '../models/app_notification.dart';
import '../services/firestore_service.dart';

class NotificationRepository {
  NotificationRepository({FirestoreService? firestoreService})
    : _firestoreService = firestoreService ?? FirestoreService();

  final FirestoreService _firestoreService;

  Future<String> createNotification(AppNotification notification) async {
    final doc = await _firestoreService.add(
      FirestoreCollections.notifications,
      notification.toMap(),
    );
    return doc.id;
  }

  Future<void> markAsRead(String notificationId) {
    return _firestoreService.update(
      FirestoreCollections.notifications,
      notificationId,
      {'read': true},
    );
  }

  Stream<List<AppNotification>> watchNotificationsForUser(String userId) {
    return _firestoreService
        .streamCollection(
          FirestoreCollections.notifications,
          queryBuilder: (q) => q
              .where('userId', isEqualTo: userId)
              .orderBy('createdAt', descending: true),
        )
        .map((snapshot) => snapshot.docs.map(AppNotification.fromFirestore).toList());
  }

  Stream<int> watchUnreadCount(String userId) {
    return _firestoreService
        .streamCollection(
          FirestoreCollections.notifications,
          queryBuilder: (q) =>
              q.where('userId', isEqualTo: userId).where('read', isEqualTo: false),
        )
        .map((snapshot) => snapshot.docs.length);
  }
}
