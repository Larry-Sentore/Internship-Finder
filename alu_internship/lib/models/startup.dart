// Data model for a startup/organization profile, including verification status.
import 'package:cloud_firestore/cloud_firestore.dart';

enum VerificationStatus { pending, verified, rejected }

extension VerificationStatusX on VerificationStatus {
  String get value => name;

  static VerificationStatus fromValue(String? value) {
    return VerificationStatus.values.firstWhere(
      (s) => s.name == value,
      orElse: () => VerificationStatus.pending,
    );
  }
}

class Startup {
  final String id;
  final String ownerId;
  final String name;
  final String description;
  final String? logoUrl;
  final String? website;
  final String industry;
  final VerificationStatus verificationStatus;
  final DateTime? createdAt;

  const Startup({
    required this.id,
    required this.ownerId,
    required this.name,
    required this.description,
    this.logoUrl,
    this.website,
    this.industry = '',
    this.verificationStatus = VerificationStatus.pending,
    this.createdAt,
  });

  bool get isVerified => verificationStatus == VerificationStatus.verified;

  Startup copyWith({
    String? name,
    String? description,
    String? logoUrl,
    String? website,
    String? industry,
    VerificationStatus? verificationStatus,
  }) {
    return Startup(
      id: id,
      ownerId: ownerId,
      name: name ?? this.name,
      description: description ?? this.description,
      logoUrl: logoUrl ?? this.logoUrl,
      website: website ?? this.website,
      industry: industry ?? this.industry,
      verificationStatus: verificationStatus ?? this.verificationStatus,
      createdAt: createdAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'ownerId': ownerId,
      'name': name,
      'description': description,
      'logoUrl': logoUrl,
      'website': website,
      'industry': industry,
      'verificationStatus': verificationStatus.value,
      'createdAt': createdAt == null
          ? FieldValue.serverTimestamp()
          : Timestamp.fromDate(createdAt!),
    };
  }

  factory Startup.fromMap(String id, Map<String, dynamic> map) {
    return Startup(
      id: id,
      ownerId: map['ownerId'] as String? ?? '',
      name: map['name'] as String? ?? '',
      description: map['description'] as String? ?? '',
      logoUrl: map['logoUrl'] as String?,
      website: map['website'] as String?,
      industry: map['industry'] as String? ?? '',
      verificationStatus: VerificationStatusX.fromValue(
        map['verificationStatus'] as String?,
      ),
      createdAt: (map['createdAt'] as Timestamp?)?.toDate(),
    );
  }

  factory Startup.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    return Startup.fromMap(doc.id, doc.data() ?? {});
  }
}
