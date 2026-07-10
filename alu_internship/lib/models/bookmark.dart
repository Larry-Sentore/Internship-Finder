// Data model linking a student to an opportunity they've saved.
import 'package:cloud_firestore/cloud_firestore.dart';

class Bookmark {
  final String id;
  final String studentId;
  final String opportunityId;
  final DateTime? createdAt;

  const Bookmark({
    required this.id,
    required this.studentId,
    required this.opportunityId,
    this.createdAt,
  });

  static String idFor(String studentId, String opportunityId) =>
      '${studentId}_$opportunityId';

  Map<String, dynamic> toMap() {
    return {
      'studentId': studentId,
      'opportunityId': opportunityId,
      'createdAt': FieldValue.serverTimestamp(),
    };
  }

  factory Bookmark.fromMap(String id, Map<String, dynamic> map) {
    return Bookmark(
      id: id,
      studentId: map['studentId'] as String? ?? '',
      opportunityId: map['opportunityId'] as String? ?? '',
      createdAt: (map['createdAt'] as Timestamp?)?.toDate(),
    );
  }

  factory Bookmark.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    return Bookmark.fromMap(doc.id, doc.data() ?? {});
  }
}
