// Data model for a student's application/interest submission to an opportunity.
import 'package:cloud_firestore/cloud_firestore.dart';

enum ApplicationStatus { pending, underReview, accepted, rejected, withdrawn }

extension ApplicationStatusX on ApplicationStatus {
  String get value => name;

  static ApplicationStatus fromValue(String? value) {
    return ApplicationStatus.values.firstWhere(
      (s) => s.name == value,
      orElse: () => ApplicationStatus.pending,
    );
  }
}

class Application {
  final String id;
  final String opportunityId;
  final String startupId;
  final String studentId;
  final ApplicationStatus status;
  final String coverNote;
  final String? resumeUrl;
  final DateTime? appliedAt;
  final DateTime? updatedAt;

  const Application({
    required this.id,
    required this.opportunityId,
    required this.startupId,
    required this.studentId,
    this.status = ApplicationStatus.pending,
    this.coverNote = '',
    this.resumeUrl,
    this.appliedAt,
    this.updatedAt,
  });

  Application copyWith({ApplicationStatus? status}) {
    return Application(
      id: id,
      opportunityId: opportunityId,
      startupId: startupId,
      studentId: studentId,
      status: status ?? this.status,
      coverNote: coverNote,
      resumeUrl: resumeUrl,
      appliedAt: appliedAt,
      updatedAt: updatedAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'opportunityId': opportunityId,
      'startupId': startupId,
      'studentId': studentId,
      'status': status.value,
      'coverNote': coverNote,
      'resumeUrl': resumeUrl,
      'appliedAt': appliedAt == null
          ? FieldValue.serverTimestamp()
          : Timestamp.fromDate(appliedAt!),
      'updatedAt': FieldValue.serverTimestamp(),
    };
  }

  factory Application.fromMap(String id, Map<String, dynamic> map) {
    return Application(
      id: id,
      opportunityId: map['opportunityId'] as String? ?? '',
      startupId: map['startupId'] as String? ?? '',
      studentId: map['studentId'] as String? ?? '',
      status: ApplicationStatusX.fromValue(map['status'] as String?),
      coverNote: map['coverNote'] as String? ?? '',
      resumeUrl: map['resumeUrl'] as String?,
      appliedAt: (map['appliedAt'] as Timestamp?)?.toDate(),
      updatedAt: (map['updatedAt'] as Timestamp?)?.toDate(),
    );
  }

  factory Application.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    return Application.fromMap(doc.id, doc.data() ?? {});
  }
}
