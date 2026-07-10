// Firestore data-access layer for reading/writing applications.
import '../core/constants/firestore_collections.dart';
import '../models/application.dart';
import '../services/firestore_service.dart';

class DuplicateApplicationException implements Exception {
  const DuplicateApplicationException();

  @override
  String toString() => 'You have already applied to this opportunity.';
}

class ApplicationRepository {
  ApplicationRepository({FirestoreService? firestoreService})
    : _firestoreService = firestoreService ?? FirestoreService();

  final FirestoreService _firestoreService;

  Future<String> submitApplication(Application application) async {
    if (await hasApplied(application.studentId, application.opportunityId)) {
      throw const DuplicateApplicationException();
    }
    final doc = await _firestoreService.add(
      FirestoreCollections.applications,
      application.toMap(),
    );
    return doc.id;
  }

  Future<void> updateStatus(String id, ApplicationStatus status) {
    return _firestoreService.update(FirestoreCollections.applications, id, {
      'status': status.value,
    });
  }

  Future<void> withdrawApplication(String id) {
    return updateStatus(id, ApplicationStatus.withdrawn);
  }

  Future<bool> hasApplied(String studentId, String opportunityId) async {
    final snapshot = await _firestoreService.getCollection(
      FirestoreCollections.applications,
      queryBuilder: (q) => q
          .where('studentId', isEqualTo: studentId)
          .where('opportunityId', isEqualTo: opportunityId)
          .limit(1),
    );
    return snapshot.docs.isNotEmpty;
  }

  Stream<List<Application>> watchApplicationsByStudent(String studentId) {
    return _firestoreService
        .streamCollection(
          FirestoreCollections.applications,
          queryBuilder: (q) => q
              .where('studentId', isEqualTo: studentId)
              .orderBy('appliedAt', descending: true),
        )
        .map((snapshot) => snapshot.docs.map(Application.fromFirestore).toList());
  }

  Stream<List<Application>> watchApplicationsByOpportunity(
    String opportunityId,
  ) {
    return _firestoreService
        .streamCollection(
          FirestoreCollections.applications,
          queryBuilder: (q) => q
              .where('opportunityId', isEqualTo: opportunityId)
              .orderBy('appliedAt', descending: true),
        )
        .map((snapshot) => snapshot.docs.map(Application.fromFirestore).toList());
  }

  Stream<List<Application>> watchApplicationsByStartup(String startupId) {
    return _firestoreService
        .streamCollection(
          FirestoreCollections.applications,
          queryBuilder: (q) => q
              .where('startupId', isEqualTo: startupId)
              .orderBy('appliedAt', descending: true),
        )
        .map((snapshot) => snapshot.docs.map(Application.fromFirestore).toList());
  }
}
