// Data model for a student's extended profile (skills, interests, portfolio).
import 'package:cloud_firestore/cloud_firestore.dart';

class StudentProfile {
  final String uid;
  final String bio;
  final List<String> skills;
  final List<String> interests;
  final String? resumeUrl;
  final List<String> portfolioLinks;
  final DateTime? updatedAt;

  const StudentProfile({
    required this.uid,
    this.bio = '',
    this.skills = const [],
    this.interests = const [],
    this.resumeUrl,
    this.portfolioLinks = const [],
    this.updatedAt,
  });

  StudentProfile copyWith({
    String? bio,
    List<String>? skills,
    List<String>? interests,
    String? resumeUrl,
    List<String>? portfolioLinks,
  }) {
    return StudentProfile(
      uid: uid,
      bio: bio ?? this.bio,
      skills: skills ?? this.skills,
      interests: interests ?? this.interests,
      resumeUrl: resumeUrl ?? this.resumeUrl,
      portfolioLinks: portfolioLinks ?? this.portfolioLinks,
      updatedAt: updatedAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'bio': bio,
      'skills': skills,
      'interests': interests,
      'resumeUrl': resumeUrl,
      'portfolioLinks': portfolioLinks,
      'updatedAt': FieldValue.serverTimestamp(),
    };
  }

  factory StudentProfile.fromMap(String uid, Map<String, dynamic> map) {
    return StudentProfile(
      uid: uid,
      bio: map['bio'] as String? ?? '',
      skills: List<String>.from(map['skills'] as List? ?? const []),
      interests: List<String>.from(map['interests'] as List? ?? const []),
      resumeUrl: map['resumeUrl'] as String?,
      portfolioLinks: List<String>.from(
        map['portfolioLinks'] as List? ?? const [],
      ),
      updatedAt: (map['updatedAt'] as Timestamp?)?.toDate(),
    );
  }

  factory StudentProfile.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    return StudentProfile.fromMap(doc.id, doc.data() ?? {});
  }
}
