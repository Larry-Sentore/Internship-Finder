// Data model for an internship/opportunity posting.
import 'package:cloud_firestore/cloud_firestore.dart';

enum OpportunityCategory {
  softwareDevelopment,
  design,
  marketing,
  operations,
  research,
  businessAnalysis,
  contentCreation,
  communityManagement,
  other,
}

extension OpportunityCategoryX on OpportunityCategory {
  String get value => name;

  static OpportunityCategory fromValue(String? value) {
    return OpportunityCategory.values.firstWhere(
      (c) => c.name == value,
      orElse: () => OpportunityCategory.other,
    );
  }
}

enum OpportunityStatus { open, closed }

extension OpportunityStatusX on OpportunityStatus {
  String get value => name;

  static OpportunityStatus fromValue(String? value) {
    return OpportunityStatus.values.firstWhere(
      (s) => s.name == value,
      orElse: () => OpportunityStatus.open,
    );
  }
}

class Opportunity {
  final String id;
  final String startupId;
  final String postedBy;
  final String title;
  final String description;
  final OpportunityCategory category;
  final List<String> skillsRequired;
  final String commitment;
  final String location;
  final OpportunityStatus status;
  final DateTime? applicationDeadline;
  final DateTime? createdAt;

  const Opportunity({
    required this.id,
    required this.startupId,
    required this.postedBy,
    required this.title,
    required this.description,
    this.category = OpportunityCategory.other,
    this.skillsRequired = const [],
    this.commitment = '',
    this.location = '',
    this.status = OpportunityStatus.open,
    this.applicationDeadline,
    this.createdAt,
  });

  bool get isOpen => status == OpportunityStatus.open;

  Opportunity copyWith({
    String? title,
    String? description,
    OpportunityCategory? category,
    List<String>? skillsRequired,
    String? commitment,
    String? location,
    OpportunityStatus? status,
    DateTime? applicationDeadline,
  }) {
    return Opportunity(
      id: id,
      startupId: startupId,
      postedBy: postedBy,
      title: title ?? this.title,
      description: description ?? this.description,
      category: category ?? this.category,
      skillsRequired: skillsRequired ?? this.skillsRequired,
      commitment: commitment ?? this.commitment,
      location: location ?? this.location,
      status: status ?? this.status,
      applicationDeadline: applicationDeadline ?? this.applicationDeadline,
      createdAt: createdAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'startupId': startupId,
      'postedBy': postedBy,
      'title': title,
      'description': description,
      'category': category.value,
      'skillsRequired': skillsRequired,
      'commitment': commitment,
      'location': location,
      'status': status.value,
      'applicationDeadline': applicationDeadline == null
          ? null
          : Timestamp.fromDate(applicationDeadline!),
      'createdAt': createdAt == null
          ? FieldValue.serverTimestamp()
          : Timestamp.fromDate(createdAt!),
    };
  }

  factory Opportunity.fromMap(String id, Map<String, dynamic> map) {
    return Opportunity(
      id: id,
      startupId: map['startupId'] as String? ?? '',
      postedBy: map['postedBy'] as String? ?? '',
      title: map['title'] as String? ?? '',
      description: map['description'] as String? ?? '',
      category: OpportunityCategoryX.fromValue(map['category'] as String?),
      skillsRequired: List<String>.from(
        map['skillsRequired'] as List? ?? const [],
      ),
      commitment: map['commitment'] as String? ?? '',
      location: map['location'] as String? ?? '',
      status: OpportunityStatusX.fromValue(map['status'] as String?),
      applicationDeadline: (map['applicationDeadline'] as Timestamp?)
          ?.toDate(),
      createdAt: (map['createdAt'] as Timestamp?)?.toDate(),
    );
  }

  factory Opportunity.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    return Opportunity.fromMap(doc.id, doc.data() ?? {});
  }
}
