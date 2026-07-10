// Data model for an in-app notification.
import 'package:cloud_firestore/cloud_firestore.dart';

enum NotificationType {
  applicationStatusChanged,
  newApplicant,
  newMessage,
  startupVerification,
  general,
}

extension NotificationTypeX on NotificationType {
  String get value => name;

  static NotificationType fromValue(String? value) {
    return NotificationType.values.firstWhere(
      (t) => t.name == value,
      orElse: () => NotificationType.general,
    );
  }
}

class AppNotification {
  final String id;
  final String userId;
  final NotificationType type;
  final String title;
  final String body;
  final String? relatedId;
  final bool read;
  final DateTime? createdAt;

  const AppNotification({
    required this.id,
    required this.userId,
    required this.type,
    required this.title,
    required this.body,
    this.relatedId,
    this.read = false,
    this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'type': type.value,
      'title': title,
      'body': body,
      'relatedId': relatedId,
      'read': read,
      'createdAt': FieldValue.serverTimestamp(),
    };
  }

  factory AppNotification.fromMap(String id, Map<String, dynamic> map) {
    return AppNotification(
      id: id,
      userId: map['userId'] as String? ?? '',
      type: NotificationTypeX.fromValue(map['type'] as String?),
      title: map['title'] as String? ?? '',
      body: map['body'] as String? ?? '',
      relatedId: map['relatedId'] as String?,
      read: map['read'] as bool? ?? false,
      createdAt: (map['createdAt'] as Timestamp?)?.toDate(),
    );
  }

  factory AppNotification.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    return AppNotification.fromMap(doc.id, doc.data() ?? {});
  }
}
